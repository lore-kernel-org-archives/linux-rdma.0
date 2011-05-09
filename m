From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: [PATCH] rdma cm typo + bug report
Date: Mon, 09 May 2011 16:50:31 -0500
Message-ID: <4DC861A7.5010005@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070801010604070004090207"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------070801010604070004090207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Sean,

Here's a patch for a typo.

I also think there's a bug with ucma_create_cqs()/ucma_destroy_cqs() because ucma_destroy_cqs unconditionally destroys the CQs, even if they were given by the application. librdmacm should only destroy the CQs it created.

Regards,
  Frank.

--------------070801010604070004090207
Content-Type: text/x-diff;
 name="rdmacm-typo.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rdmacm-typo.diff"

diff --git a/examples/rdma_server.c b/examples/rdma_server.c
index 2831d0c..5b9e16d 100644
--- a/examples/rdma_server.c
+++ b/examples/rdma_server.c
@@ -97,7 +97,7 @@ static int run(void)
 
 	ret = rdma_accept(id, NULL);
 	if (ret) {
-		printf("rdma_connect %d\n", errno);
+		printf("rdma_accept %d\n", errno);
 		return ret;
 	}
 

--------------070801010604070004090207--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
