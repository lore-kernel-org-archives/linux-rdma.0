From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/8] ibverbs: Push COPYING file into individual files
Date: Thu, 10 Nov 2016 11:47:37 -0700
Message-ID: <1478803660-27959-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1478803660-27959-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478803660-27959-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add missing copyright headers and delete the COPYING file.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/COPYING                        | 378 ------------------------------
 libibverbs/man/ibv_alloc_mw.3             |   1 +
 libibverbs/man/ibv_alloc_pd.3             |   1 +
 libibverbs/man/ibv_asyncwatch.1           |   1 +
 libibverbs/man/ibv_attach_mcast.3         |   1 +
 libibverbs/man/ibv_bind_mw.3              |   1 +
 libibverbs/man/ibv_create_ah.3            |   1 +
 libibverbs/man/ibv_create_ah_from_wc.3    |   1 +
 libibverbs/man/ibv_create_comp_channel.3  |   1 +
 libibverbs/man/ibv_create_cq.3            |   1 +
 libibverbs/man/ibv_create_cq_ex.3         |   1 +
 libibverbs/man/ibv_create_flow.3          |   1 +
 libibverbs/man/ibv_create_qp.3            |   1 +
 libibverbs/man/ibv_create_qp_ex.3         |   1 +
 libibverbs/man/ibv_create_rwq_ind_table.3 |   1 +
 libibverbs/man/ibv_create_srq.3           |   1 +
 libibverbs/man/ibv_create_srq_ex.3        |   1 +
 libibverbs/man/ibv_create_wq.3            |   1 +
 libibverbs/man/ibv_devices.1              |   1 +
 libibverbs/man/ibv_devinfo.1              |   1 +
 libibverbs/man/ibv_event_type_str.3       |   1 +
 libibverbs/man/ibv_fork_init.3            |   1 +
 libibverbs/man/ibv_get_async_event.3      |   1 +
 libibverbs/man/ibv_get_cq_event.3         |   1 +
 libibverbs/man/ibv_get_device_guid.3      |   1 +
 libibverbs/man/ibv_get_device_list.3      |   1 +
 libibverbs/man/ibv_get_device_name.3      |   1 +
 libibverbs/man/ibv_get_srq_num.3          |   1 +
 libibverbs/man/ibv_inc_rkey.3             |   1 +
 libibverbs/man/ibv_modify_qp.3            |   1 +
 libibverbs/man/ibv_modify_srq.3           |   1 +
 libibverbs/man/ibv_modify_wq.3            |   1 +
 libibverbs/man/ibv_open_device.3          |   1 +
 libibverbs/man/ibv_open_qp.3              |   1 +
 libibverbs/man/ibv_open_xrcd.3            |   1 +
 libibverbs/man/ibv_poll_cq.3              |   1 +
 libibverbs/man/ibv_post_recv.3            |   1 +
 libibverbs/man/ibv_post_send.3            |   1 +
 libibverbs/man/ibv_post_srq_recv.3        |   1 +
 libibverbs/man/ibv_query_device.3         |   1 +
 libibverbs/man/ibv_query_device_ex.3      |   1 +
 libibverbs/man/ibv_query_gid.3            |   1 +
 libibverbs/man/ibv_query_pkey.3           |   1 +
 libibverbs/man/ibv_query_port.3           |   1 +
 libibverbs/man/ibv_query_qp.3             |   1 +
 libibverbs/man/ibv_query_rt_values_ex.3   |   1 +
 libibverbs/man/ibv_query_srq.3            |   1 +
 libibverbs/man/ibv_rate_to_mbps.3         |   1 +
 libibverbs/man/ibv_rate_to_mult.3         |   1 +
 libibverbs/man/ibv_rc_pingpong.1          |   1 +
 libibverbs/man/ibv_reg_mr.3               |   1 +
 libibverbs/man/ibv_req_notify_cq.3        |   1 +
 libibverbs/man/ibv_rereg_mr.3             |   1 +
 libibverbs/man/ibv_resize_cq.3            |   1 +
 libibverbs/man/ibv_srq_pingpong.1         |   1 +
 libibverbs/man/ibv_uc_pingpong.1          |   1 +
 libibverbs/man/ibv_ud_pingpong.1          |   1 +
 libibverbs/man/ibv_xsrq_pingpong.1        |   1 +
 libibverbs/neigh.c                        |   2 +
 libibverbs/neigh.h                        |   3 +
 libibverbs/nl1_compat.h                   |   3 +
 61 files changed, 65 insertions(+), 378 deletions(-)
 delete mode 100644 libibverbs/COPYING

