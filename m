From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 28/54] staging/rdma/hfi1: Fix for module parameter rcvhdrcnt
 when it's 2097152
Date: Wed, 03 Feb 2016 14:34:32 -0800
Message-ID: <20160203223428.5923.90837.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The driver crashes when loaded with parameter rcvhdrcnt=2097152.
The root cause was that rcvhdrcnt was initially a 32 bit variable
and its value was assigned to a 16 bit variable, truncating the
upper 16 bits. This patch prevents the user from passing a value
for rcvhdrcnt greater than 16352 (Maximum number for rcvhdrcnt).

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/init.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 6ddf3c8..eec9130 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -77,6 +77,7 @@
 #define HFI1_MIN_USER_CTXT_BUFCNT 7
 
 #define HFI1_MIN_HDRQ_EGRBUF_CNT 2
+#define HFI1_MAX_HDRQ_EGRBUF_CNT 16352
 #define HFI1_MIN_EAGER_BUFFER_SIZE (4 * 1024) /* 4KB */
 #define HFI1_MAX_EAGER_BUFFER_SIZE (256 * 1024) /* 256KB */
 
@@ -1355,6 +1356,13 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		ret = -EINVAL;
 		goto bail;
 	}
+	if (rcvhdrcnt > HFI1_MAX_HDRQ_EGRBUF_CNT) {
+		hfi1_early_err(&pdev->dev,
+			       "Receive header queue count cannot be greater than %u\n",
+			       HFI1_MAX_HDRQ_EGRBUF_CNT);
+		ret = -EINVAL;
+		goto bail;
+	}
 	/* use the encoding function as a sanitization check */
 	if (!encode_rcv_header_entry_size(hfi1_hdrq_entsize)) {
 		hfi1_early_err(&pdev->dev, "Invalid HdrQ Entry size %u\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
