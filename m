From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 3/4] rsocket: Remove the unused variable 'ret'
Date: Sun, 28 Jul 2013 11:19:48 +0200
Message-ID: <51F4E234.9050504@acm.org>
References: <51F4E1B2.7070203@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F4E1B2.7070203-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The variable 'ret' is assigned a value but that value is never used.
This triggers the following compiler warning:

src/rsocket.c:3720:9: warning: variable 'ret' set but not used [-Wunused-but-set-variable]

Hence remove this variable.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 src/rsocket.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index abdd392..ef24dfb 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -3717,11 +3717,11 @@ static void rs_svc_process_sock(void)
 static uint8_t rs_svc_sgid_index(struct ds_dest *dest, union ibv_gid *sgid)
 {
 	union ibv_gid gid;
-	int i, ret;
+	int i;
 
 	for (i = 0; i < 16; i++) {
-		ret = ibv_query_gid(dest->qp->cm_id->verbs, dest->qp->cm_id->port_num,
-				    i, &gid);
+		ibv_query_gid(dest->qp->cm_id->verbs, dest->qp->cm_id->port_num,
+			      i, &gid);
 		if (!memcmp(sgid, &gid, sizeof gid))
 			return i;
 	}
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
