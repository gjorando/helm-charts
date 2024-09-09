{{/* Helper functions */}}

{{/*
Generate an hexadecimal secret of a given length.

Process:
- Generate a random ASCII string of length ceil(targetLength/2) (ie. generate ceil(targetLength/2) random bytes)
- Display as hexadecimal; as a byte is written with two hexadecimal digits, we have an output of size 2*ceil(targetLength/2).
- This means that for odd numbers we have one byte excedent. So we just limit the size of our output to $length, and voilà!
*/}}
{{- define "mastodon-standalone.randHex" -}}
{{- $length := . }}
{{- if or (not (kindIs "int" $length)) (le $length 0) }}
{{- printf "mastodon-standalone.randHex expects a positive integer (%d passed)" $length | fail }}
{{- end}}
{{- printf "%x" (randAscii (divf $length 2 | ceil | int)) | trunc $length }}
{{- end}}
