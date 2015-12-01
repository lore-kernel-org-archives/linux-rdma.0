From: Jubin John <jubin.john@intel.com>
Subject: [PATCH v2 02/17] staging/rdma/hfi1: Decode CNP opcode
Date: Tue,  1 Dec 2015 15:38:11 -0500
Message-ID: <1449002306-15180-3-git-send-email-jubin.john@intel.com>
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

Add CNP opcode decode.

Prior to this patch the trace appeared like:

<idle>-0     [001] d.h. 94062.578932: input_ibhdr: [0000:05:00.0] vl 0
lver 0 sl 0 lnh 2,LRH_BTH dlid 0003 len 6 slid 0001 op 0x80,0x80 se 0 m 0
pad 0 tver 0 pkey 0x8001 f 0 b 0 qpn 0x001234 a 0 psn 0x00000000

Note the "op 0x80,0x80".

With this patch:

<idle>-0     [000] d.h. 233975.912059: input_ibhdr: [0000:05:00.0] vl 0
lver 0 sl 0 lnh 2,LRH_BTH dlid 0015 len 6 slid 0014 op 0x80,CNP se 0 m 0
pad 0 tver 0 pkey 0x8001 f 0 b 0 qpn 0x001234 a 0 psn 0x00000000

Note the "op 0x80,CNP"

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
Changes in v2:
	- Added more information in commit message

 drivers/staging/rdma/hfi1/trace.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/trace.h b/drivers/staging/rdma/hfi1/trace.h
index 5743029..86c12eb 100644
--- a/drivers/staging/rdma/hfi1/trace.h
+++ b/drivers/staging/rdma/hfi1/trace.h
@@ -417,7 +417,8 @@ __print_symbolic(opcode,                                   \
 	ib_opcode_name(UC_RDMA_WRITE_ONLY),                \
 	ib_opcode_name(UC_RDMA_WRITE_ONLY_WITH_IMMEDIATE), \
 	ib_opcode_name(UD_SEND_ONLY),                      \
-	ib_opcode_name(UD_SEND_ONLY_WITH_IMMEDIATE))
+	ib_opcode_name(UD_SEND_ONLY_WITH_IMMEDIATE),       \
+	ib_opcode_name(CNP))
 
 
 #define LRH_PRN "vl %d lver %d sl %d lnh %d,%s dlid %.4x len %d slid %.4x"
-- 
1.7.1
