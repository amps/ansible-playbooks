pydirs=$(python -c "import site; prefixes = [site.USER_BASE]; prefixes = [s + '/bin/' for s in prefixes]; print(':'.join(prefixes))")
PATH="$pydirs:$PATH"
ANSIBLE_LIBRARY=./ansible-std-lib/ ansible-playbook --ask-vault-pass -i hosts $@