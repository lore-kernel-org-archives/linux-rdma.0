From: Danny Kukawka <danny.kukawka-2YacvwyR+KOzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH v2] mlx4: fix -Wuninitialized warning
Date: Tue, 14 Feb 2012 15:47:57 +0100
Message-ID: <1329230877-27457-1-git-send-email-danny.kukawka@bisect.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Danny Kukawka <dkukawka-l3A5Bk7waGM@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

=46ix for:
drivers/infiniband/hw/mlx4/qp.c: In function =E2=80=98build_mlx_header=E2=
=80=99:
drivers/infiniband/hw/mlx4/qp.c:1441:30: warning: =E2=80=98vlan=E2=80=99=
 may be
  used uninitialized in this function [-Wuninitialized]

Initialize vlan with 0. Check return value of ib_get_cached_gid()
and return out of build_mlx_header() in error case.

v2: handle also error cases

Signed-off-by: Danny Kukawka <danny.kukawka-2YacvwyR+KOzQB+pC5nmwQ@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |   18 +++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/ml=
x4/qp.c
index aa2aefa..4b889d9 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1363,7 +1363,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *s=
qp, struct ib_send_wr *wr,
 	int is_eth;
 	int is_vlan =3D 0;
 	int is_grh;
-	u16 vlan;
+	u16 vlan =3D 0;
+	int ret;
=20
 	send_size =3D 0;
 	for (i =3D 0; i < wr->num_sge; ++i)
@@ -1372,8 +1373,12 @@ static int build_mlx_header(struct mlx4_ib_sqp *=
sqp, struct ib_send_wr *wr,
 	is_eth =3D rdma_port_get_link_layer(sqp->qp.ibqp.device, sqp->qp.port=
) =3D=3D IB_LINK_LAYER_ETHERNET;
 	is_grh =3D mlx4_ib_ah_grh_present(ah);
 	if (is_eth) {
-		ib_get_cached_gid(ib_dev, be32_to_cpu(ah->av.ib.port_pd) >> 24,
+		ret =3D ib_get_cached_gid(ib_dev,
+				  be32_to_cpu(ah->av.ib.port_pd) >> 24,
 				  ah->av.ib.gid_index, &sgid);
+		if (ret)
+			return ret;
+
 		vlan =3D rdma_get_vlan_id(&sgid);
 		is_vlan =3D vlan < 0x1000;
 	}
@@ -1392,8 +1396,13 @@ static int build_mlx_header(struct mlx4_ib_sqp *=
sqp, struct ib_send_wr *wr,
 		sqp->ud_header.grh.flow_label    =3D
 			ah->av.ib.sl_tclass_flowlabel & cpu_to_be32(0xfffff);
 		sqp->ud_header.grh.hop_limit     =3D ah->av.ib.hop_limit;
-		ib_get_cached_gid(ib_dev, be32_to_cpu(ah->av.ib.port_pd) >> 24,
-				  ah->av.ib.gid_index, &sqp->ud_header.grh.source_gid);
+		ret =3D ib_get_cached_gid(ib_dev,
+					be32_to_cpu(ah->av.ib.port_pd) >> 24,
+					ah->av.ib.gid_index,
+					&sqp->ud_header.grh.source_gid);
+		if (ret)
+			return ret;
+
 		memcpy(sqp->ud_header.grh.destination_gid.raw,
 		       ah->av.ib.dgid, 16);
 	}
--=20
1.7.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
