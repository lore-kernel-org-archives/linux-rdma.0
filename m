From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 20/20] IB/core: If the MGID/MLID pair is not on the list
 return an error
Date: Thu, 02 Mar 2017 07:18:24 -0800
Message-ID: <20170302151814.7732.95705.stgit@scvm10.sc.intel.com>
References: <20170301181719.29989.31238.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301181719.29989.31238.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A list of MGID/MLID pairs is built when doing a multicast attach.  When
the multicast detach is called, the list is searched, and regardless of
the search outcome, the driver detach is called.

If an MGID/MLID pair is not on the list, driver detach should not be
called, and an error should be returned.  Calling the driver without
removing an MGID/MLID pair from the list can leave the core and driver
out of sync.

Fixes: f4e401562c11 IB/uverbs: track multicast group membership for userspace QPs
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 7b7a76e..40cd335 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3186,6 +3186,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 	struct ib_qp                 *qp;
 	struct ib_uverbs_mcast_entry *mcast;
 	int                           ret = -EINVAL;
+	bool                          found = false;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
@@ -3194,10 +3195,6 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 	if (!qp)
 		return -EINVAL;
 
-	ret = ib_detach_mcast(qp, (union ib_gid *) cmd.gid, cmd.mlid);
-	if (ret)
-		goto out_put;
-
 	obj = container_of(qp->uobject, struct ib_uqp_object, uevent.uobject);
 
 	list_for_each_entry(mcast, &obj->mcast_list, list)
@@ -3205,9 +3202,17 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
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
 	put_qp_write(qp);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