diff --git a/libibverbs/COPYING b/libibverbs/COPYING
deleted file mode 100644
index ee1a79ffabf6..000000000000
diff --git a/libibverbs/man/ibv_alloc_mw.3 b/libibverbs/man/ibv_alloc_mw.3
index 366cefb82b2b..86acacabfd33 100644
--- a/libibverbs/man/ibv_alloc_mw.3
+++ b/libibverbs/man/ibv_alloc_mw.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_ALLOC_MW 3 2016-02-02 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_alloc_pd.3 b/libibverbs/man/ibv_alloc_pd.3
index 63e1aea24c8a..cc475f4a2301 100644
--- a/libibverbs/man/ibv_alloc_pd.3
+++ b/libibverbs/man/ibv_alloc_pd.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_ALLOC_PD 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_asyncwatch.1 b/libibverbs/man/ibv_asyncwatch.1
index 09f9f6505aa0..ae1011757315 100644
--- a/libibverbs/man/ibv_asyncwatch.1
+++ b/libibverbs/man/ibv_asyncwatch.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH IBV_ASYNCWATCH 1 "August 30, 2005" "libibverbs" "USER COMMANDS"
 
 .SH NAME
diff --git a/libibverbs/man/ibv_attach_mcast.3 b/libibverbs/man/ibv_attach_mcast.3
index 722ac9f468e3..2ae1f5d08d4a 100644
--- a/libibverbs/man/ibv_attach_mcast.3
+++ b/libibverbs/man/ibv_attach_mcast.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_ATTACH_MCAST 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_bind_mw.3 b/libibverbs/man/ibv_bind_mw.3
index 2943cbc9fb77..af309d000dea 100644
--- a/libibverbs/man/ibv_bind_mw.3
+++ b/libibverbs/man/ibv_bind_mw.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_BIND_MW 3 2016-02-02 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_create_ah.3 b/libibverbs/man/ibv_create_ah.3
index becc7d1b860f..0ca219887d08 100644
--- a/libibverbs/man/ibv_create_ah.3
+++ b/libibverbs/man/ibv_create_ah.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_CREATE_AH 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_create_ah_from_wc.3 b/libibverbs/man/ibv_create_ah_from_wc.3
index 8b92caf1e431..ec7d29f305b5 100644
--- a/libibverbs/man/ibv_create_ah_from_wc.3
+++ b/libibverbs/man/ibv_create_ah_from_wc.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_CREATE_AH_FROM_WC 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_create_comp_channel.3 b/libibverbs/man/ibv_create_comp_channel.3
index 15a9618845c7..7460978835fc 100644
--- a/libibverbs/man/ibv_create_comp_channel.3
+++ b/libibverbs/man/ibv_create_comp_channel.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_CREATE_COMP_CHANNEL 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_create_cq.3 b/libibverbs/man/ibv_create_cq.3
index 5dc333ec5217..98ea4d278286 100644
--- a/libibverbs/man/ibv_create_cq.3
+++ b/libibverbs/man/ibv_create_cq.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_CREATE_CQ 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_create_cq_ex.3 b/libibverbs/man/ibv_create_cq_ex.3
index ecaeb0ae69f2..a6ae7690dad6 100644
--- a/libibverbs/man/ibv_create_cq_ex.3
+++ b/libibverbs/man/ibv_create_cq_ex.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_CREATE_CQ_EX 3 2016-05-08 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_create_flow.3 b/libibverbs/man/ibv_create_flow.3
index df6ddd37529d..8b6e47206f64 100644
--- a/libibverbs/man/ibv_create_flow.3
+++ b/libibverbs/man/ibv_create_flow.3
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH IBV_CREATE_FLOW 3 2016-03-15 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
 ibv_create_flow, ibv_destroy_flow \- create or destroy flow steering rules
