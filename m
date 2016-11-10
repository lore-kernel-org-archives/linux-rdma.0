From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/8] umad: Push COPYING file into individual files
Date: Thu, 10 Nov 2016 11:47:36 -0700
Message-ID: <1478803660-27959-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1478803660-27959-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478803660-27959-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add missing copyright headers and delete the COPYING file.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibumad/COPYING                     | 377 ----------------------------------
 libibumad/man/umad_addr_dump.3        |   1 +
 libibumad/man/umad_alloc.3            |   1 +
 libibumad/man/umad_class_str.3        |   1 +
 libibumad/man/umad_close_port.3       |   1 +
 libibumad/man/umad_debug.3            |   1 +
 libibumad/man/umad_dump.3             |   1 +
 libibumad/man/umad_free.3             |   1 +
 libibumad/man/umad_get_ca.3           |   1 +
 libibumad/man/umad_get_ca_portguids.3 |   1 +
 libibumad/man/umad_get_cas_names.3    |   1 +
 libibumad/man/umad_get_fd.3           |   1 +
 libibumad/man/umad_get_issm_path.3    |   1 +
 libibumad/man/umad_get_mad.3          |   1 +
 libibumad/man/umad_get_mad_addr.3     |   1 +
 libibumad/man/umad_get_pkey.3         |   1 +
 libibumad/man/umad_get_port.3         |   1 +
 libibumad/man/umad_init.3             |   1 +
 libibumad/man/umad_open_port.3        |   1 +
 libibumad/man/umad_poll.3             |   1 +
 libibumad/man/umad_recv.3             |   1 +
 libibumad/man/umad_register.3         |   1 +
 libibumad/man/umad_register2.3        |   1 +
 libibumad/man/umad_register_oui.3     |   1 +
 libibumad/man/umad_send.3             |   1 +
 libibumad/man/umad_set_addr.3         |   1 +
 libibumad/man/umad_set_addr_net.3     |   1 +
 libibumad/man/umad_set_grh.3          |   1 +
 libibumad/man/umad_set_grh_net.3      |   1 +
 libibumad/man/umad_set_pkey.3         |   1 +
 libibumad/man/umad_size.3             |   1 +
 libibumad/man/umad_status.3           |   1 +
 libibumad/man/umad_unregister.3       |   1 +
 33 files changed, 32 insertions(+), 377 deletions(-)
 delete mode 100644 libibumad/COPYING

