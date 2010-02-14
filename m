From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH V2 2/2] mlx4/IB: Add support for enhanced atomic operations
Date: Sun, 14 Feb 2010 15:54:26 +0200
Message-ID: <20100214135426.GA7666@vlad-laptop>
Reply-To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Added support for masked atomic operations:
Masked Compare and Swap (MskCmpSwap)
The MskCmpSwap atomic operation is an extension to the CmpSwap operatio=
n
defined in the IB spec. MskCmpSwap allows the user to select a portion =
of the
64 bit target data for the =E2=80=9Ccompare=E2=80=9D check as well as t=
o restrict the swap to a
(possibly different) portion. The pseudo code below describes the opera=
tion:

| atomic_response =3D *va
| if (((cmp XOR *va) AND cmp_mask) is ZERO) then
|     *va =3D (*va AND NOT(swap_mask)) OR (swap AND swap_mask)
|
| return atomic_response

The additional operands are carried in the Extended Transport Header. A=
tomic
response generation and packet format for MskCmpSwap is as for standard=
 IB
Atomic operations.

Masked Fetch and Add (MFetchAdd)
The MFetchAdd Atomic operation extends the functionality of the standar=
d IB
=46etchAdd by allowing the user to split the target into multiple field=
s of
selectable length. The atomic add is done independently on each one of =
this
fields. A bit set in the field_boundary parameter specifies the field
boundaries. The pseudo code below describes the operation:

| bit_adder(ci, b1, b2, *co)
| {
|	value =3D ci + b1 + b2
|	*co =3D !!(value & 2)
|
|	return value & 1
| }
|
| #define MASK_IS_SET(mask, attr)      (!!((mask)&(attr)))
| bit_position =3D 1
| carry =3D 0
| atomic_response =3D 0
|
| for i =3D 0 to 63
| {
|         if ( i !=3D 0 )
|                 bit_position =3D  bit_position << 1
|
|         bit_add_res =3D bit_adder(carry, MASK_IS_SET(*va, bit_positio=
n), MASK_IS_SET(add_value, bit_position), &new_carry)
|         if (bit_add_res)
|                 atomic_response |=3D bit_position
|
|         carry =3D ((new_carry) && (!MASK_IS_SET(fa_mask, bit_position=
)))
| }
|
| return atomic_response

Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c   |    8 ++++++++
 drivers/infiniband/hw/mlx4/main.c |    2 ++
 drivers/infiniband/hw/mlx4/qp.c   |   27 +++++++++++++++++++++++++++
 include/linux/mlx4/device.h       |    4 ++--
 include/linux/mlx4/qp.h           |    7 +++++++
 5 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/ml=
x4/cq.c
index de5263b..8dd451e 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -660,6 +660,14 @@ repoll:
 			wc->opcode    =3D IB_WC_FETCH_ADD;
 			wc->byte_len  =3D 8;
 			break;
+		case MLX4_OPCODE_ATOMIC_MASKED_CS:
+			wc->opcode    =3D IB_WC_MASKED_COMP_SWAP;
+			wc->byte_len  =3D 8;
+			break;
+		case MLX4_OPCODE_ATOMIC_MASKED_FA:
+			wc->opcode    =3D IB_WC_MASKED_FETCH_ADD;
+			wc->byte_len  =3D 8;
+			break;
 		case MLX4_OPCODE_BIND_MW:
 			wc->opcode    =3D IB_WC_BIND_MW;
 			break;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/=
mlx4/main.c
index e596537..60e1174 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -112,6 +112,8 @@ static int mlx4_ib_query_device(struct ib_device *i=
bdev,
 	    (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_FAST_REG_WR))
 		props->device_cap_flags |=3D IB_DEVICE_MEM_MGT_EXTENSIONS;
=20
+	props->device_cap_flags |=3D IB_DEVICE_MASKED_ATOMIC;
+
 	props->vendor_id	   =3D be32_to_cpup((__be32 *) (out_mad->data + 36))=
 &
 		0xffffff;
 	props->vendor_part_id	   =3D be16_to_cpup((__be16 *) (out_mad->data +=
 30));
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/ml=
x4/qp.c
index 2a97c96..51e6a29 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -84,6 +84,8 @@ static const __be32 mlx4_ib_opcode[] =3D {
 	[IB_WR_SEND_WITH_INV]		=3D cpu_to_be32(MLX4_OPCODE_SEND_INVAL),
 	[IB_WR_LOCAL_INV]		=3D cpu_to_be32(MLX4_OPCODE_LOCAL_INVAL),
 	[IB_WR_FAST_REG_MR]		=3D cpu_to_be32(MLX4_OPCODE_FMR),
+	[IB_WR_ATOMIC_MASKED_CMP_AND_SWP]	=3D cpu_to_be32(MLX4_OPCODE_ATOMIC_=
MASKED_CS),
+	[IB_WR_ATOMIC_MASKED_FETCH_AND_ADD]	=3D cpu_to_be32(MLX4_OPCODE_ATOMI=
C_MASKED_FA),
 };
