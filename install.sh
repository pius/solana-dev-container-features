#!/bin/bash
set -e

# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in ${POSSIBLE_USERS[@]}; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

# The install.sh script is the installation entrypoint for any dev container 'features' in this repository. 
#
# The tooling will parse the devcontainer-features.json + user devcontainer, and write 
# any build-time arguments into a feature-set scoped "devcontainer-features.env"
# The author is free to source that file and use it however they would like.
set -a
. ./devcontainer-features.env
set +a


if [ ! -z ${_BUILD_ARG_SOLANA} ]; then
    echo "Activating feature 'solana'"

    apt-get update
    apt-get -y install --no-install-recommends libudev-dev build-essential curl pkg-config libssl-dev
    # Build args are exposed to this entire feature set following the pattern:  _BUILD_ARG_<FEATURE ID>_<OPTION NAME>
    SOLANA_VERSION=${_BUILD_ARG_SOLANA_VERSION:-undefined}

    su - ${USERNAME} -c "$(curl -sSfL https://release.solana.com/v${SOLANA_VERSION}/install)"
    export CARGO_HOME="/usr/local/cargo"
    export RUSTUP_HOME="/usr/local/rustup"
    export SOLANA_HOME="/${USERNAME}/.local/share/solana/install/active_release"
    export PATH=${CARGO_HOME}/bin:${PATH}
    export PATH=${SOLANA_HOME}/bin:${PATH}
    #!/bin/bash
set -e

# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in ${POSSIBLE_USERS[@]}; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

# The install.sh script is the installation entrypoint for any dev container 'features' in this repository. 
#
# The tooling will parse the devcontainer-features.json + user devcontainer, and write 
# any build-time arguments into a feature-set scoped "devcontainer-features.env"
# The author is free to source that file and use it however they would like.
set -a
. ./devcontainer-features.env
set +a


if [ ! -z ${_BUILD_ARG_SOLANA} ]; then
    echo "Activating feature 'solana'"

    apt-get update
    apt-get -y install --no-install-recommends libudev-dev build-essential curl pkg-config libssl-dev
    # Build args are exposed to this entire feature set following the pattern:  _BUILD_ARG_<FEATURE ID>_<OPTION NAME>
    SOLANA_VERSION=${_BUILD_ARG_SOLANA_VERSION:-undefined}

    su - ${USERNAME} -c "$(curl -sSfL https://release.solana.com/v${SOLANA_VERSION}/install)"
    export CARGO_HOME="/usr/local/cargo"
    export RUSTUP_HOME="/usr/local/rustup"
    export SOLANA_HOME="/$/.local/share/solana/install/active_release"
    export PATH=${CARGO_HOME}/bin:${PATH}
    export PATH=${SOLANA_HOME}/bin:${PATH}

    cargo install spl-token-cli

    su - ${USERNAME} -c 'solana config set --url localhost'    
    su - ${USERNAME} -c 'npm i -g @project-serum/anchor-cli'
    
fi


    cargo install spl-token-cli

    su - ${USERNAME} -c 'solana config set --url localhost'    
    su - ${USERNAME} -c 'npm i -g @project-serum/anchor-cli'
    
fi
