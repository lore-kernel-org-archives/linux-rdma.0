From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] IB/hfi1: Return invalid field for non-QSFP CableInfo
 queries
Date: Tue, 16 Aug 2016 13:25:34 -0700
Message-ID: <20160816202343.24004.69623.stgit@scvm10.sc.intel.com>
References: <20160816202133.24004.31487.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160816202133.24004.31487.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The driver does not check if the CableInfo query is supported for the
port type. Return early if CableInfo is not supported for the port type,
making compliance with the specification explicit and preventing lower
level code from potentially doing the wrong thing if the query is not
supported for the hardware implementation.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 1263abe..d9d909b 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -1819,6 +1819,11 @@ static int __subn_get_opa_cable_info(struct opa_smp *smp, u32 am, u8 *data,
 	u32 len = OPA_AM_CI_LEN(am) + 1;
 	int ret;
 
+	if (dd->pport->port_type != PORT_TYPE_QSFP) {
+		smp->status |= IB_SMP_INVALID_FIELD;
+		return reply((struct ib_mad_hdr *)smp);
+	}
+
 #define __CI_PAGE_SIZE BIT(7) /* 128 bytes */
 #define __CI_PAGE_MASK ~(__CI_PAGE_SIZE - 1)
 #define __CI_PAGE_NUM(a) ((a) & __CI_PAGE_MASK)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
