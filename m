From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/15] uDAPL v2.0 common: ep_create should allow
 max_request_iov attribute setting of zero
Date: Mon, 23 Apr 2012 20:00:47 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F94812023C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When creating an EP without a request EVD (cq) the max_request_iov
and max_request_sge will be 0. Allow this combination when checking
attribute settings for ARG6.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_ep_create.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/dapl/common/dapl_ep_create.c b/dapl/common/dapl_ep_create.c
index e154b8d..c7dedde 100644
--- a/dapl/common/dapl_ep_create.c
+++ b/dapl/common/dapl_ep_create.c
@@ -171,7 +171,8 @@ dapl_ep_create(IN DAT_IA_HANDLE ia_handle,
 					   && ep_attr->max_request_dtos == 0)
 				       || (recv_evd_handle != DAT_HANDLE_NULL
 					   && ep_attr->max_recv_iov == 0)
-				       || ep_attr->max_request_iov == 0
+				       || (request_evd_handle == DAT_HANDLE_NULL
+					   && ep_attr->max_request_iov != 0)
 				       || (DAT_SUCCESS !=
 					   dapl_ep_check_recv_completion_flags
 					   (ep_attr->recv_completion_flags)))) {
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
