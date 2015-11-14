From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 08/18] staging/rdma/hfi1: Add a credit push on diagpkt
 allocate fail
Date: Fri, 13 Nov 2015 19:37:06 -0800
Message-ID: <1447472236-622-8-git-send-email-jubin.john@intel.com>
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

When sending a diagnostic packet, if the send context does not
have enough room, force a credit return and try again.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/diag.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 88414d7..24baa6a 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -379,6 +379,7 @@ static ssize_t diagpkt_send(struct diag_pkt *dp)
 	pio_release_cb credit_cb = NULL;
 	void *credit_arg = NULL;
 	struct diagpkt_wait *wait = NULL;
+	int trycount = 0;
 
 	dd = hfi1_lookup(dp->unit);
 	if (!dd || !(dd->flags & HFI1_PRESENT) || !dd->kregbase) {
@@ -493,8 +494,15 @@ static ssize_t diagpkt_send(struct diag_pkt *dp)
 		credit_arg = wait;
 	}
 
+retry:
 	pbuf = sc_buffer_alloc(sc, total_len, credit_cb, credit_arg);
 	if (!pbuf) {
+		if (trycount == 0) {
+			/* force a credit return and try again */
+			sc_return_credits(sc);
+			trycount = 1;
+			goto retry;
+		}
 		/*
 		 * No send buffer means no credit callback.  Undo
 		 * the wait set-up that was done above.  We free wait
-- 
1.7.0.7
