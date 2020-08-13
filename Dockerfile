# multi-stageは3系から
# poetry config virturalenv.config falseにしてるからpoetry run が必要ない？
# FROM python:3.7-slim as production
# FROM ubuntu:18.04
FROM python:3.7-slim

ENV PYTHONUNBUFFERED=1

# コンテナ内部の作業ディレクトリの変更
WORKDIR /root/work

# work/ にlockファイルとtomlファイルコピー
COPY poetry.lock pyproject.toml ./

# multi stage build -> referece[2]
# poetryでdocker内に仮想環境を作らない
# RUN pip3 install poetry  \
#    && poetry config virtualenvs.create false \
#    && poetry install --no-dev

# =================== ここから開発用 =====================
# FROM production as development

# コンテナ内部の作業ディレクトリの変更
# WORKDIR /work
# work/ にlockファイルとtomlファイルコピー
# COPY poetry.lock pyproject.toml ./

RUN apt-get update \
    && apt-get install -y \
        cmake \
        wget \
        curl \
        git \
        texlive-latex-recommended  \
        zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* # clean up


# jupyterlabのextensionに必要
RUN apt-get update && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/* # clean up

# ============= 開発に必要な python モジュール =============
# tomlに記載のあるパッケージのインストール
RUN pip3 install poetry \
    # language server
    "python-language-server[all]" \
    && poetry config virtualenvs.create false \
    && poetry install


# ============= ここから jupyter の設定 ================
# --dev で開発用パッケージとして依存関係を固定する
RUN poetry add --dev jupyter \
    # jupyterlab \
    nodejs \
    jupytext \
    jupyter-contrib-nbextensions \
    jupyter-nbextensions-configurator \
    jupyterlab_code_formatter autopep8 black

# jupyterの設定：jupytextの設定を生成したconfig.pyの末尾に追加
RUN jupyter notebook --generate-config && \
    echo "\
c.ContentsManager.default_jupytext_formats = 'ipynb,py'\n\
c.NotebookApp.contents_manager_class = 'jupytext.TextFileContentsManager'\n\
c.NotebookApp.open_browser = False\n\
" >> ${HOME}/.jupyter/jupyter_notebook_config.py

# jupyter notebook extension
RUN poetry run jupyter contrib nbextension install --user && \
    poetry run jupyter nbextensions_configurator enable --user && \
    # enable extensions what you want
    poetry run jupyter nbextension enable select_keymap/main && \
    poetry run jupyter nbextension enable highlight_selected_word/main && \
    poetry run jupyter nbextension enable toggle_all_line_numbers/main && \
    poetry run jupyter nbextension enable varInspector/main && \
    poetry run jupyter nbextension enable toc2/main && \
    poetry run jupyter nbextension enable equation-numbering/main && \
    poetry run jupyter nbextension enable execute_time/ExecuteTime && \
    echo Done

# jupyter lab extension
RUN poetry run jupyter labextension install @lckr/jupyterlab_variableinspector && \
    poetry run jupyter labextension install @jupyterlab/toc && \
    poetry run jupyter nbextension enable --py widgetsnbextension && \
    poetry run jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    # poetry run jupyter labextension install @z-m-k/jupyterlab_sublime && \
    poetry run jupyter labextension install @ryantam626/jupyterlab_code_formatter && \
    poetry run jupyter serverextension enable --py jupyterlab_code_formatter && \
    poetry run jupyter labextension install jupyterlab-theme-solarized-dark && \
    poetry run jupyter labextension install @krassowski/jupyterlab-lsp
    # poetry run jupyter labextension install @hokyjack/jupyterlab-monokai-plus && \
    # echo "Done2

# default の formatter : brack
RUN mkdir -p /root/.jupyter/lab/user-settings/@ryantam626/jupyterlab_code_formatter && echo '\
{\n\
    "preferences": {\n\
        "default_formatter": {\n\
            "python": "black",\n\
        }\n\
    }\n\
}\n\    
\
'>> /root/.jupyter/lab/user-settings/@ryantam626/jupyterlab_code_formatter/settings.jupyterlab-settings

# default で line number
RUN mkdir -p /root/.jupyter/lab/user-settings/@jupyterlab/notebook-extension && echo '\
{\n\
    "codeCellConfig": {\n\
        "lineNumbers": true,\n\
    },\n\
}\n\
\
' >> /root/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings

