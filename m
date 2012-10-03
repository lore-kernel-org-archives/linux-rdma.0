From: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Subject: [PATCH -next] infiniband: fix ipoib build error when IPOIB_CM is
 not enabled
Date: Wed, 03 Oct 2012 14:50:41 -0700
Message-ID: <506CB331.8000101@xenotime.net>
References: <20121003173007.c322d79c31676b9494a6bfd5@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121003173007.c322d79c31676b9494a6bfd5-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>

Fix build error when INFINIBAND_IPOIB_CM is not enabled:

ERROR: "ipoib_set_mode" [drivers/infiniband/ulp/ipoib/ib_ipoib.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Cc:	Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc:	Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc:	Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20121003.orig/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ linux-next-20121003/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  */
 
+#include <linux/kconfig.h>
 #include <linux/netdevice.h>
 #include <linux/module.h>
 #include <net/rtnetlink.h>
@@ -71,11 +72,13 @@ static int ipoib_changelink(struct net_d
 
 	if (data[IFLA_IPOIB_MODE]) {
 		mode  = nla_get_u16(data[IFLA_IPOIB_MODE]);
+#if IS_ENABLED(CONFIG_INFINIBAND_IPOIB_CM)
 		if (mode == IPOIB_MODE_DATAGRAM)
 			ret = ipoib_set_mode(dev, "datagram\n");
 		else if (mode == IPOIB_MODE_CONNECTED)
 			ret = ipoib_set_mode(dev, "connected\n");
 		else
+#endif
 			ret = -EINVAL;
 
 		if (ret < 0)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
