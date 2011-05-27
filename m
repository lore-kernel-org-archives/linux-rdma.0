From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH:rdmacm] ucma_init: fail if ibv_get_device_list() returns empty list
Date: Fri, 27 May 2011 19:42:38 +0200
Message-ID: <1306518158-7770-1-git-send-email-ydroneaud@opteya.com>
References: <OFC348E58C.B4C03447-ONC125789D.0035F094-C125789D.0036C4F7@ch.ibm.com> <1306493434.1835.4.camel@deela.quest-ce.net> <BANLkTik4e-kygpRTnxfpTdRMSTbyYNO1_Q@mail.gmail.com> <1306515973.1835.11.camel@deela.quest-ce.net> <1306517515.1835.15.camel@deela.quest-ce.net>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1306517515.1835.15.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Animesh K Trivedi1 <ATR-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As stated in ibv_get_device_list() man page:

  ibv_get_device_list() returns the array of available RDMA devices, or
  sets errno and returns NULL if the request fails. If no devices are
  found then num_devices is set to 0, and non-NULL is returned.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/cma.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 846b5ce..c8d9b9f 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -246,6 +246,7 @@ int ucma_init(void)
 	if (ret)
 		goto err1;
 
+	dev_cnt = 0;
 	dev_list = ibv_get_device_list(&dev_cnt);
 	if (!dev_list) {
 		printf("CMA: unable to get RDMA device list\n");
@@ -253,6 +254,12 @@ int ucma_init(void)
 		goto err1;
 	}
 
+	if (!dev_cnt) {
+		printf("CMA: unable to get RDMA device list\n");
+		ret = ERR(ENODEV);
+		goto err2;
+	}
+
 	cma_dev_array = malloc(sizeof *cma_dev * dev_cnt);
 	if (!cma_dev_array) {
 		ret = ERR(ENOMEM);
-- 
1.7.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
