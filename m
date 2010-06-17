From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/5 v2] dapl-2.0 - scm, ucm: add pkey, pkey_index, sl
 override for QP's
Date: Thu, 17 Jun 2010 12:49:46 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9830103CC866F@orsmsx506.amr.corp.intel.com>
References: <E3280858FA94444CA49D2BA02341C9830103BF2437@orsmsx506.amr.corp.intel.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF259E4E04A4@orsmsx501.amr.corp.intel.com>
	<E3280858FA94444CA49D2BA02341C9830103BF25EB@orsmsx506.amr.corp.intel.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF259E4E065C@orsmsx501.amr.corp.intel.com>
 <4C19E243.2020500@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C19E243.2020500-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or/Sean, 

Good points. Here is v2 without index capabilities. 

>Hefty, Sean wrote:
>> The index isn't guaranteed to be the same across all nodes.  
>If a consumer is going to manually control this, they should 
>really be forced to use the actual pkey.
>yes, I saw this confusion in action, for most users pkey index doesn't 
>mean anything, it may also change across time, which can break 
>scripts/setting to run specific jobs using specific partitions.
>
>Or.
>

On a per open basis, add environment variables
DAPL_IB_SL and DAPL_IB_PKEY and use on
connection setup (QP modify) to override default
values of 0 for SL and PKEY index. If pkey is
provided then find the pkey index with
ibv_query_pkey for dev_attr.max_pkeys.
Will be used for RC and UD type QP's.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/dapl_ib_util.h |    4 +++-
 dapl/openib_common/qp.c        |    8 ++++----
 dapl/openib_common/util.c      |   39 +++++++++++++++++++++++++++++++++++++--
 dapl/openib_scm/dapl_ib_util.h |    4 ++++
 dapl/openib_ucm/dapl_ib_util.h |    3 +++
 5 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/dapl/openib_cma/dapl_ib_util.h b/dapl/openib_cma/dapl_ib_util.h
index a710195..471bd7f 100755
--- a/dapl/openib_cma/dapl_ib_util.h
+++ b/dapl/openib_cma/dapl_ib_util.h
@@ -121,7 +121,9 @@ typedef struct _ib_hca_transport
 	uint8_t			tclass;
 	uint8_t			mtu;
 	DAT_NAMED_ATTR		named_attr;
-
+	uint8_t			sl;
+	uint16_t		pkey;
+	int			pkey_idx;
 } ib_hca_transport_t;
 
 /* prototypes */
diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c
index 473604b..179eef0 100644
--- a/dapl/openib_common/qp.c
+++ b/dapl/openib_common/qp.c
@@ -422,7 +422,7 @@ dapls_modify_qp_state(IN ib_qp_handle_t		qp_handle,
 			qp_attr.ah_attr.grh.traffic_class =
 				ia_ptr->hca_ptr->ib_trans.tclass;
 		}
-		qp_attr.ah_attr.sl = 0;
+		qp_attr.ah_attr.sl = ia_ptr->hca_ptr->ib_trans.sl;
 		qp_attr.ah_attr.src_path_bits = 0;
 		qp_attr.ah_attr.port_num = ia_ptr->hca_ptr->port_num;
 
@@ -489,7 +489,7 @@ dapls_modify_qp_state(IN ib_qp_handle_t		qp_handle,
 			qp_attr.qkey = DAT_UD_QKEY;
 		}
 
