From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 1/4] acm: Remove the unused variable 'pri_path'
Date: Sun, 28 Jul 2013 11:18:36 +0200
Message-ID: <51F4E1EC.5050705@acm.org>
References: <51F4E1B2.7070203@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F4E1B2.7070203-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The variable 'pri_path' is assigned a value but is never used.
This triggers the following compiler warning:

src/acm.c:301:26: warning: variable 'pri_path' set but not used [-Wunused-but-set-variable]

Hence remove this variable.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 src/acm.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 04cddee..49bda48 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -297,7 +297,6 @@ static void ucma_ib_save_resp(struct rdma_addrinfo *rai, struct acm_msg *msg)
 {
 	struct acm_ep_addr_data *ep_data;
 	struct ibv_path_data *path_data = NULL;
-	struct ibv_path_record *pri_path = NULL;
 	struct sockaddr_in *sin;
 	struct sockaddr_in6 *sin6;
 	int i, cnt, path_cnt = 0;
@@ -311,9 +310,6 @@ static void ucma_ib_save_resp(struct rdma_addrinfo *rai, struct acm_msg *msg)
 			if (!path_data)
 				path_data = (struct ibv_path_data *) ep_data;
 			path_cnt++;
-			if (ep_data->flags |
-			    (IBV_PATH_FLAG_PRIMARY | IBV_PATH_FLAG_OUTBOUND))
-				pri_path = &path_data[i].path;
 			break;
 		case ACM_EP_INFO_ADDRESS_IP:
 			if (!(ep_data->flags & ACM_EP_FLAG_SOURCE) || rai->ai_src_len)
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
