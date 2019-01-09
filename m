From: Adit Ranadive <aditr@vmware.com>
Subject: [PATCH v2 for-rc] RDMA/vmw_pvrdma: Return the correct opcode when
 creating WR
Date: Wed, 9 Jan 2019 23:08:49 +0000
Message-ID: <1547075310-8751-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "jgg@mellanox.com" <jgg@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>
Cc: Adit Ranadive <aditr@vmware.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Pv-drivers <Pv-drivers@vmware.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Adit Ranadive <aditr@vmware.com>

Since the IB_WR_REG_MR opcode value changed, let's set the PVRDMA
device opcodes explicitly.

Reported-by: Ruishuang Wang <ruishuangw@vmware.com>
Fixes: 9a59739bd01f ("IB/rxe: Revise the ib_wr_opcode enum")
Cc: stable@vger.kernel.org
Reviewed-by: Bryan Tan <bryantan@vmware.com>
Reviewed-by: Ruishuang Wang <ruishuangw@vmware.com>
Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
Signed-off-by: Adit Ranadive <aditr@vmware.com>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h    | 35 ++++++++++++++++++++++++=
+++-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c |  6 +++++
 include/uapi/rdma/vmw_pvrdma-abi.h           |  1 +
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband=
/hw/vmw_pvrdma/pvrdma.h
index 42b8685c997e..3c633ab58052 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -427,7 +427,40 @@ static inline enum ib_qp_state pvrdma_qp_state_to_ib(e=
num pvrdma_qp_state state)
=20
 static inline enum pvrdma_wr_opcode ib_wr_opcode_to_pvrdma(enum ib_wr_opco=
de op)
 {
-	return (enum pvrdma_wr_opcode)op;
+	switch (op) {
+	case IB_WR_RDMA_WRITE:
+		return PVRDMA_WR_RDMA_WRITE;
+	case IB_WR_RDMA_WRITE_WITH_IMM:
+		return PVRDMA_WR_RDMA_WRITE_WITH_IMM;
+	case IB_WR_SEND:
+		return PVRDMA_WR_SEND;
+	case IB_WR_SEND_WITH_IMM:
+		return PVRDMA_WR_SEND_WITH_IMM;
+	case IB_WR_RDMA_READ:
+		return PVRDMA_WR_RDMA_READ;
+	case IB_WR_ATOMIC_CMP_AND_SWP:
+		return PVRDMA_WR_ATOMIC_CMP_AND_SWP;
+	case IB_WR_ATOMIC_FETCH_AND_ADD:
+		return PVRDMA_WR_ATOMIC_FETCH_AND_ADD;
+	case IB_WR_LSO:
+		return PVRDMA_WR_LSO;
+	case IB_WR_SEND_WITH_INV:
+		return PVRDMA_WR_SEND_WITH_INV;
+	case IB_WR_RDMA_READ_WITH_INV:
+		return PVRDMA_WR_RDMA_READ_WITH_INV;
+	case IB_WR_LOCAL_INV:
+		return PVRDMA_WR_LOCAL_INV;
+	case IB_WR_REG_MR:
+		return PVRDMA_WR_FAST_REG_MR;
+	case IB_WR_MASKED_ATOMIC_CMP_AND_SWP:
+		return PVRDMA_WR_MASKED_ATOMIC_CMP_AND_SWP;
+	case IB_WR_MASKED_ATOMIC_FETCH_AND_ADD:
+		return PVRDMA_WR_MASKED_ATOMIC_FETCH_AND_ADD;
+	case IB_WR_REG_SIG_MR:
+		return PVRDMA_WR_REG_SIG_MR;
+	default:
+		return PVRDMA_WR_ERROR;
+	}
 }
=20
 static inline enum ib_wc_status pvrdma_wc_status_to_ib(
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infinib=
and/hw/vmw_pvrdma/pvrdma_qp.c
index 3acf74cbe266..1ec3646087ba 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -721,6 +721,12 @@ int pvrdma_post_send(struct ib_qp *ibqp, const struct =
ib_send_wr *wr,
 		    wr->opcode =3D=3D IB_WR_RDMA_WRITE_WITH_IMM)
 			wqe_hdr->ex.imm_data =3D wr->ex.imm_data;
=20
+		if (unlikely(wqe_hdr->opcode =3D=3D PVRDMA_WR_ERROR)) {
+			*bad_wr =3D wr;
+			ret =3D -EINVAL;
+			goto out;
+		}
+
 		switch (qp->ibqp.qp_type) {
 		case IB_QPT_GSI:
 		case IB_QPT_UD:
diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h b/include/uapi/rdma/vmw_pvr=
dma-abi.h
index d13fd490b66d..6e73f0274e41 100644
--- a/include/uapi/rdma/vmw_pvrdma-abi.h
+++ b/include/uapi/rdma/vmw_pvrdma-abi.h
@@ -78,6 +78,7 @@ enum pvrdma_wr_opcode {
 	PVRDMA_WR_MASKED_ATOMIC_FETCH_AND_ADD,
 	PVRDMA_WR_BIND_MW,
 	PVRDMA_WR_REG_SIG_MR,
+	PVRDMA_WR_ERROR,
 };
=20
 enum pvrdma_wc_status {
--=20
1.8.3.1
