From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH librdmacm 7/8] Remove executable mode bit on plain text files
Date: Tue, 16 Jul 2013 23:59:51 +0200
Message-ID: <088600697527723169b46ceca741a38cfe3f2322.1374011243.git.ydroneaud@opteya.com>
References: <cover.1374011243.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1374011243.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Source code and man page should not be executable.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 include/rdma/rdma_cma.h   | 0
 man/rdma_accept.3         | 0
 man/rdma_connect.3        | 0
 man/rdma_create_qp.3      | 0
 man/rdma_getaddrinfo.3    | 0
 man/rdma_join_multicast.3 | 0
 man/rdma_notify.3         | 0
 src/acm.c                 | 0
 src/addrinfo.c            | 0
 src/cma.c                 | 0
 10 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 include/rdma/rdma_cma.h
 mode change 100755 => 100644 man/rdma_accept.3
 mode change 100755 => 100644 man/rdma_connect.3
 mode change 100755 => 100644 man/rdma_create_qp.3
 mode change 100755 => 100644 man/rdma_getaddrinfo.3
 mode change 100755 => 100644 man/rdma_join_multicast.3
 mode change 100755 => 100644 man/rdma_notify.3
 mode change 100755 => 100644 src/acm.c
 mode change 100755 => 100644 src/addrinfo.c
 mode change 100755 => 100644 src/cma.c

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
old mode 100755
new mode 100644
diff --git a/man/rdma_accept.3 b/man/rdma_accept.3
old mode 100755
new mode 100644
diff --git a/man/rdma_connect.3 b/man/rdma_connect.3
old mode 100755
new mode 100644
diff --git a/man/rdma_create_qp.3 b/man/rdma_create_qp.3
old mode 100755
new mode 100644
diff --git a/man/rdma_getaddrinfo.3 b/man/rdma_getaddrinfo.3
old mode 100755
new mode 100644
diff --git a/man/rdma_join_multicast.3 b/man/rdma_join_multicast.3
old mode 100755
new mode 100644
diff --git a/man/rdma_notify.3 b/man/rdma_notify.3
old mode 100755
new mode 100644
diff --git a/src/acm.c b/src/acm.c
old mode 100755
new mode 100644
diff --git a/src/addrinfo.c b/src/addrinfo.c
old mode 100755
new mode 100644
diff --git a/src/cma.c b/src/cma.c
old mode 100755
new mode 100644
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
