From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 0/4] Debian fixes
Date: Thu, 29 Dec 2016 15:49:04 +0200
Message-ID: <20161229134908.13185-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This is a set of patches to fix up errors and warnings in the debian
files that reported by lintian [1]. It includes debian/copyright file
according to debian's format [2].

The pull request can be found at [3].

[1]
E: rdma-core changes: bad-distribution-in-changes-file unstable
W: rdma-core source: native-package-with-dash-version
E: rdma-core source: build-depends-on-build-essential build-depends
W: rdma-core source: no-debian-copyright
W: ibverbs-providers: new-package-should-close-itp-bug
E: ibverbs-providers: no-copyright-file
W: libibcm1-dbg: new-package-should-close-itp-bug
E: libibcm1-dbg: no-copyright-file
W: librdmacm1: new-package-should-close-itp-bug
E: librdmacm1: no-copyright-file
W: libibumad3-dbg: new-package-should-close-itp-bug
E: libibumad3-dbg: no-copyright-file
W: rdma-core: new-package-should-close-itp-bug
E: rdma-core: no-copyright-file
W: ibacm: new-package-should-close-itp-bug
E: ibacm: no-copyright-file
W: libibverbs1-dbg: new-package-should-close-itp-bug
E: libibverbs1-dbg: no-copyright-file
W: librdmacm-dev: new-package-should-close-itp-bug
E: librdmacm-dev: no-copyright-file
W: srptools: new-package-should-close-itp-bug
E: srptools: no-copyright-file
W: libibverbs1: new-package-should-close-itp-bug
E: libibverbs1: no-copyright-file
W: rdmacm-utils: new-package-should-close-itp-bug
E: rdmacm-utils: no-copyright-file
W: libibverbs-dev: new-package-should-close-itp-bug
E: libibverbs-dev: no-copyright-file
W: libibcm-dev: new-package-should-close-itp-bug
E: libibcm-dev: no-copyright-file
W: iwpmd: new-package-should-close-itp-bug
E: iwpmd: no-copyright-file
W: libibumad3: new-package-should-close-itp-bug
E: libibumad3: no-copyright-file
W: libibcm1: new-package-should-close-itp-bug
E: libibcm1: no-copyright-file
W: ibverbs-utils: new-package-should-close-itp-bug
E: ibverbs-utils: no-copyright-file
W: libibumad-dev: new-package-should-close-itp-bug
E: libibumad-dev: no-copyright-file
W: librdmacm1-dbg: new-package-should-close-itp-bug
E: librdmacm1-dbg: no-copyright-file

[2]
https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/

[3]
https://github.com/linux-rdma/rdma-core/pull/50

Talat Batheesh (4):
  debian/control: Remove build-essential from Build-Depends
  debian/iwpmd.install: Remove ibacm from iwpmd install
  debian/copyright: Add copyright information
  debian/changelog: Update changes

 debian/changelog     |  11 +
 debian/control       |   3 +-
 debian/copyright     | 569 +++++++++++++++++++++++++++++++++++++++++++++++++++
 debian/iwpmd.install |   1 -
 4 files changed, 581 insertions(+), 3 deletions(-)
 create mode 100644 debian/copyright

--
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
