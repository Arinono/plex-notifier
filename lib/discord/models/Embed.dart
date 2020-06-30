class Embed {
  String title;
  String type;
  String description;
  String url;
  int timestamp;
  int color;
  EmbedFooter footer;
  EmbedImage image;
  EmbedThumbnail thumbnail;
  EmbedVideo video;
  EmbedProvider provider;
  EmbedAuthor author;
  List<EmbedField> fields;

  Embed(Map embed) {
    title = embed['title'];
    type = embed['type'];
    description = embed['description'];
    url = embed['url'];
    timestamp = embed['timestamp'];
    color = embed['color'];
    footer = EmbedFooter(embed['footer']);
    image = EmbedImage(embed['image']);
    thumbnail = EmbedThumbnail(embed['thumbnail']);
    video = EmbedVideo(embed['video']);
    provider = EmbedProvider(embed['provider']);
    author = EmbedAuthor(embed['author']);
    fields = (embed['fields'] as List).map((f) => EmbedField(f)).toList();
  }

  Embed.forDiscord(this.title, this.description, this.fields) {
    type = 'rich';
    color = 0xe5a00d;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'type': type,
        'description': description,
        'url': url,
        'timestamp': timestamp,
        'color': color,
        'footer': footer != null ? footer.toJson() : null,
        'image': image != null ? image.toJson() : null,
        'thumbnail': thumbnail != null ? thumbnail.toJson() : null,
        'video': video != null ? video.toJson() : null,
        'provider': provider != null ? provider.toJson() : null,
        'author': author != null ? author.toJson() : null,
        'fields':
            fields != null ? fields.map((e) => e.toJson()).toList() : null,
      };
}

class EmbedFooter {
  String text;
  String iconUrl;
  String proxyUrlIcon;

  EmbedFooter(Map footer) {
    text = footer['text'];
    iconUrl = footer['icon_url'];
    proxyUrlIcon = footer['proxy_url_icon'];
  }

  Map<String, dynamic> toJson() =>
      {'text': text, 'icon_url': iconUrl, 'proxy_url_icon': proxyUrlIcon};
}

class EmbedImage {
  String url;
  String proxyUrl;
  int height;
  int width;

  EmbedImage(Map image) {
    url = image['url'];
    proxyUrl = image['proxy_url'];
    height = image['height'];
    width = image['width'];
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'proxy_url': proxyUrl,
        'height': height,
        'width': width,
      };
}

class EmbedThumbnail {
  String url;
  String proxyUrl;
  int height;
  int width;

  EmbedThumbnail(Map thumb) {
    url = thumb['url'];
    proxyUrl = thumb['proxy_url'];
    height = thumb['height'];
    width = thumb['width'];
  }

  EmbedThumbnail.from(this.url, this.height, this.width);

  Map<String, dynamic> toJson() => {
        'url': url,
        'proxy_url': proxyUrl,
        'height': height,
        'width': width,
      };
}

class EmbedVideo {
  String url;
  int height;
  int width;

  EmbedVideo(Map video) {
    url = video['url'];
    height = video['height'];
    width = video['width'];
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'height': height,
        'width': width,
      };
}

class EmbedProvider {
  String name;
  String url;

  EmbedProvider(Map provider) {
    name = provider['name'];
    url = provider['url'];
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'name': name,
      };
}

class EmbedAuthor {
  String name;
  String url;
  String iconUrl;
  String proxyUrlIcon;

  EmbedAuthor(Map author) {
    name = author['name'];
    url = author['url'];
    iconUrl = author['icon_url'];
    proxyUrlIcon = author['proxy_url_icon'];
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'name': name,
        'icon_url': iconUrl,
        'proxy_url_icon': proxyUrlIcon,
      };
}

class EmbedField {
  String name;
  String value;
  bool inline;

  EmbedField(Map field) {
    name = field['name'];
    value = field['value'];
    inline = field['inline'];
  }

  EmbedField.from(this.name, this.value, this.inline);

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
        'inline': inline,
      };
}