diff --git a/libibumad/COPYING b/libibumad/COPYING
deleted file mode 100644
index c7f06f69e99e..000000000000
diff --git a/libibumad/man/umad_addr_dump.3 b/libibumad/man/umad_addr_dump.3
index 7f09214925e4..d082c37a0c16 100644
--- a/libibumad/man/umad_addr_dump.3
+++ b/libibumad/man/umad_addr_dump.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_ADDR_DUMP 3  "May 21, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_alloc.3 b/libibumad/man/umad_alloc.3
index 5c65f3ece42b..b5ef752a2a5c 100644
--- a/libibumad/man/umad_alloc.3
+++ b/libibumad/man/umad_alloc.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_ALLOC 3  "May 21, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_class_str.3 b/libibumad/man/umad_class_str.3
index 5bc813b68cdd..9adb0fd505b9 100644
--- a/libibumad/man/umad_class_str.3
+++ b/libibumad/man/umad_class_str.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_CLASS_STR 3  "Feb 15, 2013" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_close_port.3 b/libibumad/man/umad_close_port.3
index 2c56d906b9b4..341c2d271926 100644
--- a/libibumad/man/umad_close_port.3
+++ b/libibumad/man/umad_close_port.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_OPEN_PORT 3  "May 11, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_debug.3 b/libibumad/man/umad_debug.3
index b7da2b01f0e5..224d5c016984 100644
--- a/libibumad/man/umad_debug.3
+++ b/libibumad/man/umad_debug.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_DEBUG 3  "May 21, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_dump.3 b/libibumad/man/umad_dump.3
index 101a2e0c4997..c01d51bf3044 100644
--- a/libibumad/man/umad_dump.3
+++ b/libibumad/man/umad_dump.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_DUMP 3  "May 17, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_free.3 b/libibumad/man/umad_free.3
index ac397942ea76..e3473170a389 100644
--- a/libibumad/man/umad_free.3
+++ b/libibumad/man/umad_free.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_FREE 3  "May 17, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_get_ca.3 b/libibumad/man/umad_get_ca.3
index 8de61d06d6d3..760b6b65cea8 100644
--- a/libibumad/man/umad_get_ca.3
+++ b/libibumad/man/umad_get_ca.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_GET_CA 3  "May 21, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_get_ca_portguids.3 b/libibumad/man/umad_get_ca_portguids.3
index d002c2a4edb1..ae8418eff534 100644
--- a/libibumad/man/umad_get_ca_portguids.3
+++ b/libibumad/man/umad_get_ca_portguids.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_GET_CA_PORTGUIDS 3  "August 8, 2016" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_get_cas_names.3 b/libibumad/man/umad_get_cas_names.3
index 85e76f815ace..0366c16e52cf 100644
--- a/libibumad/man/umad_get_cas_names.3
+++ b/libibumad/man/umad_get_cas_names.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_GET_CAS_NAMES 3  "May 21, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_get_fd.3 b/libibumad/man/umad_get_fd.3
index 49aa83976cee..5fe531118ac0 100644
--- a/libibumad/man/umad_get_fd.3
+++ b/libibumad/man/umad_get_fd.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_GET_FD 3  "May 17, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_get_issm_path.3 b/libibumad/man/umad_get_issm_path.3
index ac538c935769..4abef18eef28 100644
--- a/libibumad/man/umad_get_issm_path.3
+++ b/libibumad/man/umad_get_issm_path.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_GET_ISSM_PATH 3  "Oct 18, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_get_mad.3 b/libibumad/man/umad_get_mad.3
index 78c59ac74331..ac56c4863eaa 100644
--- a/libibumad/man/umad_get_mad.3
+++ b/libibumad/man/umad_get_mad.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_GET_MAD 3  "May 21, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_get_mad_addr.3 b/libibumad/man/umad_get_mad_addr.3
index 5da86c247546..4a92b7b0a415 100644
--- a/libibumad/man/umad_get_mad_addr.3
+++ b/libibumad/man/umad_get_mad_addr.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_GET_MAD_ADDR 3  "May 21, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_get_pkey.3 b/libibumad/man/umad_get_pkey.3
index a03c0a6adffb..b9dd1be7cd75 100644
--- a/libibumad/man/umad_get_pkey.3
+++ b/libibumad/man/umad_get_pkey.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_GET_PKEY 3  "Jan 15, 2008" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_get_port.3 b/libibumad/man/umad_get_port.3
index 8dfa1d61933f..44dbfb0a8895 100644
--- a/libibumad/man/umad_get_port.3
+++ b/libibumad/man/umad_get_port.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_GET_PORT 3  "May 21, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_init.3 b/libibumad/man/umad_init.3
index 4c22d927d8ec..64366b9de7e4 100644
--- a/libibumad/man/umad_init.3
+++ b/libibumad/man/umad_init.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_INIT 3  "May 21, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_open_port.3 b/libibumad/man/umad_open_port.3
index 53f2946ea814..cac01a71026b 100644
--- a/libibumad/man/umad_open_port.3
+++ b/libibumad/man/umad_open_port.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_OPEN_PORT 3  "May 21, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_poll.3 b/libibumad/man/umad_poll.3
index 93f9425c5f0d..57b7a6536bdd 100644
--- a/libibumad/man/umad_poll.3
+++ b/libibumad/man/umad_poll.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_POLL 3  "October 23, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_recv.3 b/libibumad/man/umad_recv.3
index 56e4ca7708be..93eec993c81e 100644
--- a/libibumad/man/umad_recv.3
+++ b/libibumad/man/umad_recv.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_RECV 3  "May 11, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_register.3 b/libibumad/man/umad_register.3
index eb6b9862574c..58b88f3a3be9 100644
--- a/libibumad/man/umad_register.3
+++ b/libibumad/man/umad_register.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_REGISTER 3  "May 11, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_register2.3 b/libibumad/man/umad_register2.3
index 228ce268e004..74e87943674b 100644
--- a/libibumad/man/umad_register2.3
+++ b/libibumad/man/umad_register2.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_REGISTER2 3  "March 25, 2014" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_register_oui.3 b/libibumad/man/umad_register_oui.3
index 4e8171c5cbaa..19430a93250d 100644
--- a/libibumad/man/umad_register_oui.3
+++ b/libibumad/man/umad_register_oui.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_REGISTER_OUI 3  "May 17, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_send.3 b/libibumad/man/umad_send.3
index b85bc564c0b6..59af2cb9842a 100644
--- a/libibumad/man/umad_send.3
+++ b/libibumad/man/umad_send.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_SEND 3  "May 11, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_set_addr.3 b/libibumad/man/umad_set_addr.3
index 82f81908e0b5..03ac8625cd97 100644
--- a/libibumad/man/umad_set_addr.3
+++ b/libibumad/man/umad_set_addr.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_SET_ADDR 3  "May 17, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_set_addr_net.3 b/libibumad/man/umad_set_addr_net.3
index 1f409c2a1540..778faf41cc19 100644
--- a/libibumad/man/umad_set_addr_net.3
+++ b/libibumad/man/umad_set_addr_net.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_SET_ADDR_NET 3  "May 21, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_set_grh.3 b/libibumad/man/umad_set_grh.3
index 17fe73b74bae..4ff52ec20012 100644
--- a/libibumad/man/umad_set_grh.3
+++ b/libibumad/man/umad_set_grh.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_SET_GRH 3  "May 24, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_set_grh_net.3 b/libibumad/man/umad_set_grh_net.3
index 8425b3fbbc75..802b575dcfcc 100644
--- a/libibumad/man/umad_set_grh_net.3
+++ b/libibumad/man/umad_set_grh_net.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_SET_GRH_NET 3  "May 24, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_set_pkey.3 b/libibumad/man/umad_set_pkey.3
index d6b86064247d..23e858eceb12 100644
--- a/libibumad/man/umad_set_pkey.3
+++ b/libibumad/man/umad_set_pkey.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_SET_PKEY 3  "June 20, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_size.3 b/libibumad/man/umad_size.3
index db861ef21536..74737ccca08b 100644
--- a/libibumad/man/umad_size.3
+++ b/libibumad/man/umad_size.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_SIZE 3  "May 21, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_status.3 b/libibumad/man/umad_status.3
index 3978b84d04b2..fd5430a3e480 100644
--- a/libibumad/man/umad_status.3
+++ b/libibumad/man/umad_status.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_STATUS 3  "May 17, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
diff --git a/libibumad/man/umad_unregister.3 b/libibumad/man/umad_unregister.3
index 472afec6e779..785d22dbe065 100644
--- a/libibumad/man/umad_unregister.3
+++ b/libibumad/man/umad_unregister.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH UMAD_UNREGISTER 3  "May 21, 2007" "OpenIB" "OpenIB Programmer\'s Manual"
 .SH "NAME"
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
