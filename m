From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 01/12] IB/hfi1: Add new state complete decodes for
 LNI failures
Date: Tue, 26 Sep 2017 07:00:04 -0700
Message-ID: <20170926140002.15601.42465.stgit@scvm10.sc.intel.com>
References: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926135843.15601.95865.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add state decodes for link width negotiation, verify cap time out
and secure data resolution failures.

Reviewed-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 0be4278..c47a01f 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -10170,6 +10170,10 @@ static void set_lidlmc(struct hfi1_pportdata *ppd)
 	[0x33] =
 	  "Link partner completed the VerifyCap state, but the passing lanes do not meet the local link width policy",
 	[0x34] = tx_out_of_policy,
+	[0x35] = "Negotiated link width is mutually exclusive",
+	[0x36] =
+	  "Timed out before receiving verifycap frames in VerifyCap.Exchange",
+	[0x37] = "Unable to resolve secure data exchange",
 };
 
 static const char *state_complete_reason_code_string(struct hfi1_pportdata *ppd,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
