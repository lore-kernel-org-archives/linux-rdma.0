From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 1/2] IB/usnic: Implement get_netdev hook
Date: Wed, 14 Jun 2017 23:13:33 +0300
Message-ID: <20170614201334.4654-2-yuval.shaia@oracle.com>
References: <20170614201334.4654-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170614201334.4654-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

usnic's get_netdev hook for struct ib_device is missing - add it.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
v3 -> v4:
	* Not functional change, just add r-b
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c  |  1 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 10 ++++++++++
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h |  1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index c0c1e8b..80577b9 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -409,6 +409,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	us_ibdev->ib_dev.query_port = usnic_ib_query_port;
 	us_ibdev->ib_dev.query_pkey = usnic_ib_query_pkey;
 	us_ibdev->ib_dev.query_gid = usnic_ib_query_gid;
+	us_ibdev->ib_dev.get_netdev = usnic_get_netdev;
 	us_ibdev->ib_dev.get_link_layer = usnic_ib_port_link_layer;
 	us_ibdev->ib_dev.alloc_pd = usnic_ib_alloc_pd;
 	us_ibdev->ib_dev.dealloc_pd = usnic_ib_dealloc_pd;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 4996984..f9dc1e80 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -424,6 +424,16 @@ int usnic_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	return 0;
 }
 
+struct net_device *usnic_get_netdev(struct ib_device *device, u8 port_num)
+{
+	struct usnic_ib_dev *us_ibdev = to_usdev(device);
+
+	if (us_ibdev->netdev)
+		dev_hold(us_ibdev->netdev);
+
+	return us_ibdev->netdev;
+}
+
 int usnic_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 				u16 *pkey)
 {
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
index 172e43b..1fda944 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
@@ -48,6 +48,7 @@ int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
 				struct ib_qp_init_attr *qp_init_attr);
 int usnic_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 				union ib_gid *gid);
+struct net_device *usnic_get_netdev(struct ib_device *device, u8 port_num);
 int usnic_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 				u16 *pkey);
 struct ib_pd *usnic_ib_alloc_pd(struct ib_device *ibdev,
-- 
2.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