diff --git a/libibverbs/man/ibv_create_qp.3 b/libibverbs/man/ibv_create_qp.3
index 7feeab2c0c5d..78d7f43c1378 100644
--- a/libibverbs/man/ibv_create_qp.3
+++ b/libibverbs/man/ibv_create_qp.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_CREATE_QP 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_create_qp_ex.3 b/libibverbs/man/ibv_create_qp_ex.3
index 08cb92c1676f..c778d1596747 100644
--- a/libibverbs/man/ibv_create_qp_ex.3
+++ b/libibverbs/man/ibv_create_qp_ex.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_CREATE_QP_EX 3 2013-06-26 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_create_rwq_ind_table.3 b/libibverbs/man/ibv_create_rwq_ind_table.3
index 2b060b558c9c..176a5f14990f 100644
--- a/libibverbs/man/ibv_create_rwq_ind_table.3
+++ b/libibverbs/man/ibv_create_rwq_ind_table.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH CREATE_RWQ_IND_TBL 3  2016-07-27 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_create_srq.3 b/libibverbs/man/ibv_create_srq.3
index 7a826a1ee144..46ab8dd5b0bf 100644
--- a/libibverbs/man/ibv_create_srq.3
+++ b/libibverbs/man/ibv_create_srq.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_CREATE_SRQ 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_create_srq_ex.3 b/libibverbs/man/ibv_create_srq_ex.3
index 9151d6ea5541..c0319067b0f5 100644
--- a/libibverbs/man/ibv_create_srq_ex.3
+++ b/libibverbs/man/ibv_create_srq_ex.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_CREATE_SRQ_EX 3 2013-06-26 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_create_wq.3 b/libibverbs/man/ibv_create_wq.3
index 1ee584aee938..aad67416b84e 100644
--- a/libibverbs/man/ibv_create_wq.3
+++ b/libibverbs/man/ibv_create_wq.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_CREATE_WQ 3 2016-07-27 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_devices.1 b/libibverbs/man/ibv_devices.1
index 99b27e5c3b9d..ffd57f8e6929 100644
--- a/libibverbs/man/ibv_devices.1
+++ b/libibverbs/man/ibv_devices.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH IBV_DEVICES 1 "August 30, 2005" "libibverbs" "USER COMMANDS"
 
 .SH NAME
diff --git a/libibverbs/man/ibv_devinfo.1 b/libibverbs/man/ibv_devinfo.1
index 70f7ed2e67d7..b5e9a58a8b13 100644
--- a/libibverbs/man/ibv_devinfo.1
+++ b/libibverbs/man/ibv_devinfo.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH IBV_DEVINFO 1 "August 30, 2005" "libibverbs" "USER COMMANDS"
 
 .SH NAME
