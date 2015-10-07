From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] IB/core: avoid 32-bit warning
Date: Wed, 07 Oct 2015 14:29:51 +0200
Message-ID: <17269152.DqJfCm1LOx@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The INIT_UDATA() macro requires a pointer or unsigned long argument for
both input and output buffer, and all callers had a cast from when
the code was merged until a recent restructuring, so now we get

core/uverbs_cmd.c: In function 'ib_uverbs_create_cq':
core/uverbs_cmd.c:1481:66: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

This makes the code behave as before by adding back the cast to
unsigned long.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Fixes: 565197dd8fb1 ("IB/core: Extend ib_uverbs_create_cq")

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index be4cb9f04be3..88b3b78340f2 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1478,7 +1478,7 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
-	INIT_UDATA(&ucore, buf, cmd.response, sizeof(cmd), sizeof(resp));
+	INIT_UDATA(&ucore, buf, (unsigned long)cmd.response, sizeof(cmd), sizeof(resp));
 
 	INIT_UDATA(&uhw, buf + sizeof(cmd),
 		   (unsigned long)cmd.response + sizeof(resp),

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
