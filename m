From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next] IB/usnic: Append documentation to
 usnic_transport.h and cleanup
Date: Fri, 20 Dec 2013 21:41:23 +0000
Message-ID: <CF470083-5ABE-4DE3-BB86-FE7DBB8F48DA@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <78E729BAE58EC54A8B492F38AF3B549F-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> Dreier" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch depends on http://www.spinics.net/lists/linux-rdma/msg18193.html.

Add comment describing usnic_transport_rsrv port and remove
extraneous space from usnic_transport.c

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
drivers/infiniband/hw/usnic/usnic_transport.c | 1 -
drivers/infiniband/hw/usnic/usnic_transport.h | 4 ++++
2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_transport.c b/drivers/infiniband/hw/usnic/usnic_transport.c
index 73dffc9..9182cc8 100644
--- a/drivers/infiniband/hw/usnic/usnic_transport.c
+++ b/drivers/infiniband/hw/usnic/usnic_transport.c
@@ -184,7 +184,6 @@ int usnic_transport_sock_get_addr(struct socket *sock, int *proto,
	return 0;
}

-
int usnic_transport_init(void)
{
	roce_bitmap = kzalloc(ROCE_BITMAP_SZ, GFP_KERNEL);
diff --git a/drivers/infiniband/hw/usnic/usnic_transport.h b/drivers/infiniband/hw/usnic/usnic_transport.h
index 21371bb..7e5dc6d 100644
--- a/drivers/infiniband/hw/usnic/usnic_transport.h
+++ b/drivers/infiniband/hw/usnic/usnic_transport.h
@@ -28,6 +28,10 @@ const char *usnic_transport_to_str(enum usnic_transport_type trans_type);
 */
int usnic_transport_sock_to_str(char *buf, int buf_sz,
					struct socket *sock);
+/*
+ * Reserve a port. If "port_num" is set, then the function will try
+ * to reserve that particular port.
+ */
u16 usnic_transport_rsrv_port(enum usnic_transport_type type, u16 port_num);
void usnic_transport_unrsrv_port(enum usnic_transport_type type, u16 port_num);
/*
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
