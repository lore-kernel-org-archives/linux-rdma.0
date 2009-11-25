From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] uDAPL v1: scm: fix compiler warning, unused variable
Date: Tue, 24 Nov 2009 16:11:25 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C98361B96A44@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/dapl_ib_util.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_scm/dapl_ib_util.c b/dapl/openib_scm/dapl_ib_util.c
index ca7746e..9fb62a5 100644
--- a/dapl/openib_scm/dapl_ib_util.c
+++ b/dapl/openib_scm/dapl_ib_util.c
@@ -175,7 +175,6 @@ DAT_RETURN dapls_ib_open_hca (
         IN   DAPL_HCA		*hca_ptr)
 {
 	struct ibv_device **dev_list;
-	int		opts;
 	int		i;
 	DAT_RETURN	dat_status = DAT_SUCCESS;
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
