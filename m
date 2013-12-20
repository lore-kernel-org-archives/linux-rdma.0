From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/6] IB/usnic: Add UDP support to usnic_fwd.[hc]
Date: Fri, 20 Dec 2013 12:38:19 -0800
Message-ID: <1387571903-9398-3-git-send-email-umalhi@cisco.com>
References: <1387571903-9398-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387571903-9398-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add *ip field* to *struct usnic_fwd_dev* as well as new *functions* to
manipulate the *ip field.*  Furthermore, add new functions for
programming UDP flows in the forwarding device.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_fwd.c | 54 +++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/usnic/usnic_fwd.h | 21 +++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/drivers/infiniband/hw/usnic/usnic_fwd.c b/drivers/infiniband/hw/usnic/usnic_fwd.c
index b6e3d44..e801bdf 100644
--- a/drivers/infiniband/hw/usnic/usnic_fwd.c
+++ b/drivers/infiniband/hw/usnic/usnic_fwd.c
@@ -95,6 +95,29 @@ void usnic_fwd_set_mac(struct usnic_fwd_dev *ufdev, char mac[ETH_ALEN])
 	spin_unlock(&ufdev->lock);
 }

+int usnic_fwd_add_ipaddr(struct usnic_fwd_dev *ufdev, __be32 inaddr)
+{
+	int status;
+
+	spin_lock(&ufdev->lock);
+	if (ufdev->inaddr == 0) {
+		ufdev->inaddr = inaddr;
+		status = 0;
+	} else {
+		status = -EFAULT;
+	}
+	spin_unlock(&ufdev->lock);
+
+	return status;
+}
+
+void usnic_fwd_del_ipaddr(struct usnic_fwd_dev *ufdev)
+{
+	spin_lock(&ufdev->lock);
+	ufdev->inaddr = 0;
+	spin_unlock(&ufdev->lock);
+}
+
 void usnic_fwd_carrier_up(struct usnic_fwd_dev *ufdev)
 {
 	spin_lock(&ufdev->lock);
@@ -126,6 +149,30 @@ static int usnic_fwd_dev_ready_locked(struct usnic_fwd_dev *ufdev)
 	return 0;
 }

+static int validate_filter_locked(struct usnic_fwd_dev *ufdev,
+					struct filter *filter)
+{
+
+	WARN_ON(!spin_is_locked(&ufdev->lock));
+
+	if (filter->type == FILTER_IPV4_5TUPLE) {
+		if (!(filter->u.ipv4.flags & FILTER_FIELD_5TUP_DST_AD))
+			return -EACCES;
+		if (!(filter->u.ipv4.flags & FILTER_FIELD_5TUP_DST_PT))
+			return -EBUSY;
+		else if (ufdev->inaddr == 0)
+			return -EINVAL;
+		else if (filter->u.ipv4.dst_port == 0)
+			return -ERANGE;
+		else if (ntohl(ufdev->inaddr) != filter->u.ipv4.dst_addr)
+			return -EFAULT;
+		else
+			return 0;
+	}
+
+	return 0;
+}
+
 static void fill_tlv(struct filter_tlv *tlv, struct filter *filter,
 		struct filter_action *action)
 {
@@ -177,6 +224,13 @@ usnic_fwd_alloc_flow(struct usnic_fwd_dev *ufdev, struct filter *filter,
 		goto out_free_tlv;
 	}

+	status = validate_filter_locked(ufdev, filter);
+	if (status) {
+		usnic_err("Failed to validate filter with status %d\n",
+				status);
+		goto out_free_tlv;
+	}
+
 	/* Issue Devcmd */
 	a0 = tlv_pa;
 	a1 = tlv_size;
diff --git a/drivers/infiniband/hw/usnic/usnic_fwd.h b/drivers/infiniband/hw/usnic/usnic_fwd.h
index b146eb9..93713a2 100644
--- a/drivers/infiniband/hw/usnic/usnic_fwd.h
+++ b/drivers/infiniband/hw/usnic/usnic_fwd.h
@@ -40,6 +40,7 @@ struct usnic_fwd_dev {
 	bool				link_up;
 	char				mac[ETH_ALEN];
 	unsigned int			mtu;
+	__be32				inaddr;
 	char				name[IFNAMSIZ+1];
 };

@@ -58,6 +59,8 @@ struct usnic_fwd_dev *usnic_fwd_dev_alloc(struct pci_dev *pdev);
 void usnic_fwd_dev_free(struct usnic_fwd_dev *ufdev);

 void usnic_fwd_set_mac(struct usnic_fwd_dev *ufdev, char mac[ETH_ALEN]);
+int usnic_fwd_add_ipaddr(struct usnic_fwd_dev *ufdev, __be32 inaddr);
+void usnic_fwd_del_ipaddr(struct usnic_fwd_dev *ufdev);
 void usnic_fwd_carrier_up(struct usnic_fwd_dev *ufdev);
 void usnic_fwd_carrier_down(struct usnic_fwd_dev *ufdev);
 void usnic_fwd_set_mtu(struct usnic_fwd_dev *ufdev, unsigned int mtu);
@@ -89,4 +92,22 @@ static inline void usnic_fwd_init_usnic_filter(struct filter *filter,
 	filter->u.usnic.usnic_id = usnic_id;
 }

+static inline void usnic_fwd_init_udp_filter(struct filter *filter,
+						uint32_t daddr, uint16_t dport)
+{
+	filter->type = FILTER_IPV4_5TUPLE;
+	filter->u.ipv4.flags = FILTER_FIELD_5TUP_PROTO;
+	filter->u.ipv4.protocol = PROTO_UDP;
+
+	if (daddr) {
+		filter->u.ipv4.flags |= FILTER_FIELD_5TUP_DST_AD;
+		filter->u.ipv4.dst_addr = daddr;
+	}
+
+	if (dport) {
+		filter->u.ipv4.flags |= FILTER_FIELD_5TUP_DST_PT;
+		filter->u.ipv4.dst_port = dport;
+	}
+}
+
 #endif /* !USNIC_FWD_H_ */
--
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
