From: Jubin John <jubin.john@intel.com>
Subject: [PATCH v2 03/17] staging/rdma/hfi1: Add aeth name syndrome decode
Date: Tue,  1 Dec 2015 15:38:12 -0500
Message-ID: <1449002306-15180-4-git-send-email-jubin.john@intel.com>
References: <1449002306-15180-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1449002306-15180-1-git-send-email-jubin.john@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick@intel.com>

Add aeth name syndrome decode to enhance debugging.

The IBTA RC ACK contains an ACK extended transport header.

Part of that header is the syndrome field that qualifies the RC ACK as an
ACK, NAK, or RNR NAK.

Without the patch here is the syndrome decode:
aeth syn 0x00

Here is the decode with the fix:
aeth syn 0x00 ACK

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
Changes in v2:
	- Added more information in commit message

 drivers/staging/rdma/hfi1/trace.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/trace.c b/drivers/staging/rdma/hfi1/trace.c
index f55b751..10122e8 100644
--- a/drivers/staging/rdma/hfi1/trace.c
+++ b/drivers/staging/rdma/hfi1/trace.c
@@ -67,7 +67,7 @@ u8 ibhdr_exhdr_len(struct hfi1_ib_header *hdr)
 
 #define IMM_PRN  "imm %d"
 #define RETH_PRN "reth vaddr 0x%.16llx rkey 0x%.8x dlen 0x%.8x"
-#define AETH_PRN "aeth syn 0x%.2x msn 0x%.8x"
+#define AETH_PRN "aeth syn 0x%.2x %s msn 0x%.8x"
 #define DETH_PRN "deth qkey 0x%.8x sqpn 0x%.6x"
 #define ATOMICACKETH_PRN "origdata %lld"
 #define ATOMICETH_PRN "vaddr 0x%llx rkey 0x%.8x sdata %lld cdata %lld"
@@ -79,6 +79,19 @@ static u64 ib_u64_get(__be32 *p)
 	return ((u64)be32_to_cpu(p[0]) << 32) | be32_to_cpu(p[1]);
 }
 
+static const char *parse_syndrome(u8 syndrome)
+{
+	switch (syndrome >> 5) {
+	case 0:
+		return "ACK";
+	case 1:
+		return "RNRNAK";
+	case 3:
+		return "NAK";
+	}
+	return "";
+}
+
 const char *parse_everbs_hdrs(
 	struct trace_seq *p,
 	u8 opcode,
@@ -124,16 +137,18 @@ const char *parse_everbs_hdrs(
 	case OP(RC, RDMA_READ_RESPONSE_LAST):
 	case OP(RC, RDMA_READ_RESPONSE_ONLY):
 	case OP(RC, ACKNOWLEDGE):
-		trace_seq_printf(p, AETH_PRN,
-			be32_to_cpu(eh->aeth) >> 24,
-			be32_to_cpu(eh->aeth) & HFI1_MSN_MASK);
+		trace_seq_printf(p, AETH_PRN, be32_to_cpu(eh->aeth) >> 24,
+				 parse_syndrome(be32_to_cpu(eh->aeth) >> 24),
+				 be32_to_cpu(eh->aeth) & HFI1_MSN_MASK);
 		break;
 	/* aeth + atomicacketh */
 	case OP(RC, ATOMIC_ACKNOWLEDGE):
 		trace_seq_printf(p, AETH_PRN " " ATOMICACKETH_PRN,
-			(be32_to_cpu(eh->at.aeth) >> 24) & 0xff,
-			be32_to_cpu(eh->at.aeth) & HFI1_MSN_MASK,
-			(unsigned long long)ib_u64_get(eh->at.atomic_ack_eth));
+				 be32_to_cpu(eh->at.aeth) >> 24,
+				 parse_syndrome(be32_to_cpu(eh->at.aeth) >> 24),
+				 be32_to_cpu(eh->at.aeth) & HFI1_MSN_MASK,
+				 (unsigned long long)
+				 ib_u64_get(eh->at.atomic_ack_eth));
 		break;
 	/* atomiceth */
 	case OP(RC, COMPARE_SWAP):
-- 
1.7.1
