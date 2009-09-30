From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] libibmad/rpc: fix build warning casting from uint32 to uint8
Date: Wed, 30 Sep 2009 16:21:38 -0700
Message-ID: <B5538B5C830E456484477BD3BAFA430B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This fixes a build warning / error on windows.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 libibmad/src/rpc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libibmad/src/rpc.c b/libibmad/src/rpc.c
index 026575d..1ea9a52 100644
--- a/libibmad/src/rpc.c
+++ b/libibmad/src/rpc.c
@@ -195,7 +195,7 @@ static int redirect_port(ib_portid_t * port, uint8_t * mad)
 
 	port->qp = mad_get_field(mad, 64, IB_CPI_REDIRECT_QP_F);
 	port->qkey = mad_get_field(mad, 64, IB_CPI_REDIRECT_QKEY_F);
-	port->sl = mad_get_field(mad, 64, IB_CPI_REDIRECT_SL_F);
+	port->sl = (uint8_t) mad_get_field(mad, 64, IB_CPI_REDIRECT_SL_F);
 
 	/* TODO: Reverse map redirection P_Key to P_Key index */
 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
