From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/5] [librdmacm] rsocket: added missing break
Date: Tue,  9 Oct 2012 14:27:49 +0200
Message-ID: <1349785672-1921-3-git-send-email-dotanb@dev.mellanox.co.il>
References: <1349785672-1921-1-git-send-email-dotanb@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349785672-1921-1-git-send-email-dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/rsocket.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index 278c8ec..4665ce7 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -1859,6 +1859,7 @@ int rsetsockopt(int socket, int level, int optname,
 		default:
 			break;
 		}
+		break;
 	case SOL_RDMA:
 		if (rs->state >= rs_opening) {
 			ret = ERR(EINVAL);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
