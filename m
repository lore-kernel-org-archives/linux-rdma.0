From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm 0/8] librdmacm "synchronisation" against libibverbs
Date: Tue, 16 Jul 2013 23:59:44 +0200
Message-ID: <cover.1374011243.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Please find a few patches to bring librdmacm up to date regarding
autotools support and some others fixes ...

I've used patches from libibverbs to update autoconf/automake
support: I reused commit messages and author of libibverbs commit,
I hope it's ok for you to get credit about those patches to librdmacm.

I've added .gitignore files to the sources and cleanup file modes.

At last, I've added support for close on exec, just like I did
for libibverbs. It might be good to add support for close on exec
since I've managed to get the change applied in the kernel
(Thanks Roland :).


Bart Van Assche (2):
  Add "foreign" option to AM_INIT_AUTOMAKE
  Makefile.am: Fix an automake warning

Jeff Squyres (1):
  autogen.sh: Use autoreconf in autogen.sh

Yann Droneaud (5):
  configure: Apply updates proposed by autoupdate
  configure: Use automake's option "subdir-objects"
  Add .gitignore rules
  Remove executable mode bit on plain text files
  Open files with "close on exec" flag

 .gitignore                | 64 +++++++++++++++++++++++++++++++++++++++++++++++
 Makefile.am               |  2 +-
 autogen.sh                |  7 +-----
 configure.ac              | 40 +++++++++++++++++++++++------
 examples/.gitignore       | 22 ++++++++++++++++
 include/rdma/rdma_cma.h   |  0
 man/rdma_accept.3         |  0
 man/rdma_connect.3        |  0
 man/rdma_create_qp.3      |  0
 man/rdma_getaddrinfo.3    |  0
 man/rdma_join_multicast.3 |  0
 man/rdma_notify.3         |  0
 src/.gitignore            |  9 +++++++
 src/acm.c                 |  4 +--
 src/addrinfo.c            |  0
 src/cma.c                 |  2 +-
 16 files changed, 132 insertions(+), 18 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 examples/.gitignore
 mode change 100755 => 100644 include/rdma/rdma_cma.h
 mode change 100755 => 100644 man/rdma_accept.3
 mode change 100755 => 100644 man/rdma_connect.3
 mode change 100755 => 100644 man/rdma_create_qp.3
 mode change 100755 => 100644 man/rdma_getaddrinfo.3
 mode change 100755 => 100644 man/rdma_join_multicast.3
 mode change 100755 => 100644 man/rdma_notify.3
 create mode 100644 src/.gitignore
 mode change 100755 => 100644 src/acm.c
 mode change 100755 => 100644 src/addrinfo.c
 mode change 100755 => 100644 src/cma.c

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
