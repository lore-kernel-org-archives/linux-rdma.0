From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH RESEND infiniband-diags] saquery.c: Fix changing qos_class
 flag value to network order twice
Date: Tue, 5 Apr 2016 08:53:05 -0400
Message-ID: <5703B531.3000505@dev.mellanox.co.il>
References: <57021F03.5030805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57021F03.5030805-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix the qos_class flag value from being converted to network order twice.
The first time is in "CHECK_AND_SET_VAL" and the second is inside
"ib_path_rec_set_qos_class".

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/saquery.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index c0f42e8..ea946a1 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -1065,8 +1065,9 @@ static int query_path_records(const struct query_cmd *q, struct sa_handle * h,
 	pr.num_path |= reversible << 7;
 	CHECK_AND_SET_VAL(p->pkey, 16, 0, pr.pkey, PR, PKEY);
 	CHECK_AND_SET_VAL(p->sl, 16, -1, pr.qos_class_sl, PR, SL);
-	CHECK_AND_SET_VAL(p->qos_class, 16, -1, qos_class, PR, QOS_CLASS);
-	ib_path_rec_set_qos_class(&pr, qos_class);
+	CHECK_AND_SET_VAL((p->qos_class << 4), 16, -1, qos_class, PR, QOS_CLASS);
+	pr.qos_class_sl = (pr.qos_class_sl & CL_HTON16(IB_PATH_REC_SL_MASK)) |
+			  qos_class;
 	CHECK_AND_SET_VAL_AND_SEL(p->mtu, pr.mtu, PR, MTU, SELEC);
 	CHECK_AND_SET_VAL_AND_SEL(p->rate, pr.rate, PR, RATE, SELEC);
 	CHECK_AND_SET_VAL_AND_SEL(p->pkt_life, pr.pkt_life, PR, PKTLIFETIME,


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
