From: Adit Ranadive <aditr@vmware.com>
Subject: [PATCH v1 for-rc] RDMA/vmw_pvrdma: Return the correct opcode when
 creating WR
Date: Mon, 7 Jan 2019 23:23:05 +0000
Message-ID: <1546903346-15461-1-git-send-email-aditr@vmware.com>
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
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h | 43 +++++++++++++++++++++++++++=
++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband=
/hw/vmw_pvrdma/pvrdma.h
index 42b8685c997e..a85d7ba96d55 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -427,6 +427,49 @@ static inline enum ib_qp_state pvrdma_qp_state_to_ib(e=
num pvrdma_qp_state state)
=20
 static inline enum pvrdma_wr_opcode ib_wr_opcode_to_pvrdma(enum ib_wr_opco=
de op)
 {
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
+	case IB_WR_RESERVED1:
+	case IB_WR_RESERVED2:
+	case IB_WR_RESERVED3:
+	case IB_WR_RESERVED4:
+	case IB_WR_RESERVED5:
+	case IB_WR_RESERVED6:
+	case IB_WR_RESERVED7:
+	case IB_WR_RESERVED8:
+	case IB_WR_RESERVED9:
+	case IB_WR_RESERVED10:
+		return (enum pvrdma_wr_opcode)op;
+	}
 	return (enum pvrdma_wr_opcode)op;
 }
=20
--=20
1.8.3.1
