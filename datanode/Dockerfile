FROM paulcbn/hadoop-base

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8042
EXPOSE 9864

CMD ["/run.sh"]
