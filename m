From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/6] IB/rxe: change the function to void from int
Date: Wed, 31 Jan 2018 06:06:55 -0500
Message-ID: <1517396819-29597-3-git-send-email-yanjun.zhu@oracle.com>
References: <20180130073006.GA3244@yuvallap>
 <1517396819-29597-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517396819-29597-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The function rxe_av_from_attr always return 0. So change the
function to void.

CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_av.c    | 3 +--
 drivers/infiniband/sw/rxe/rxe_loc.h   | 2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c | 5 ++---
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index 8accd5d..11e7bed 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -52,14 +52,13 @@ int rxe_av_chk_attr(struct rxe_dev *rxe, struct rdma_ah_attr *attr)
 	return 0;
 }
 
-int rxe_av_from_attr(u8 port_num, struct rxe_av *av,
+void rxe_av_from_attr(u8 port_num, struct rxe_av *av,
 		     struct rdma_ah_attr *attr)
 {
 	memset(av, 0, sizeof(*av));
 	memcpy(&av->grh, rdma_ah_read_grh(attr),
 	       sizeof(*rdma_ah_read_grh(attr)));
 	av->port_num = port_num;
-	return 0;
 }
 
 int rxe_av_to_attr(struct rxe_dev *rxe, struct rxe_av *av,
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 4eb0ff1..ba25c81 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -38,7 +38,7 @@
 
 int rxe_av_chk_attr(struct rxe_dev *rxe, struct rdma_ah_attr *attr);
 
-int rxe_av_from_attr(u8 port_num, struct rxe_av *av,
+void rxe_av_from_attr(u8 port_num, struct rxe_av *av,
 		     struct rdma_ah_attr *attr);
 
 int rxe_av_to_attr(struct rxe_dev *rxe, struct rxe_av *av,
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index abbc983..1cc8e0b 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -271,9 +271,8 @@ static int rxe_init_av(struct rxe_dev *rxe, struct rdma_ah_attr *attr,
 		return err;
 	}
 
-	err = rxe_av_from_attr(rdma_ah_get_port_num(attr), av, attr);
-	if (!err)
-		err = rxe_av_fill_ip_info(rxe, av, attr, &sgid_attr, &sgid);
+	rxe_av_from_attr(rdma_ah_get_port_num(attr), av, attr);
+	err = rxe_av_fill_ip_info(rxe, av, attr, &sgid_attr, &sgid);
 
 	if (sgid_attr.ndev)
 		dev_put(sgid_attr.ndev);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
