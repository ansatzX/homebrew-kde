#!/bin/bash

HOMEBREW_NO_AUTO_UPDATE=1
INSTALLED_FORMULAS_LIST=/tmp/kde/installed_formulas
KDE_CASKS_LIST=/tmp/kde/installed_casks
mkdir -p /tmp/kde/

brew ls --formula --full-name > "${INSTALLED_FORMULAS_LIST}"

if grep -q '^ansatzX/homebrew-kde' "${INSTALLED_FORMULAS_LIST}"; then
	echo "Uninstalling formulas from ansatzX/homebrew-kde tap"
	brew uninstall -f `grep '^ansatzX/homebrew-kde' "${INSTALLED_FORMULAS_LIST}"`
else
	echo "No formulas from ansatzX/homebrew-kde tap is installed"
fi

CORE_FORMULAS=(
	threadweaver
	kdoctools
	ki18n
	karchive
	extra-cmake-modules
)

echo "Removing KDE formulas from homebrew/core if any installed"

for CORE_FORMULA in "${CORE_FORMULAS[@]}"; do
	if grep -q "${CORE_FORMULA}" "${INSTALLED_FORMULAS_LIST}"; then
		brew uninstall -f --formula "${CORE_FORMULA}"
	fi
done

brew ls --cask --full-name | grep '^ansatzX/homebrew-kde' > "${KDE_CASKS_LIST}"

if [[ -f "${KDE_CASKS_LIST}" ]]; then
	echo "Uninstalling casks from ansatzX/homebrew-kde tap"
	xargs brew uninstall -f < "${KDE_CASKS_LIST}"
else
	echo "No casks from ansatzX/homebrew-kde tap is installed"
fi

rm "${INSTALLED_FORMULAS_LIST}" "${KDE_CASKS_LIST}"
# echo "Cleaning ~/Applications/KDE"
# rm -rf "${HOME}"/Applications/KDE
