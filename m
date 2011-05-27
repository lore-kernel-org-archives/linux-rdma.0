From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH:rdmacm] ucma_init: fail if ibv_get_device_list() returns
 empty list
Date: Fri, 27 May 2011 18:01:23 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823730119BA@ORSMSX101.amr.corp.intel.com>
References: <OFC348E58C.B4C03447-ONC125789D.0035F094-C125789D.0036C4F7@ch.ibm.com>
 <1306493434.1835.4.camel@deela.quest-ce.net>
 <BANLkTik4e-kygpRTnxfpTdRMSTbyYNO1_Q@mail.gmail.com>
 <1306515973.1835.11.camel@deela.quest-ce.net>
 <1306517515.1835.15.camel@deela.quest-ce.net>
 <1306518158-7770-1-git-send-email-ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1306518158-7770-1-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Animesh K Trivedi1 <ATR-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>   ibv_get_device_list() returns the array of available RDMA devices, or
>   sets errno and returns NULL if the request fails. If no devices are
>   found then num_devices is set to 0, and non-NULL is returned.

Thanks.  I think the following fixes the same issue.  If this looks okay to you, I'll will commit.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

---

diff --git a/src/cma.c b/src/cma.c
index 846b5ce..86cb455 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -247,7 +247,7 @@ int ucma_init(void)
                goto err1;

        dev_list = ibv_get_device_list(&dev_cnt);
-       if (!dev_list) {
+       if (!dev_cnt) {
                printf("CMA: unable to get RDMA device list\n");
                ret = ERR(ENODEV);
                goto err1;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