diff --git a/libibverbs/man/ibv_event_type_str.3 b/libibverbs/man/ibv_event_type_str.3
index f9ebc35bbacc..2ae8b1c7ee35 100644
--- a/libibverbs/man/ibv_event_type_str.3
+++ b/libibverbs/man/ibv_event_type_str.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_EVENT_TYPE_STR 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_fork_init.3 b/libibverbs/man/ibv_fork_init.3
index acffe3cb7c67..012ea20a4bff 100644
--- a/libibverbs/man/ibv_fork_init.3
+++ b/libibverbs/man/ibv_fork_init.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_FORK_INIT 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_get_async_event.3 b/libibverbs/man/ibv_get_async_event.3
index a76dc0c908f6..85ce6e16cbd7 100644
--- a/libibverbs/man/ibv_get_async_event.3
+++ b/libibverbs/man/ibv_get_async_event.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_GET_ASYNC_EVENT 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_get_cq_event.3 b/libibverbs/man/ibv_get_cq_event.3
index 70b2572ebef3..a1a42e646691 100644
--- a/libibverbs/man/ibv_get_cq_event.3
+++ b/libibverbs/man/ibv_get_cq_event.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_GET_CQ_EVENT 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_get_device_guid.3 b/libibverbs/man/ibv_get_device_guid.3
index 8cbe0e7f276a..4652614033ea 100644
--- a/libibverbs/man/ibv_get_device_guid.3
+++ b/libibverbs/man/ibv_get_device_guid.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_GET_DEVICE_GUID 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_get_device_list.3 b/libibverbs/man/ibv_get_device_list.3
index 96de554eaa38..71c4a740ec23 100644
--- a/libibverbs/man/ibv_get_device_list.3
+++ b/libibverbs/man/ibv_get_device_list.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_GET_DEVICE_LIST 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_get_device_name.3 b/libibverbs/man/ibv_get_device_name.3
index b6cb491bfd9b..ff9fa7fca9f5 100644
--- a/libibverbs/man/ibv_get_device_name.3
+++ b/libibverbs/man/ibv_get_device_name.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_GET_DEVICE_NAME 3  2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_get_srq_num.3 b/libibverbs/man/ibv_get_srq_num.3
index 00e4fb430519..4a1c92f32a22 100644
--- a/libibverbs/man/ibv_get_srq_num.3
+++ b/libibverbs/man/ibv_get_srq_num.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_GET_SRQ_NUM 3 2013-06-26 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_inc_rkey.3 b/libibverbs/man/ibv_inc_rkey.3
index 930368bef3b9..5c54a68bf344 100644
--- a/libibverbs/man/ibv_inc_rkey.3
+++ b/libibverbs/man/ibv_inc_rkey.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_INC_RKEY 3 2015-01-29 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_modify_qp.3 b/libibverbs/man/ibv_modify_qp.3
index cb3faaa089de..66a4974af5ff 100644
--- a/libibverbs/man/ibv_modify_qp.3
+++ b/libibverbs/man/ibv_modify_qp.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_MODIFY_QP 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_modify_srq.3 b/libibverbs/man/ibv_modify_srq.3
index 9cc04974569e..5233922896df 100644
--- a/libibverbs/man/ibv_modify_srq.3
+++ b/libibverbs/man/ibv_modify_srq.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_MODIFY_SRQ 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_modify_wq.3 b/libibverbs/man/ibv_modify_wq.3
index cf3786437a88..f17faedfa5a7 100644
--- a/libibverbs/man/ibv_modify_wq.3
+++ b/libibverbs/man/ibv_modify_wq.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_MODIFY_WQ 3 2016-07-27 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_open_device.3 b/libibverbs/man/ibv_open_device.3
index ed2226c8612a..cae2c4d32f0d 100644
--- a/libibverbs/man/ibv_open_device.3
+++ b/libibverbs/man/ibv_open_device.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_OPEN_DEVICE 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_open_qp.3 b/libibverbs/man/ibv_open_qp.3
index 71b5d464e378..e25e93389087 100644
--- a/libibverbs/man/ibv_open_qp.3
+++ b/libibverbs/man/ibv_open_qp.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_OPEN_QP 3 2011-08-12 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_open_xrcd.3 b/libibverbs/man/ibv_open_xrcd.3
index b9724bfa0c5f..239af2da3f63 100644
--- a/libibverbs/man/ibv_open_xrcd.3
+++ b/libibverbs/man/ibv_open_xrcd.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_OPEN_XRCD 3 2011-06-17 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_poll_cq.3 b/libibverbs/man/ibv_poll_cq.3
index bbf48ff2011b..cf3266bfa8ed 100644
--- a/libibverbs/man/ibv_poll_cq.3
+++ b/libibverbs/man/ibv_poll_cq.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_POLL_CQ 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_post_recv.3 b/libibverbs/man/ibv_post_recv.3
index 4e65c81f773c..affca74cfd2f 100644
--- a/libibverbs/man/ibv_post_recv.3
+++ b/libibverbs/man/ibv_post_recv.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_POST_RECV 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_post_send.3 b/libibverbs/man/ibv_post_send.3
index c45eb0122dcd..ebbbb806882e 100644
--- a/libibverbs/man/ibv_post_send.3
+++ b/libibverbs/man/ibv_post_send.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_POST_SEND 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_post_srq_recv.3 b/libibverbs/man/ibv_post_srq_recv.3
index 073972bd2b93..51d1516bd255 100644
--- a/libibverbs/man/ibv_post_srq_recv.3
+++ b/libibverbs/man/ibv_post_srq_recv.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_POST_SRQ_RECV 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_query_device.3 b/libibverbs/man/ibv_query_device.3
index afc757371b7c..35daa53fee39 100644
--- a/libibverbs/man/ibv_query_device.3
+++ b/libibverbs/man/ibv_query_device.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_QUERY_DEVICE 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_query_device_ex.3 b/libibverbs/man/ibv_query_device_ex.3
index 88c8ce4e48fa..4da63a08f825 100644
--- a/libibverbs/man/ibv_query_device_ex.3
+++ b/libibverbs/man/ibv_query_device_ex.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_QUERY_DEVICE_EX 3 2014-12-17 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_query_gid.3 b/libibverbs/man/ibv_query_gid.3
index b3a1b0fe05e7..45e128bcd1b0 100644
--- a/libibverbs/man/ibv_query_gid.3
+++ b/libibverbs/man/ibv_query_gid.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_QUERY_GID 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_query_pkey.3 b/libibverbs/man/ibv_query_pkey.3
index 96830491b4e8..3af40443bf5c 100644
--- a/libibverbs/man/ibv_query_pkey.3
+++ b/libibverbs/man/ibv_query_pkey.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_QUERY_PKEY 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_query_port.3 b/libibverbs/man/ibv_query_port.3
index 9bedd90e111d..6e480d6c166f 100644
--- a/libibverbs/man/ibv_query_port.3
+++ b/libibverbs/man/ibv_query_port.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_QUERY_PORT 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_query_qp.3 b/libibverbs/man/ibv_query_qp.3
index 3893ec8978e7..907bc56a52ef 100644
--- a/libibverbs/man/ibv_query_qp.3
+++ b/libibverbs/man/ibv_query_qp.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_QUERY_QP 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_query_rt_values_ex.3 b/libibverbs/man/ibv_query_rt_values_ex.3
index fcc460cd179c..8ff5b6634d28 100644
--- a/libibverbs/man/ibv_query_rt_values_ex.3
+++ b/libibverbs/man/ibv_query_rt_values_ex.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_QUERY_RT_VALUES_EX 3 2016-2-20 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_query_srq.3 b/libibverbs/man/ibv_query_srq.3
index 05519aa61441..8a35ce03d76b 100644
--- a/libibverbs/man/ibv_query_srq.3
+++ b/libibverbs/man/ibv_query_srq.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_QUERY_SRQ 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_rate_to_mbps.3 b/libibverbs/man/ibv_rate_to_mbps.3
index 089db0140bcf..27e8724b5fa3 100644
--- a/libibverbs/man/ibv_rate_to_mbps.3
+++ b/libibverbs/man/ibv_rate_to_mbps.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_RATE_TO_MBPS 3 2012-03-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_rate_to_mult.3 b/libibverbs/man/ibv_rate_to_mult.3
index fb57ff823e2f..6e2a59ddf109 100644
--- a/libibverbs/man/ibv_rate_to_mult.3
+++ b/libibverbs/man/ibv_rate_to_mult.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_RATE_TO_MULT 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_rc_pingpong.1 b/libibverbs/man/ibv_rc_pingpong.1
index d213c6ffab9e..865bbcb6b0a5 100644
--- a/libibverbs/man/ibv_rc_pingpong.1
+++ b/libibverbs/man/ibv_rc_pingpong.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH IBV_RC_PINGPONG 1 "August 30, 2005" "libibverbs" "USER COMMANDS"
 
 .SH NAME