=20
 static struct mlx4_ib_sqp *to_msqp(struct mlx4_ib_qp *mqp)
@@ -1406,6 +1408,9 @@ static void set_atomic_seg(struct mlx4_wqe_atomic=
_seg *aseg, struct ib_send_wr *
 	if (wr->opcode =3D=3D IB_WR_ATOMIC_CMP_AND_SWP) {
 		aseg->swap_add =3D cpu_to_be64(wr->wr.atomic.swap);
 		aseg->compare  =3D cpu_to_be64(wr->wr.atomic.compare_add);
+	} else if (wr->opcode =3D=3D IB_WR_ATOMIC_MASKED_FETCH_AND_ADD) {
+		aseg->swap_add =3D cpu_to_be64(wr->wr.atomic.compare_add);
+		aseg->compare  =3D cpu_to_be64(wr->wr.atomic.compare_add_mask);
 	} else {
 		aseg->swap_add =3D cpu_to_be64(wr->wr.atomic.compare_add);
 		aseg->compare  =3D 0;
@@ -1413,6 +1418,14 @@ static void set_atomic_seg(struct mlx4_wqe_atomi=
c_seg *aseg, struct ib_send_wr *
=20
 }
=20
+static void set_mask_atomic_seg(struct mlx4_wqe_mask_atomic_seg *aseg,=
 struct ib_send_wr *wr)
+{
+	aseg->swap_add =3D cpu_to_be64(wr->wr.atomic.swap);
+	aseg->swap_add_mask =3D cpu_to_be64(wr->wr.atomic.swap_mask);
+	aseg->compare  =3D cpu_to_be64(wr->wr.atomic.compare_add);
+	aseg->compare_mask =3D cpu_to_be64(wr->wr.atomic.compare_add_mask);
+}
+
 static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
 			     struct ib_send_wr *wr)
 {
@@ -1566,6 +1579,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct =
ib_send_wr *wr,
 			switch (wr->opcode) {
 			case IB_WR_ATOMIC_CMP_AND_SWP:
 			case IB_WR_ATOMIC_FETCH_AND_ADD:
+			case IB_WR_ATOMIC_MASKED_FETCH_AND_ADD:
 				set_raddr_seg(wqe, wr->wr.atomic.remote_addr,
 					      wr->wr.atomic.rkey);
 				wqe  +=3D sizeof (struct mlx4_wqe_raddr_seg);
@@ -1578,6 +1592,19 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct=
 ib_send_wr *wr,
=20
 				break;
=20
+			case IB_WR_ATOMIC_MASKED_CMP_AND_SWP:
+				set_raddr_seg(wqe, wr->wr.atomic.remote_addr,
+					      wr->wr.atomic.rkey);
+				wqe  +=3D sizeof (struct mlx4_wqe_raddr_seg);
+
+				set_mask_atomic_seg(wqe, wr);
+				wqe  +=3D sizeof (struct mlx4_wqe_mask_atomic_seg);
+
+				size +=3D (sizeof (struct mlx4_wqe_raddr_seg) +
+					 sizeof (struct mlx4_wqe_mask_atomic_seg)) / 16;
+
+				break;
+
 			case IB_WR_RDMA_READ:
 			case IB_WR_RDMA_WRITE:
 			case IB_WR_RDMA_WRITE_WITH_IMM:
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index e92d1bf..efeb1dd 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -123,8 +123,8 @@ enum {
 	MLX4_OPCODE_RDMA_READ		=3D 0x10,
 	MLX4_OPCODE_ATOMIC_CS		=3D 0x11,
 	MLX4_OPCODE_ATOMIC_FA		=3D 0x12,
-	MLX4_OPCODE_ATOMIC_MASK_CS	=3D 0x14,
-	MLX4_OPCODE_ATOMIC_MASK_FA	=3D 0x15,
+	MLX4_OPCODE_ATOMIC_MASKED_CS	=3D 0x14,
+	MLX4_OPCODE_ATOMIC_MASKED_FA	=3D 0x15,
 	MLX4_OPCODE_BIND_MW		=3D 0x18,
 	MLX4_OPCODE_FMR			=3D 0x19,
 	MLX4_OPCODE_LOCAL_INVAL		=3D 0x1b,
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 9f29d86..1a48413 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -285,6 +285,13 @@ struct mlx4_wqe_atomic_seg {
 	__be64			compare;
 };
=20
+struct mlx4_wqe_mask_atomic_seg {
+	__be64			swap_add;
+	__be64			compare;
+	__be64			swap_add_mask;
+	__be64			compare_mask;
+};
+
 struct mlx4_wqe_data_seg {
 	__be32			byte_count;
 	__be32			lkey;
--=20
1.6.6.GIT

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
