From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0 - scm, ucm: improperly handles pkey check/query in
 host order
Date: Mon, 2 Aug 2010 11:30:42 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983010FE6D301@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Convert consumer input to network order before verbs query pkey check.
Change appropriate debug messages, increase level of bad key message.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/util.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/dapl/openib_common/util.c b/dapl/openib_common/util.c
index a69261f..5076df8 100644
--- a/dapl/openib_common/util.c
+++ b/dapl/openib_common/util.c
@@ -326,7 +326,7 @@ DAT_RETURN dapls_ib_query_hca(IN DAPL_HCA * hca_ptr,
 
                /* set SL, PKEY values, defaults = 0 */
                hca_ptr->ib_trans.pkey_idx = 0;
-               hca_ptr->ib_trans.pkey = dapl_os_get_env_val("DAPL_IB_PKEY", 0);
+               hca_ptr->ib_trans.pkey = htons(dapl_os_get_env_val("DAPL_IB_PKEY", 0));
                hca_ptr->ib_trans.sl = dapl_os_get_env_val("DAPL_IB_SL", 0);
 
 		/* index provided, get pkey; pkey provided, get index */
@@ -345,10 +345,10 @@ DAT_RETURN dapls_ib_query_hca(IN DAPL_HCA * hca_ptr,
 				}
 			}
 			if (i == dev_attr.max_pkeys) {
-				dapl_log(DAPL_DBG_TYPE_WARN,
-					 " Warning: new pkey(%d), query (%s)"
-					 " err or key !found, using defaults\n",
-					 hca_ptr->ib_trans.pkey, strerror(errno));
+				dapl_log(DAPL_DBG_TYPE_ERR,
+					 " ERR: new pkey(0x%x), query (%s)"
+					 " err or key !found, using default pkey_idx=0\n",
+					 ntohs(hca_ptr->ib_trans.pkey), strerror(errno));
 			}
 		}
 skip_ib:
@@ -365,13 +365,13 @@ skip_ib:
 #endif
 		dapl_log(DAPL_DBG_TYPE_UTIL,
 			     " query_hca: (%x.%x) eps %d, sz %d evds %d,"
-			     " sz %d mtu %d - pkey %d p_idx %d sl %d\n",
+			     " sz %d mtu %d - pkey %x p_idx %d sl %d\n",
 			     ia_attr->hardware_version_major,
 			     ia_attr->hardware_version_minor,
 			     ia_attr->max_eps, ia_attr->max_dto_per_ep,
 			     ia_attr->max_evds, ia_attr->max_evd_qlen,
 			     128 << hca_ptr->ib_trans.mtu,
-			     hca_ptr->ib_trans.pkey,
+			     ntohs(hca_ptr->ib_trans.pkey),
 			     hca_ptr->ib_trans.pkey_idx,
 			     hca_ptr->ib_trans.sl);
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
