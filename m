From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 3/6] IB:usnic: Add UDP support to usnic_transport.[hc]
Date: Fri, 20 Dec 2013 12:38:20 -0800
Message-ID: <1387571903-9398-4-git-send-email-umalhi@cisco.com>
References: <1387571903-9398-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387571903-9398-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch provides API for rest of usNIC code to increment or decrement
socket's reference count. Auxiliary socket APIs are also provided.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_transport.c | 93 +++++++++++++++++++++++++--
 drivers/infiniband/hw/usnic/usnic_transport.h | 19 ++++++
 2 files changed, 105 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_transport.c b/drivers/infiniband/hw/usnic/usnic_transport.c
index 723bd6c..73dffc9 100644
--- a/drivers/infiniband/hw/usnic/usnic_transport.c
+++ b/drivers/infiniband/hw/usnic/usnic_transport.c
@@ -16,8 +16,10 @@
  *
  */
 #include <linux/bitmap.h>
+#include <linux/file.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <net/inet_sock.h>

 #include "usnic_transport.h"
 #include "usnic_log.h"
@@ -28,13 +30,15 @@ static u16 roce_next_port = 1;
 #define ROCE_BITMAP_SZ ((1 << (8 /*CHAR_BIT*/ * sizeof(u16)))/8 /*CHAR BIT*/)
 static DEFINE_SPINLOCK(roce_bitmap_lock);

-static const char *transport_to_str(enum usnic_transport_type type)
+const char *usnic_transport_to_str(enum usnic_transport_type type)
 {
 	switch (type) {
 	case USNIC_TRANSPORT_UNKNOWN:
 		return "Unknown";
 	case USNIC_TRANSPORT_ROCE_CUSTOM:
 		return "roce custom";
+	case USNIC_TRANSPORT_IPV4_UDP:
+		return "IPv4 UDP";
 	case USNIC_TRANSPORT_MAX:
 		return "Max?";
 	default:
@@ -42,6 +46,24 @@ static const char *transport_to_str(enum usnic_transport_type type)
 	}
 }