diff --git a/libibverbs/man/ibv_reg_mr.3 b/libibverbs/man/ibv_reg_mr.3
index cf151113070c..d3f09c0dad9a 100644
--- a/libibverbs/man/ibv_reg_mr.3
+++ b/libibverbs/man/ibv_reg_mr.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_REG_MR 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_req_notify_cq.3 b/libibverbs/man/ibv_req_notify_cq.3
index 47d45fed8174..1d1d62130d7b 100644
--- a/libibverbs/man/ibv_req_notify_cq.3
+++ b/libibverbs/man/ibv_req_notify_cq.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_REQ_NOTIFY_CQ 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_rereg_mr.3 b/libibverbs/man/ibv_rereg_mr.3
index a67843772bd4..ca8fc4e4d9a1 100644
--- a/libibverbs/man/ibv_rereg_mr.3
+++ b/libibverbs/man/ibv_rereg_mr.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_REREG_MR 3 2016-03-13 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_resize_cq.3 b/libibverbs/man/ibv_resize_cq.3
index fbb1ebd6cd6d..b15950103733 100644
--- a/libibverbs/man/ibv_resize_cq.3
+++ b/libibverbs/man/ibv_resize_cq.3
@@ -1,4 +1,5 @@
 .\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .\"
 .TH IBV_RESIZE_CQ 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
 .SH "NAME"
