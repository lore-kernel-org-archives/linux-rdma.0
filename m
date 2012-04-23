From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/15] uDAPL v2.0 windows: Provide auto-detect between RoCE
 and Infiniband for Windows.
Date: Mon, 23 Apr 2012 20:01:11 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F9481202A9@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For RoCE, enable transport global ID use.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/util.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_common/util.c b/dapl/openib_common/util.c
index c118ca9..06a6f3d 100644
--- a/dapl/openib_common/util.c
+++ b/dapl/openib_common/util.c
@@ -352,6 +352,17 @@ skip_ib:
 			 port_attr.link_layer);
 #endif
 #endif
+
+#ifdef _WIN32
+#ifndef _OPENIB_CMA_
+		if (port_attr.transport != IBV_TRANSPORT_IB)
+			hca_ptr->ib_trans.global = 1;
+
+		dapl_log(DAPL_DBG_TYPE_UTIL,
+			 " query_hca: port.transport %d ib_trans.global %d\n",
+			 port_attr.transport, hca_ptr->ib_trans.global);
+#endif
+#endif
 		dapl_log(DAPL_DBG_TYPE_UTIL,
 			     " query_hca: (%x.%x) eps %d, sz %d evds %d,"
 			     " sz %d mtu %d - pkey %x p_idx %d sl %d\n",
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