+int usnic_transport_sock_to_str(char *buf, int buf_sz,
+					struct socket *sock)
+{
+	int err;
+	uint32_t addr;
+	uint16_t port;
+	int proto;
+
+	memset(buf, 0, buf_sz);
+	err = usnic_transport_sock_get_addr(sock, &proto, &addr, &port);
+	if (err)
+		return 0;
+
+	addr = htonl(addr);
+	return scnprintf(buf, buf_sz, "Proto:%u Addr:%pI4 Port:%hu",
+			proto, &addr, port);
+}
+
 /*
  * reserve a port number.  if "0" specified, we will try to pick one
  * starting at roce_next_port.  roce_next_port will take on the values
@@ -60,7 +82,7 @@ u16 usnic_transport_rsrv_port(enum usnic_transport_type type, u16 port_num)
 			roce_next_port = (port_num & 4095) + 1;
 		} else if (test_bit(port_num, roce_bitmap)) {
 			usnic_err("Failed to allocate port for %s\n",
-					transport_to_str(type));
+					usnic_transport_to_str(type));
 			spin_unlock(&roce_bitmap_lock);
 			goto out_fail;
 		}
@@ -68,12 +90,12 @@ u16 usnic_transport_rsrv_port(enum usnic_transport_type type, u16 port_num)
 		spin_unlock(&roce_bitmap_lock);
 	} else {
 		usnic_err("Failed to allocate port - transport %s unsupported\n",
-				transport_to_str(type));
+				usnic_transport_to_str(type));
 		goto out_fail;
 	}

 	usnic_dbg("Allocating port %hu for %s\n", port_num,
-			transport_to_str(type));
+			usnic_transport_to_str(type));
 	return port_num;

 out_fail:
@@ -86,19 +108,19 @@ void usnic_transport_unrsrv_port(enum usnic_transport_type type, u16 port_num)
 		spin_lock(&roce_bitmap_lock);
 		if (!port_num) {
 			usnic_err("Unreserved unvalid port num 0 for %s\n",
-					transport_to_str(type));
+					usnic_transport_to_str(type));
 			goto out_roce_custom;
 		}

 		if (!test_bit(port_num, roce_bitmap)) {
 			usnic_err("Unreserving invalid %hu for %s\n",
 					port_num,
-					transport_to_str(type));
+					usnic_transport_to_str(type));
 			goto out_roce_custom;
 		}
 		bitmap_clear(roce_bitmap, port_num, 1);
 		usnic_dbg("Freeing port %hu for %s\n", port_num,
-				transport_to_str(type));
+				usnic_transport_to_str(type));
 out_roce_custom:
 		spin_unlock(&roce_bitmap_lock);
 	} else {
@@ -106,6 +128,63 @@ out_roce_custom:
 	}
 }

+struct socket *usnic_transport_get_socket(int sock_fd)
+{
+	struct socket *sock;
+	int err;
+	char buf[25];
+
+	/* sockfd_lookup will internally do a fget */
+	sock = sockfd_lookup(sock_fd, &err);
+	if (!sock) {
+		usnic_err("Unable to lookup socket for fd %d with err %d\n",
+				sock_fd, err);
+		return ERR_PTR(-ENOENT);
+	}
+
+	usnic_transport_sock_to_str(buf, sizeof(buf), sock);
+	usnic_dbg("Get sock %s\n", buf);
+
+	return sock;
+}
+
+void usnic_transport_put_socket(struct socket *sock)
+{
+	char buf[100];
+
+	usnic_transport_sock_to_str(buf, sizeof(buf), sock);
+	usnic_dbg("Put sock %s\n", buf);
+	sockfd_put(sock);
+}
+
+int usnic_transport_sock_get_addr(struct socket *sock, int *proto,
+					uint32_t *addr, uint16_t *port)
+{
+	int len;
+	int err;
+	struct sockaddr_in sock_addr;
+
+	err = sock->ops->getname(sock,
+				(struct sockaddr *)&sock_addr,
+				&len, 0);
+	if (err)
+		return err;
+
+	if (sock_addr.sin_family != AF_INET)
+		return -EINVAL;
+
+	if (proto)
+		*proto = sock->sk->sk_protocol;
+	if (port)
+		*port = ntohs(((struct sockaddr_in *)&sock_addr)->sin_port);
+	if (addr)
+		*addr = ntohl(((struct sockaddr_in *)
+					&sock_addr)->sin_addr.s_addr);
+
+	return 0;
+}
+
+
 int usnic_transport_init(void)
 {
 	roce_bitmap = kzalloc(ROCE_BITMAP_SZ, GFP_KERNEL);
diff --git a/drivers/infiniband/hw/usnic/usnic_transport.h b/drivers/infiniband/hw/usnic/usnic_transport.h
index 091fdaf..21371bb 100644
--- a/drivers/infiniband/hw/usnic/usnic_transport.h
+++ b/drivers/infiniband/hw/usnic/usnic_transport.h
@@ -21,8 +21,27 @@

 #include "usnic_abi.h"

+const char *usnic_transport_to_str(enum usnic_transport_type trans_type);
+/*
+ * Returns number of bytes written, excluding null terminator. If
+ * nothing was written, the function returns 0.
+ */
+int usnic_transport_sock_to_str(char *buf, int buf_sz,
+					struct socket *sock);
 u16 usnic_transport_rsrv_port(enum usnic_transport_type type, u16 port_num);
 void usnic_transport_unrsrv_port(enum usnic_transport_type type, u16 port_num);
+/*
+ * Do a fget on the socket refered to by sock_fd and returns the socket.
+ * Socket will not be destroyed before usnic_transport_put_socket has
+ * been called.
+ */
+struct socket *usnic_transport_get_socket(int sock_fd);
+void usnic_transport_put_socket(struct socket *sock);
+/*
+ * Call usnic_transport_get_socket before calling *_sock_get_addr
+ */
+int usnic_transport_sock_get_addr(struct socket *sock, int *proto,
+					uint32_t *addr, uint16_t *port);
 int usnic_transport_init(void);
 void usnic_transport_fini(void);
 #endif /* !USNIC_TRANSPORT_H */
--
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
