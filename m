From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 2/7] IB/iser: Remove redundant assignment
Date: Wed, 13 Aug 2014 19:54:30 +0300
Message-ID: <1407948875-733-3-git-send-email-sagig@mellanox.com>
References: <1407948875-733-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1407948875-733-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: roland@kernel.org, nab@linux-iscsi.org
Cc: martin.petersen@oracle.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

We clear the struct before - no need to do 0 assignment.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/iser/iser_memory.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 47acd3a..bf0d1cc 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -510,7 +510,6 @@ iser_set_prot_checks(struct scsi_cmnd *sc, u8 *mask)
 {
 	switch (scsi_get_prot_type(sc)) {
 	case SCSI_PROT_DIF_TYPE0:
-		*mask = 0x0;
 		break;
 	case SCSI_PROT_DIF_TYPE1:
 	case SCSI_PROT_DIF_TYPE2:
-- 
1.7.1
