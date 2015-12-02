From: ira.weiny@intel.com
Subject: [PATCH v3 07/13] staging/rdma/hfi1: diag.c correct sizeof parameter
Date: Wed,  2 Dec 2015 00:43:32 -0500
Message-ID: <1449035018-26396-8-git-send-email-ira.weiny@intel.com>
References: <1449035018-26396-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1449035018-26396-1-git-send-email-ira.weiny@intel.com>
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

From: Ira Weiny <ira.weiny@intel.com>

sizeof should use the variable rather than the struct definition to ensure that
type changes are properly accounted for.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index efc0d2239311..a050e09699d8 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -1474,7 +1474,7 @@ static struct snoop_packet *allocate_snoop_packet(u32 hdr_len,
 {
 	struct snoop_packet *packet;
 
-	packet = kzalloc(sizeof(struct snoop_packet) + hdr_len + data_len
+	packet = kzalloc(sizeof(*packet) + hdr_len + data_len
 			 + md_len,
 			 GFP_ATOMIC | __GFP_NOWARN);
 	if (likely(packet))
-- 
1.8.2
