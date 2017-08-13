From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 11/22] RDMA/usnic: Fix remove address space warning
Date: Sun, 13 Aug 2017 13:18:05 +0300
Message-ID: <20170813101816.3120-12-leon@kernel.org>
References: <20170813101816.3120-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813101816.3120-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Sparse tool complains with the following error:
drivers/infiniband/hw/usnic/usnic_ib_main.c:445:16: warning: cast removes
	address space of expression

Fix it by doing casting on correct field and convert function helper which
sets ifaddr to be void, because there are no users who are interested in
returned value.

Fixes: c7845bcafe4d ("IB/usnic: Add UDP support in u*verbs.c, u*main.c and u*util.h")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_fwd.c     | 12 ++----------
 drivers/infiniband/hw/usnic/usnic_fwd.h     |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c | 10 ++++++----
 3 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_fwd.c b/drivers/infiniband/hw/usnic/usnic_fwd.c
index 3c37dd59c04e..995a26b65156 100644
--- a/drivers/infiniband/hw/usnic/usnic_fwd.c
+++ b/drivers/infiniband/hw/usnic/usnic_fwd.c
@@ -110,20 +110,12 @@ void usnic_fwd_set_mac(struct usnic_fwd_dev *ufdev, char mac[ETH_ALEN])
 	spin_unlock(&ufdev->lock);
 }
 
-int usnic_fwd_add_ipaddr(struct usnic_fwd_dev *ufdev, __be32 inaddr)
+void usnic_fwd_add_ipaddr(struct usnic_fwd_dev *ufdev, __be32 inaddr)
 {
-	int status;
-
 	spin_lock(&ufdev->lock);
-	if (ufdev->inaddr == 0) {
+	if (!ufdev->inaddr)
 		ufdev->inaddr = inaddr;
-		status = 0;
-	} else {
-		status = -EFAULT;
-	}
 	spin_unlock(&ufdev->lock);
-
-	return status;
 }
 
 void usnic_fwd_del_ipaddr(struct usnic_fwd_dev *ufdev)
diff --git a/drivers/infiniband/hw/usnic/usnic_fwd.h b/drivers/infiniband/hw/usnic/usnic_fwd.h
index b2ac22be0731..0b2cc4e79707 100644
--- a/drivers/infiniband/hw/usnic/usnic_fwd.h
+++ b/drivers/infiniband/hw/usnic/usnic_fwd.h
@@ -75,7 +75,7 @@ struct usnic_fwd_dev *usnic_fwd_dev_alloc(struct pci_dev *pdev);
 void usnic_fwd_dev_free(struct usnic_fwd_dev *ufdev);
 
 void usnic_fwd_set_mac(struct usnic_fwd_dev *ufdev, char mac[ETH_ALEN]);
-int usnic_fwd_add_ipaddr(struct usnic_fwd_dev *ufdev, __be32 inaddr);
+void usnic_fwd_add_ipaddr(struct usnic_fwd_dev *ufdev, __be32 inaddr);
 void usnic_fwd_del_ipaddr(struct usnic_fwd_dev *ufdev);
 void usnic_fwd_carrier_up(struct usnic_fwd_dev *ufdev);
 void usnic_fwd_carrier_down(struct usnic_fwd_dev *ufdev);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index e86700f994cb..f45e99a938e0 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -351,7 +351,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 {
 	struct usnic_ib_dev *us_ibdev;
 	union ib_gid gid;
-	struct in_ifaddr *in;
+	struct in_device *ind;
 	struct net_device *netdev;
 
 	usnic_dbg("\n");
@@ -441,9 +441,11 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	if (netif_carrier_ok(us_ibdev->netdev))
 		usnic_fwd_carrier_up(us_ibdev->ufdev);
 
-	in = ((struct in_device *)(netdev->ip_ptr))->ifa_list;
-	if (in != NULL)
-		usnic_fwd_add_ipaddr(us_ibdev->ufdev, in->ifa_address);
+	ind = in_dev_get(netdev);
+	if (ind->ifa_list)
+		usnic_fwd_add_ipaddr(us_ibdev->ufdev,
+				     ind->ifa_list->ifa_address);
+	in_dev_put(ind);
 
 	usnic_mac_ip_to_gid(us_ibdev->netdev->perm_addr,
 				us_ibdev->ufdev->inaddr, &gid.raw[0]);
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
