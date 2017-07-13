From: Govindarajulu Varadarajan <gvaradar-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] usnic: do not ignore return value of __ethtool_get_link_ksettings
Date: Thu, 13 Jul 2017 15:46:25 -0700
Message-ID: <20170713224625.6022-2-gvaradar@cisco.com>
References: <20170713224625.6022-1-gvaradar@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170713224625.6022-1-gvaradar-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, Govindarajulu Varadarajan <gvaradar-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Do not ignore the return value of the caller.

Signed-off-by: Govindarajulu Varadarajan <gvaradar-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 03002bac93e7..c0b82a990bc9 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -327,13 +327,16 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 {
 	struct usnic_ib_dev *us_ibdev = to_usdev(ibdev);
 	struct ethtool_link_ksettings cmd;
+	int err = 0;
 
 	usnic_dbg("\n");
 
 	mutex_lock(&us_ibdev->usdev_lock);
 	rtnl_lock();
-	__ethtool_get_link_ksettings(us_ibdev->netdev, &cmd);
+	err = __ethtool_get_link_ksettings(us_ibdev->netdev, &cmd);
 	rtnl_unlock();
+	if (err)
+		goto out;
 	/* props being zeroed by the caller, avoid zeroing it here */
 
 	props->lid = 0;
@@ -364,9 +367,10 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 	/* Userspace will adjust for hdrs */
 	props->max_msg_sz = us_ibdev->ufdev->mtu;
 	props->max_vl_num = 1;
+out:
 	mutex_unlock(&us_ibdev->usdev_lock);
 
-	return 0;
+	return err;
 }
 
 int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
-- 
2.13.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
