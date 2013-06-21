From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 00/15 ibacm] ACM Cache Preloading (and some cosmetic cleanups)
Date: Fri, 21 Jun 2013 07:00:55 -0400
Message-ID: <51C43267.1030301@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series has 2 purposes: cleanups of documentation and
configuration files, and cache preloading.

Cache preloading eliminates even the first network query when the
destination is found in the cache. In order to accomplish this,
there are 2 new static configuration files added as options. The
first is an output file for SA PathRecords. The current format
supported is the one produced by the dump_pr plugin to OpenSM.
Other formats can readuly be supported in the future. The second
is a clusters wide file which maps IP address (either IPv4 or
IPv6) to IB GID.

Patches 1-9 clean up documentation and sample config files.
Patch 10 adds the ability to preload the GID and LID destination caches.
Patch 11 updates the ACM documentation for this.
Patch 12 fixes the inet_pton buffer space.
Patch 13 fixes IPv6 support in acme.
Patch 14 adds the ability to preload the IPv4 and IPv6 destination caches.
Patch 15 adds a performance testing option to acme.

Hal Rosenstock (15):
  acm_notes.txt: Change DOS formatting to unix formatting
  ibacm_opts.cfg: Fix commentary typo
  acm.c: Cosmetic formatting change to acm log message
  ibacm*.cfg: Change DOS formatting to unix formatting
  ibacm*.cfg: Fix commentary typos
  ibacm_opts.cfg: Sync default options file with generated output
  More cosmetic changes for consistency between acme and config files
  man: Change DOS formatting to unix formatting
  Update ib_acme.1 and ibacm.1 man pages
  Add the ability to preload the destination GID and LID caches
  Add description of preloading GID and LID destination caches to
    acm_notes.txt
  Increase buffer space for inet_ntop from 32 to INET6_ADDRSTRLEN
  ib_acme.c: Support IPv6 addressing in resolve_ip
  Add support for preloading IPv4 and IPv6 ACM caches
  Add option to allow for ACM cache lookup performance measurement

 Makefile.am        |    2 +-
 acm_notes.txt      |  274 +++++++++++++++++++++-------------------
 ibacm_addr.cfg     |   48 ++++----
 ibacm_hosts.cfg    |   12 ++
 ibacm_opts.cfg     |  282 ++++++++++++++++++++++-------------------
 linux/acme_linux.c |    2 +-
 linux/osd.h        |    3 +
 man/ib_acme.1      |  175 ++++++++++++++------------
 man/ibacm.1        |   41 ++++++-
 man/ibacm.7        |   62 +++++-----
 src/acm.c          |  364 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 src/acme.c         |   96 ++++++++++----
 src/libacm.c       |   20 ++--
 src/libacm.h       |    7 +-
 14 files changed, 937 insertions(+), 451 deletions(-)
 create mode 100644 ibacm_hosts.cfg

-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