diff --git a/libibverbs/man/ibv_srq_pingpong.1 b/libibverbs/man/ibv_srq_pingpong.1
index d50f70e63315..dddbd029e625 100644
--- a/libibverbs/man/ibv_srq_pingpong.1
+++ b/libibverbs/man/ibv_srq_pingpong.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH IBV_SRQ_PINGPONG 1 "August 30, 2005" "libibverbs" "USER COMMANDS"
 
 .SH NAME
diff --git a/libibverbs/man/ibv_uc_pingpong.1 b/libibverbs/man/ibv_uc_pingpong.1
index ec97eb0a54f6..88c0417cf294 100644
--- a/libibverbs/man/ibv_uc_pingpong.1
+++ b/libibverbs/man/ibv_uc_pingpong.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH IBV_UC_PINGPONG 1 "August 30, 2005" "libibverbs" "USER COMMANDS"
 
 .SH NAME
diff --git a/libibverbs/man/ibv_ud_pingpong.1 b/libibverbs/man/ibv_ud_pingpong.1
index a05af8d6b80f..594aeb6711a1 100644
--- a/libibverbs/man/ibv_ud_pingpong.1
+++ b/libibverbs/man/ibv_ud_pingpong.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH IBV_UD_PINGPONG 1 "August 30, 2005" "libibverbs" "USER COMMANDS"
 
 .SH NAME
diff --git a/libibverbs/man/ibv_xsrq_pingpong.1 b/libibverbs/man/ibv_xsrq_pingpong.1
index db4a988bd432..ef2ee3c12c9b 100644
--- a/libibverbs/man/ibv_xsrq_pingpong.1
+++ b/libibverbs/man/ibv_xsrq_pingpong.1
@@ -1,3 +1,4 @@
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
 .TH IBV_XSRQ_PINGPONG 1 "May 24, 2016" "libibverbs" "USER COMMANDS"
 
 .SH NAME
diff --git a/libibverbs/neigh.c b/libibverbs/neigh.c
index 1856aab74842..12e58cd4b63c 100644
--- a/libibverbs/neigh.c
+++ b/libibverbs/neigh.c
@@ -1,3 +1,5 @@
+/* Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
+ */
 
 #include "config.h"
 #include <net/if_packet.h>
diff --git a/libibverbs/neigh.h b/libibverbs/neigh.h
index 61dfd85264b7..88211bf2f489 100644
--- a/libibverbs/neigh.h
+++ b/libibverbs/neigh.h
@@ -1,3 +1,6 @@
+/* Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
+ */
+
 #ifndef _NEIGH_H_
 #define _NEIGH_H_
 
diff --git a/libibverbs/nl1_compat.h b/libibverbs/nl1_compat.h
index 809259dce561..e0f4d8199b73 100644
--- a/libibverbs/nl1_compat.h
+++ b/libibverbs/nl1_compat.h
@@ -1,3 +1,6 @@
+/* Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
+ */
+
 #ifndef _NL1_COMPAT_H_
 #define _NL1_COMPAT_H_
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
