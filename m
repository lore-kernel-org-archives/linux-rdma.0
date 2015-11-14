From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 02/18] staging/rdma/hfi1: Decode CNP opcode
Date: Fri, 13 Nov 2015 19:37:00 -0800
Message-ID: <1447472236-622-2-git-send-email-jubin.john@intel.com>
References: <1447472236-622-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1447472236-622-1-git-send-email-jubin.john@intel.com>
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

Add CNP opcode decode

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
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
1.7.0.7
