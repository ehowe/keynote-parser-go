lines = File.open("create_protobufs.bash").readlines.grep(/^replace_prefixes/)

hash = lines.each_with_object({}) do |line, hash|
  prefixes, original_name, _, custom_prefix = line.gsub(/replace_prefixes /, '').split('" "').map { |p| p.gsub(/"/, "").split(" ") }

  next unless original_name

  original_name = original_name[0]
  custom_prefix &&= custom_prefix[0]

  prefixes.each do |prefix|
    new_prefix = custom_prefix || prefix
    new_name   = "#{new_prefix}#{original_name}"

    command = %Q{sed -i -r 's/"#{prefix}\.#{original_name}"/"#{prefix}.#{new_name}"/' private/iwa/kpb/mapping.go}
    p command
    system(command)
  end
end
