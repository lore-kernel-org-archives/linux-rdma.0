From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 10/26] IB/ocrdma: Improve another size determination in
 ocrdma_init_emb_mqe()
Date: Wed, 8 Mar 2017 14:02:46 +0100
Message-ID: <4d92b910-f0fb-1362-0392-fccd8af1d169@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 7 Mar 2017 20:33:29 +0100

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 7d1e1caa90de..aa32bc9f323d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -352,7 +352,7 @@ static void *ocrdma_init_emb_mqe(u8 opcode, u32 cmd_len)
 {
 	struct ocrdma_mqe *mqe;
 
-	mqe = kzalloc(sizeof(struct ocrdma_mqe), GFP_KERNEL);
+	mqe = kzalloc(sizeof(*mqe), GFP_KERNEL);
 	if (!mqe)
 		return NULL;
 	mqe->hdr.spcl_sge_cnt_emb |=
-- 
2.12.0