-		qp_attr.pkey_index = 0;
+		qp_attr.pkey_index = ia_ptr->hca_ptr->ib_trans.pkey_idx;
 		qp_attr.port_num = ia_ptr->hca_ptr->port_num;
 
 		dapl_dbg_log(DAPL_DBG_TYPE_EP,
@@ -519,7 +519,7 @@ dapls_modify_qp_ud(IN DAPL_HCA *hca, IN ib_qp_handle_t qp)
 	/* modify QP, setup and prepost buffers */
 	dapl_os_memzero((void *)&qp_attr, sizeof(qp_attr));
 	qp_attr.qp_state = IBV_QPS_INIT;
-        qp_attr.pkey_index = 0;
+        qp_attr.pkey_index = hca->ib_trans.pkey_idx;
         qp_attr.port_num = hca->port_num;
         qp_attr.qkey = DAT_UD_QKEY;
 	if (ibv_modify_qp(qp, &qp_attr, 
@@ -582,7 +582,7 @@ dapls_create_ah(IN DAPL_HCA		*hca,
 		qp_attr.ah_attr.grh.hop_limit =	hca->ib_trans.hop_limit;
 		qp_attr.ah_attr.grh.traffic_class = hca->ib_trans.tclass;
 	}
-	qp_attr.ah_attr.sl = 0;
+	qp_attr.ah_attr.sl = hca->ib_trans.sl;
 	qp_attr.ah_attr.src_path_bits = 0;
 	qp_attr.ah_attr.port_num = hca->port_num;
 
diff --git a/dapl/openib_common/util.c b/dapl/openib_common/util.c
index b83f609..a69261f 100644
--- a/dapl/openib_common/util.c
+++ b/dapl/openib_common/util.c
@@ -321,6 +321,38 @@ DAT_RETURN dapls_ib_query_hca(IN DAPL_HCA * hca_ptr,
 		hca_ptr->ib_trans.named_attr.value =
 		    dapl_ib_mtu_str(hca_ptr->ib_trans.mtu);
 
+		if (hca_ptr->ib_hca_handle->device->transport_type != IBV_TRANSPORT_IB)
+			goto skip_ib;
+
+               /* set SL, PKEY values, defaults = 0 */
+               hca_ptr->ib_trans.pkey_idx = 0;
+               hca_ptr->ib_trans.pkey = dapl_os_get_env_val("DAPL_IB_PKEY", 0);
+               hca_ptr->ib_trans.sl = dapl_os_get_env_val("DAPL_IB_SL", 0);
+
+		/* index provided, get pkey; pkey provided, get index */
+		if (hca_ptr->ib_trans.pkey) {
+			int i; uint16_t pkey = 0;
+			for (i=0; i < dev_attr.max_pkeys; i++) {
+				if (ibv_query_pkey(hca_ptr->ib_hca_handle,
+						   hca_ptr->port_num,
+						   i, &pkey)) {
+					i = dev_attr.max_pkeys;
+					break;
+				}
+				if (pkey == hca_ptr->ib_trans.pkey) {
+					hca_ptr->ib_trans.pkey_idx = i;
+					break;
+				}
+			}
+			if (i == dev_attr.max_pkeys) {
+				dapl_log(DAPL_DBG_TYPE_WARN,
+					 " Warning: new pkey(%d), query (%s)"
+					 " err or key !found, using defaults\n",
+					 hca_ptr->ib_trans.pkey, strerror(errno));
+			}
+		}
+skip_ib:
+
 #ifdef DEFINE_ATTR_LINK_LAYER
 #ifndef _OPENIB_CMA_
 		if (port_attr.link_layer == IBV_LINK_LAYER_ETHERNET)
@@ -333,12 +365,15 @@ DAT_RETURN dapls_ib_query_hca(IN DAPL_HCA * hca_ptr,
 #endif
 		dapl_log(DAPL_DBG_TYPE_UTIL,
 			     " query_hca: (%x.%x) eps %d, sz %d evds %d,"
-			     " sz %d mtu %d\n",
+			     " sz %d mtu %d - pkey %d p_idx %d sl %d\n",
 			     ia_attr->hardware_version_major,
 			     ia_attr->hardware_version_minor,
 			     ia_attr->max_eps, ia_attr->max_dto_per_ep,
 			     ia_attr->max_evds, ia_attr->max_evd_qlen,
-			     128 << hca_ptr->ib_trans.mtu);
+			     128 << hca_ptr->ib_trans.mtu,
+			     hca_ptr->ib_trans.pkey,
+			     hca_ptr->ib_trans.pkey_idx,
+			     hca_ptr->ib_trans.sl);
 
 		dapl_log(DAPL_DBG_TYPE_UTIL,
 			     " query_hca: msg %llu rdma %llu iov %d lmr %d rmr %d"
diff --git a/dapl/openib_scm/dapl_ib_util.h b/dapl/openib_scm/dapl_ib_util.h
index 497bc64..4bb1a4a 100644
--- a/dapl/openib_scm/dapl_ib_util.h
+++ b/dapl/openib_scm/dapl_ib_util.h
@@ -106,6 +106,10 @@ typedef struct _ib_hca_transport
 	uint8_t			mtu;
 	DAT_NAMED_ATTR		named_attr;
 	DAPL_SOCKET		scm[2];
+	uint8_t			sl;
+	uint16_t			pkey;
+	int				pkey_idx;
+
 } ib_hca_transport_t;
 
 /* prototypes */
diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index de17f04..25ce963 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -114,6 +114,9 @@ typedef struct _ib_hca_transport
 	struct ibv_ah		**ah;  
 	DAPL_OS_LOCK		plock;
 	uint8_t			*sid;  /* Sevice IDs, port space, bitarray? */
+	uint8_t			sl;
+	uint16_t			pkey;
+	int				pkey_idx;
 
 } ib_hca_transport_t;
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
