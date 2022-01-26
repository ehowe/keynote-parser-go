#!/bin/bash

yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }

SED="${SED:-/usr/bin/env sed}"

${SED} --version > /dev/null 2>&1

if [[ $? -ne 0 ]]; then
  die "Sed does not appear to be GNU sed. Pass SED=/path/to/gnu/sed to override"
fi

git diff --name-only HEAD | grep '^definitions/.*.proto'

if [[ $? -ne 0 ]]; then
  if [ ! ${FORCE} ]; then
    die "There are no untracked changes to the protobufs. Only run this script if you are updating them from the python keynote-parser project"
  fi
fi

insert_line_before () {
  awk -vpattern="$1" -vline="$2" '$0 ~ pattern {print line; print; next} 1' $3 > $3.tmp
  mv $3.tmp $3
}

remove_line_matching () {
  ${SED} -i -E "/${1}/d" ${2}
}

replace_prefixes () {
  for prefix in $1; do
    for suffix in $3; do
      if [ -z ${4} ]; then
        newmessagename=${prefix}${2}
      else
        newmessagename=${4}${2}
      fi

      if [ -f definitions/${prefix}${suffix}.proto ]; then
        ${SED} -i -E "s/message $2 \{/message ${newmessagename} \{/" definitions/${prefix}${suffix}.proto
        ${SED} -i -E "s/\.${prefix}\.$2/.${prefix}.${newmessagename}/" definitions/*.proto
      fi
    done
  done
}

if ! command -v protoc &> /dev/null; then
  die "Cannot find protoc binary in PATH"
fi

if ! command -v protoc-gen-go &> /dev/null; then
  die "Cannot find protoc-gen-go binary in PATH"
fi

${SED} -i -E '/^(option )?go_package/d' definitions/*.proto
${SED} -i "2 a option go_package = './kpb';" definitions/*.proto

rm -rf private/iwa/kpb

# Fix go namespace clashes
replace_prefixes "TSA KN TSK" "DocumentArchive" "Archives"
replace_prefixes "KN TSA" "InducedVerifyDrawableZOrdersWithServerCommandArchive" "CommandArchives_sos"

replace_prefixes "TSCH TSCHPreUFF" "ChartStyleArchive" "Archives"
replace_prefixes "TSCH TSCHPreUFF" "ChartNonStyleArchive" "Archives"
replace_prefixes "TSCH TSCHPreUFF" "LegendStyleArchive" "Archives"
replace_prefixes "TSCH TSCHPreUFF" "LegendNonStyleArchive" "Archives"
replace_prefixes "TSCH TSCHPreUFF" "ChartAxisStyleArchive" "Archives"
replace_prefixes "TSCH TSCHPreUFF" "ChartAxisNonStyleArchive" "Archives"
replace_prefixes "TSCH TSCHPreUFF" "ChartSeriesStyleArchive" "Archives"
replace_prefixes "TSCH TSCHPreUFF" "ChartSeriesNonStyleArchive" "Archives"

replace_prefixes "TSCH" "ChartStyleArchive" "Archives_Common" "TSCHCommon"
replace_prefixes "TSCH" "ChartNonStyleArchive" "Archives_Common" "TSCHCommon"
replace_prefixes "TSCH" "LegendStyleArchive" "Archives_Common" "TSCHCommon"
replace_prefixes "TSCH" "LegendNonStyleArchive" "Archives_Common" "TSCHCommon"
replace_prefixes "TSCH" "ChartAxisStyleArchive" "Archives_Common" "TSCHCommon"
replace_prefixes "TSCH" "ChartAxisNonStyleArchive" "Archives_Common" "TSCHCommon"
replace_prefixes "TSCH" "ChartSeriesStyleArchive" "Archives_Common" "TSCHCommon"
replace_prefixes "TSCH" "ChartSeriesNonStyleArchive" "Archives_Common" "TSCHCommon"
replace_prefixes "TSCH" "ReferenceLineStyleArchive" "Archives_Common" "TSCHCommon"
replace_prefixes "TSCH" "ReferenceLineNonStyleArchive" "Archives_Common" "TSCHCommon"
replace_prefixes "TSCH" "ChartStyleArchive" "Archives_GEN" "TSCHGen"
replace_prefixes "TSCH" "ChartNonStyleArchive" "Archives_GEN", "TSCHGen"
replace_prefixes "TSCH" "LegendStyleArchive" "Archives_GEN", "TSCHGen"
replace_prefixes "TSCH" "LegendNonStyleArchive" "Archives_GEN", "TSCHGen"
replace_prefixes "TSCH" "ChartAxisStyleArchive" "Archives_GEN", "TSCHGen"
replace_prefixes "TSCH" "ChartAxisNonStyleArchive" "Archives_GEN", "TSCHGen"
replace_prefixes "TSCH" "ChartSeriesStyleArchive" "Archives_GEN", "TSCHGen"
replace_prefixes "TSCH" "ChartSeriesNonStyleArchive" "Archives_GEN", "TSCHGen"
replace_prefixes "TSCH" "ReferenceLineStyleArchive" "Archives_GEN", "TSCHGen"
replace_prefixes "TSCH" "ReferenceLineNonStyleArchive" "Archives_GEN", "TSCHGen"

replace_prefixes "TSCHPreUFF" "ChartGridArchive" "Archives"

replace_prefixes "TSWP" "CharacterStyleChangePropertyCommand_GArchive" "CommandArchives_sos" "TSWPSOS"
replace_prefixes "TSWP" "ParagraphStyleChangePropertyCommand_GArchive" "CommandArchives_sos" "TSWPSOS"
replace_prefixes "TSWP" "CharacterStylePropertyChangeSetArchive" "Archives_sos" "TSWPSOS"
replace_prefixes "TSWP" "ParagraphStylePropertyChangeSetArchive" "Archives_sos" "TSWPSOS"

replace_prefixes "TSWP" "CharacterStyleChangePropertyCommand_GArchive" "CommandArchives"
replace_prefixes "TSWP" "ParagraphStyleChangePropertyCommand_GArchive" "CommandArchives"
replace_prefixes "TSWP" "SelectionArchive" "Archives"
replace_prefixes "TSWP" "PencilAnnotationArchive" "Archives"
replace_prefixes "TSWP" "ShapeStylePropertiesArchive" "Archives"
replace_prefixes "TSWP" "ShapeStyleArchive" "Archives"
replace_prefixes "TSWP" "Default_ShapeStyleArchive_OverrideCount" "Archives"
replace_prefixes "TSWP" "ThemePresetsArchive" "Archives"
replace_prefixes "TSWP" "E_ThemePresetsArchive_Extension" "Archives"
replace_prefixes "TSWP" "ShapeApplyPresetCommandArchive" "CommandArchives"
replace_prefixes "TSWP" "StyleUpdatePropertyMapCommandArchive" "CommandArchives"
replace_prefixes "TSWP" "ShapeStyleSetValueCommandArchive" "CommandArchives"
replace_prefixes "TSWP" "PencilAnnotationSelectionTransformerArchive" "CommandArchives"
replace_prefixes "TSWP" "ShapeSelectionTransformerArchive" "CommandArchives"

replace_prefixes "TSD" "ThemePresetsArchive" "Archives"
replace_prefixes "TSD" "E_ThemePresetsArchive_Extension" "Archives"
replace_prefixes "TSD" "CanvasSelectionArchive" "Archives"

replace_prefixes "TSD" "UndoObjectArchive" "CommandArchives"
replace_prefixes "TSD" "CanvasSelectionTransformerArchive" "CommandArchives"

replace_prefixes "TSK" "FormatStructArchive" "Archives"

replace_prefixes "TSS" "ThemeArchive" "Archives"
replace_prefixes "TSS" "StyleUpdatePropertyMapCommandArchive" "Archives"

replace_prefixes "TST" "FormulaArchive" "Archives"
replace_prefixes "TST" "PencilAnnotationArchive" "Archives"
replace_prefixes "TST" "CommandReplaceCustomFormatArchive" "CommandArchives"
replace_prefixes "TST" "ThemePresetsArchive" "StylePropertyArchiving"
replace_prefixes "TST" "E_ThemePresetsArchive_Extension" "StylePropertyArchiving"

remove_line_matching "TSKArchives.proto" "definitions/TSWPArchives.proto"
remove_line_matching "TSKArchives.proto" "definitions/TSTStylePropertyArchiving.proto"
remove_line_matching "TSTArchives.proto" "definitions/TSAArchives.proto"
remove_line_matching "TSKArchives.proto" "definitions/TSCHArchives_Common.proto"
remove_line_matching "TSKArchives.proto" "definitions/TSCHPreUFFArchives.proto"
remove_line_matching "TSSArchives.proto" "definitions/TSCHArchives_GEN.proto"
remove_line_matching "TSCHArchives_GEN.proto" "definitions/TSCHArchives.proto"
remove_line_matching "TSCHPreUFFArchives.proto" "definitions/TSCHArchives.proto"
remove_line_matching "TSCH3DArchives.proto" "definitions/TSCHArchives.proto"
remove_line_matching "TSCHPreUFFArchives.protoTSCH3DArchives.proto" "definitions/TSCHArchives.proto"
remove_line_matching "TSWPArchives.proto" "definitions/KNCommandArchives.proto"
remove_line_matching "TSAArchives.proto" "definitions/KNCommandArchives.proto"
remove_line_matching "TSTArchives.proto" "definitions/KNCommandArchives.proto"

remove_line_matching "TSCH3DArchives.proto" "definitions/TSCHCommandArchives.proto"
remove_line_matching "TSDArchives.proto" "definitions/TSCHCommandArchives.proto"
remove_line_matching "TSSArchives.proto" "definitions/TSTCommandArchives.proto"
remove_line_matching "TSDArchives.proto" "definitions/TSTCommandArchives.proto"

# Manual fixes
if [ ! ${SKIP_MANUAL_SED} ]; then
  ${SED} -i -E 's/TSCH.TSCH([a-zA-Z]*)/TSCH.TSCHCommon\1/g' definitions/TSCHArchives.proto
  ${SED} -i -E 's/TSCH.TSCH(Chart|ChartNon|Legend|LegendNon|ChartAxis|ChartAxisNon|ChartSeries|ChartSeriesNon|ReferenceLine|ReferenceLineNon)(StyleArchive)([a-zA-Z]*)/TSCH.TSCHCommon\1\2\3/g' definitions/TSCHArchives_GEN.proto
  ${SED} -i -E 's/\.TSCH.Generated.(.*)/.TSCH.TSCHCommon\1/g' definitions/TSCHArchives_GEN.proto
  ${SED} -i -E 's/\.TSASOS.(InducedVerifyDrawableZOrdersWithServerCommandArchive)(.*)/.TSASOS.TSA\1\2/g' definitions/KNCommandArchives_sos.proto
  ${SED} -i -E 's/\.TSWPSOS.(Character|Paragraph)(StylePropertyChangeSetArchive)(.*)/.TSWPSOS.TSWPSOS\1\2\3/g' definitions/TSWPArchives_sos.proto definitions/TSWPCommandArchives.proto
  ${SED} -i -E 's/\.TSWP\.TSWPSOS(.*)/\.TSWPSOS\.TSWPSOS\1/' definitions/TSWPCommandArchives_sos.proto
  ${SED} -i -E 's/\.TSCH\.PreUFF.ChartGridArchive/.TSCH.PreUFF.TSCHPreUFFChartGridArchive/' definitions/TSCHPreUFFArchives.proto
fi

protoc -I ./definitions --go_out private/iwa definitions/*.proto

cd private/iwa/kpb

go mod init kpb
go mod tidy

cd ../

echo "Removing kpb references from iwa go.mod"
${SED} -i -E "/\skpb\sv0.0.0/d" go.mod

if [[ $(grep -E -L "replace\skpb\s" go.mod) ]]; then
  insert_line_before "^require" "replace kpb v0.0.0 => ./kpb" "go.mod"
fi

if [[ $(grep -E -L "^\s+?kpb v0.0.0" go.mod) ]]; then
  insert_line_before ")" "kpb v0.0.0" "go.mod"
fi

go mod edit --fmt go.mod

go get kpb@v0.0.0

cd ../../
