From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 02/15] IB/usnic: Fix format not a string literal warning
Date: Fri, 20 Dec 2013 12:26:33 -0800
Message-ID: <1387571206-8043-3-git-send-email-umalhi@cisco.com>
References: <1387571206-8043-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387571206-8043-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

usNIC calls printk w/o string literal in some instances.
Change these instances so the call is made with string literal.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c   | 5 ++---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 2 +-
 drivers/infiniband/hw/usnic/usnic_vnic.c      | 2 --
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 1771eec..696e401 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -75,7 +75,7 @@ void usnic_ib_log_vf(struct usnic_ib_vf *vf)
 {
 	char buf[1000];
 	usnic_ib_dump_vf(vf, buf, sizeof(buf));
-	usnic_dbg(buf);
+	usnic_dbg("%s\n", buf);
 }

 /* Start of netdev section */
@@ -372,8 +372,7 @@ static void usnic_ib_undiscover_pf(struct kref *kref)
 		}
 	}

-	if (!found)
-		WARN("Failed to remove PF %s\n", pci_name(dev));
+	WARN(!found, "Failed to remove PF %s\n", pci_name(dev));

 	mutex_unlock(&usnic_ib_ibdev_list_lock);
 }
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index 5ba8678..f647b6b 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -432,7 +432,7 @@ static void log_spec(const struct usnic_vnic_res_spec
 {
 	char buf[512];
 	usnic_vnic_spec_dump(buf, sizeof(buf), res_spec);
-	usnic_dbg(buf);
+	usnic_dbg("%s\n", buf);
 }

 struct usnic_ib_qp_grp *usnic_ib_qp_grp_create(struct usnic_fwd_dev *ufdev,
diff --git a/drivers/infiniband/hw/usnic/usnic_vnic.c b/drivers/infiniband/hw/usnic/usnic_vnic.c
index 11c2449..ff0b32d 100644
--- a/drivers/infiniband/hw/usnic/usnic_vnic.c
+++ b/drivers/infiniband/hw/usnic/usnic_vnic.c
@@ -182,8 +182,6 @@ int usnic_vnic_spec_dump(char *buf, int buf_sz, const struct usnic_vnic_res_spec
 				res_cnt);
 	}

-	offset += scnprintf(buf + offset, buf_sz - offset,
-				"\n");
 	return offset;
 }

--
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
