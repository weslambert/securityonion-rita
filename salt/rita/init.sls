ritaconfdir:
  file.directory:
    - name: /opt/so/conf/rita
    - user: 939
    - group: 939
    - makedirs: True

ritaconf:
  file.managed:
    - name: /opt/so/conf/rita/config.yaml
    - source: salt://rita/files/config.yaml
    - user: 939
    - group: 939
    - mode: 600
    - template: jinja
    - show_changes: False

ritalogdir:
  file.directory:
    - name: /nsm/rita
    - user: 939
    - group: 939

ritascripts:
  file.recurse:
    - name: /usr/sbin
    - user: root
    - group: root
    - file_mode: 755
    - template: jinja
    - source: salt://rita/tools/sbin

quay.io/activecm/rita:
  docker_image.present:
    - tag: v4.5.0

so-mongo:
 docker_container.running:
    - image: mongo:4.2
    - hostname: mongo
    - name: so-mongo
    - binds:
      - /nsm/rita/db:/data/db/
    - port_bindings:
      - 0.0.0.0:27017:27017

rita_logs_update:
  cron.present:
    - user: root
    - identifier: rita-logs-update
    - name: '/usr/sbin/so-rita-update'
    - hour: '1'
    - minute: '1'
