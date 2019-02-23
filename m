From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 04/26] IB/{hfi1,
 qib}: Fix WC.byte_len calculation for UD_SEND_WITH_IMM
Date: Sat, 23 Feb 2019 16:10:25 -0500
Message-ID: <20190223211047.202725-4-sashal@kernel.org>
References: <20190223211047.202725-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190223211047.202725-1-sashal@kernel.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, Brian Welty <brian.welty@intel.com>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Brian Welty <brian.welty@intel.com>

[ Upstream commit 904bba211acc2112fdf866e5a2bc6cd9ecd0de1b ]

The work completion length for a receiving a UD send with immediate is
short by 4 bytes causing application using this opcode to fail.

The UD receive logic incorrectly subtracts 4 bytes for immediate
value. These bytes are already included in header length and are used to
calculate header/payload split, so the result is these 4 bytes are
subtracted twice, once when the header length subtracted from the overall
length and once again in the UD opcode specific path.

Remove the extra subtraction when handling the opcode.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Brian Welty <brian.welty@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qib/qib_ud.c | 1 -
 drivers/staging/rdma/hfi1/ud.c     | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index 59193f67ea787..56bd59bc08b54 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -515,7 +515,6 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 	    opcode == IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE) {
 		wc.ex.imm_data = ohdr->u.ud.imm_data;
 		wc.wc_flags = IB_WC_WITH_IMM;
-		tlen -= sizeof(u32);
 	} else if (opcode == IB_OPCODE_UD_SEND_ONLY) {
 		wc.ex.imm_data = 0;
 		wc.wc_flags = 0;
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index 5a9c784bec04c..a88e37444be0e 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -793,7 +793,6 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	    opcode == IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE) {
 		wc.ex.imm_data = ohdr->u.ud.imm_data;
 		wc.wc_flags = IB_WC_WITH_IMM;
-		tlen -= sizeof(u32);
 	} else if (opcode == IB_OPCODE_UD_SEND_ONLY) {
 		wc.ex.imm_data = 0;
 		wc.wc_flags = 0;
-- 
2.19.1
