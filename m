From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: [PATCH v2] IB/mlx4: silence GCC warning
Date: Thu, 21 Feb 2013 10:02:57 +0100
Message-ID: <1361437377.1341.33.camel@x61.thuisdomein>
References: <1348836538.3626.21.camel@x61.thuisdomein>
	  <201210100923.43927.jackm@dev.mellanox.co.il>
	 <1351504201.1339.4.camel@x61.thuisdomein> <511B9A1C.6000402@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511B9A1C.6000402-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Building qp.o (part of the "Mellanox ConnectX HCA support" driver)
triggers this GCC warning:
    drivers/infiniband/hw/mlx4/qp.c: In function =E2=80=98mlx4_ib_post_=
send=E2=80=99:
    drivers/infiniband/hw/mlx4/qp.c:1862:30: warning: =E2=80=98vlan=E2=80=
=99 may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/infiniband/hw/mlx4/qp.c:1752:6: note: =E2=80=98vlan=E2=80=99=
 was declared here

Looking at the code it is clear 'vlan' is only set and used if 'is_eth'
is non-zero. But by, basically, initializing 'vlan' to 0xffff, instead
of the equivalent of initializing 'is_vlan' to zero, we can make this
warning go away.

Signed-off-by: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
---
0) Jack wanted to use uninitialized_var() after I posted the first
version of this trivial patch. I suggested to see what happened with
Ingo's idea to remove uninitialized_var() entirely. Nothing seems to
have happened, so I decided to try a different approach.

1) Still compile tested only, but now against v3.8.

 drivers/infiniband/hw/mlx4/qp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/ml=
x4/qp.c
index 19e0637..512fde3 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1747,9 +1747,9 @@ static int build_mlx_header(struct mlx4_ib_sqp *s=
qp, struct ib_send_wr *wr,
 	int spc;
 	int i;
 	int is_eth;
-	int is_vlan =3D 0;
+	int is_vlan;
 	int is_grh;
-	u16 vlan;
+	u16 vlan =3D 0xffff; /* invalid vlan id */
 	int err =3D 0;
=20
 	send_size =3D 0;
@@ -1778,8 +1778,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *s=
qp, struct ib_send_wr *wr,
 		}
=20
 		vlan =3D rdma_get_vlan_id(&sgid);
-		is_vlan =3D vlan < 0x1000;
 	}
+	is_vlan =3D vlan < 0x1000;
 	ib_ud_header_init(send_size, !is_eth, is_eth, is_vlan, is_grh, 0, &sq=
p->ud_header);
=20
 	if (!is_eth) {
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
