From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/20] IB/core: If the MGID/MLID pair is not on the list
 return an error
Date: Sun, 09 Apr 2017 10:15:32 -0700
Message-ID: <20170409171530.10579.69447.stgit@scvm10.sc.intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409171329.10579.92775.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A list of MGID/MLID pairs is built when doing a multicast attach.  When
the multicast detach is called, the list is searched, and regardless of
the search outcome, the driver detach is called.

If an MGID/MLID pair is not on the list, driver detach should not be
called, and an error should be returned.  Calling the driver without
removing an MGID/MLID pair from the list can leave the core and driver
out of sync.

Fixes: f4e401562c11 ("IB/uverbs: track multicast group membership for userspace QPs")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b9024fa..27fcbeb 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2647,6 +2647,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 	struct ib_qp                 *qp;
 	struct ib_uverbs_mcast_entry *mcast;
 	int                           ret = -EINVAL;
+	bool                          found = false;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
@@ -2658,18 +2659,22 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 	obj = container_of(qp->uobject, struct ib_uqp_object, uevent.uobject);
 	mutex_lock(&obj->mcast_lock);
 
-	ret = ib_detach_mcast(qp, (union ib_gid *) cmd.gid, cmd.mlid);
-	if (ret)
-		goto out_put;
-
 	list_for_each_entry(mcast, &obj->mcast_list, list)
 		if (cmd.mlid == mcast->lid &&
 		    !memcmp(cmd.gid, mcast->gid.raw, sizeof mcast->gid.raw)) {
 			list_del(&mcast->list);
 			kfree(mcast);
+			found = true;
 			break;
 		}
 
+	if (!found) {
+		ret = -EINVAL;
+		goto out_put;
+	}
+
+	ret = ib_detach_mcast(qp, (union ib_gid *)cmd.gid, cmd.mlid);
+
 out_put:
 	mutex_unlock(&obj->mcast_lock);
 	uobj_put_obj_read(qp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
