#!/bin/bash

brew update
HOMEBREW_NO_AUTO_UPDATE=1

tmp_kde=/tmp/kde
dep_map="${tmp_kde}/dep_map"
bundle="${tmp_kde}/Brewfile"
install_order="${tmp_kde}/install_order"

rm -f "${dep_map}" "${install_order}" "${bundle}"
mkdir -p "${tmp_kde}"

formuladir="$(brew --repo ansatzX/homebrew-kde)/Formula"

for formula in "${formuladir}"/*.rb; do
  formulaname=`basename "${formula}"`
  for dep in `grep "depends_on \"ansatzX/homebrew-kde" "${formula}" | awk -F "\"" '{print $2}'`; do
    echo "${dep/kde-mac\/kde\//} ${formulaname//\.rb/}" >> "${dep_map}"
  done
  echo "${formulaname//\.rb/}" >> "${dep_map}"
done

tsort "${dep_map}" > "${install_order}" 2> /dev/null

for candidate_formula in `cat "${install_order}"`; do
    formula_path="${formuladir}/${candidate_formula}.rb"
    if grep -q -E -l 'url "http|url "file' "${formula_path}"; then
      echo "brew \"ansatzX/homebrew-kde/${candidate_formula}\"" >> "${bundle}"
    else
      echo "brew \"ansatzX/homebrew-kde/${candidate_formula}\", args: [\"HEAD\"]" >> "${bundle}"
    fi
done

casksadir="$(brew --repo ansatzX/homebrew-kde)/Casks"

for cask in "${casksadir}"/*.rb; do
  caskname=`basename "${cask}"`
  echo "cask \"ansatzX/homebrew-kde/${caskname//\.rb/}\"" >> "${bundle}"
done

brew bundle --verbose --file "${bundle}"
