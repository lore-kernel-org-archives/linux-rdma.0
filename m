From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH librdmacm 4/5] rsocket: Return 0 on success for SOL_RDMA options
Date: Fri,  2 Aug 2013 15:20:21 -0700
Message-ID: <1375482022-5953-5-git-send-email-sean.hefty@intel.com>
References: <1375482022-5953-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375482022-5953-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The processing of SOL_RDMA does not set the return value in
the case of successfully handled options.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index 57df290..d544dd0 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -3314,18 +3314,22 @@ int rsetsockopt(int socket, int level, int optname,
 		switch (optname) {
 		case RDMA_SQSIZE:
 			rs->sq_size = min((*(uint32_t *) optval), RS_QP_MAX_SIZE);
+			ret = 0;
 			break;
 		case RDMA_RQSIZE:
 			rs->rq_size = min((*(uint32_t *) optval), RS_QP_MAX_SIZE);
+			ret = 0;
 			break;
 		case RDMA_INLINE:
 			rs->sq_inline = min(*(uint32_t *) optval, RS_QP_MAX_SIZE);
 			if (rs->sq_inline < RS_MIN_INLINE)
 				rs->sq_inline = RS_MIN_INLINE;
+			ret = 0;
 			break;
 		case RDMA_IOMAPSIZE:
 			rs->target_iomap_size = (uint16_t) rs_scale_to_value(
 				(uint8_t) rs_value_to_scale(*(int *) optval, 8), 8);
+			ret = 0;
 			break;
 		case RDMA_ROUTE:
 			if ((rs->optval = calloc(optlen, 1))) {
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
