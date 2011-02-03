From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: [PATCH] perftest/write_bw_postlist
Date: Thu, 03 Feb 2011 15:37:01 -0600
Message-ID: <4D4B1FFD.9070906@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090309070808050708030008"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------090309070808050708030008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

in write_bw_postlist.c, my_dest (and possibly rem_dest) must be initialized, else the remote node may not be able to parse the connection string and the test will fail to start.
The others test are doing that initialization.

Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>

--------------090309070808050708030008
Content-Type: text/x-diff;
 name="write_bw_postlist-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="write_bw_postlist-fix.diff"

diff --git a/write_bw_postlist.c b/write_bw_postlist.c
index 0349c40..e2e191f 100644
--- a/write_bw_postlist.c
+++ b/write_bw_postlist.c
@@ -738,8 +743,8 @@ int main(int argc, char *argv[])
 	if (!ctx)
 		return 1;
 
-	my_dest  = malloc(sizeof(struct pingpong_dest)*user_param.num_of_qps);
-	rem_dest = malloc(sizeof(struct pingpong_dest)*user_param.num_of_qps);
+	my_dest  = calloc(user_param.num_of_qps, sizeof(struct pingpong_dest));
+	rem_dest = calloc(user_param.num_of_qps, sizeof(struct pingpong_dest));
     if (!my_dest || !rem_dest) {
 		perror("malloc my_dest or rem_dest");
 		return 1;

--------------090309070808050708030008--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
