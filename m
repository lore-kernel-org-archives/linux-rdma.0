From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc V1 5/9] IB/mlx4: Handle well-known-gid in mad_demux processing
Date: Thu, 10 Nov 2016 11:30:57 +0200
Message-ID: <1478770261-5775-6-git-send-email-leon@kernel.org>
References: <1478770261-5775-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478770261-5775-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

If OpenSM runs over a ConnectX-3, and there are ConnectX-4 or Connect-IB
VFs active on the network, the OpenSM will receive QP1 packets containing
a GRH where the destination GID is the "Well-Known GID" -- which is not a
GID in the HCA Port's GID Table.

This GID must be tested-for separately -- and packets which contain
this destination GID should be routed to slave 0 (the PF).

Fixes: 37bfc7c1e83f ('IB/mlx4: SR-IOV multiplex and demultiplex MADs')
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index b8e9013..7bcae41 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -729,10 +729,18 @@ static int mlx4_ib_demux_mad(struct ib_device *ibdev, u8 port,
 
 	/* If a grh is present, we demux according to it */
 	if (wc->wc_flags & IB_WC_GRH) {
-		slave = mlx4_ib_find_real_gid(ibdev, port, grh->dgid.global.interface_id);
-		if (slave < 0) {
-			mlx4_ib_warn(ibdev, "failed matching grh\n");
-			return -ENOENT;
+		if (grh->dgid.global.interface_id ==
+			cpu_to_be64(IB_SA_WELL_KNOWN_GUID) &&
+		    grh->dgid.global.subnet_prefix == cpu_to_be64(
+			atomic64_read(&dev->sriov.demux[port - 1].subnet_prefix))) {
+			slave = 0;
+		} else {
+			slave = mlx4_ib_find_real_gid(ibdev, port,
+						      grh->dgid.global.interface_id);
+			if (slave < 0) {
+				mlx4_ib_warn(ibdev, "failed matching grh\n");
+				return -ENOENT;
+			}
 		}
 	}
 	/* Class-specific handling */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
