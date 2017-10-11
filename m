From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 28/45] IB/nes: Suppress gcc 7 fall-through complaints
Date: Wed, 11 Oct 2017 18:11:54 +0000
Message-ID: <1EEBC91386407A4A8D1EBE1DD5AA5212822DF07A@FMSMSX114.amr.corp.intel.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
 <20171011174927.25113-29-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-29-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>-----Original Message-----
>From: Bart Van Assche [mailto:bart.vanassche-Sjgp3cTcYWE@public.gmane.org]
>Sent: Wednesday, October 11, 2017 12:49 PM
>To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>;
>Latif, Faisal <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>Subject: [PATCH v2 28/45] IB/nes: Suppress gcc 7 fall-through complaints
>
>Avoid that gcc 7 reports the following warning when building with W=1:
>
>warning: this statement may fall through [-Wimplicit-fallthrough=]
>
>Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
>Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>---
> drivers/infiniband/hw/nes/nes_cm.c | 1 +
>drivers/infiniband/hw/nes/nes_hw.c | 2 +-
> 2 files changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/infiniband/hw/nes/nes_cm.c
>b/drivers/infiniband/hw/nes/nes_cm.c
>index de4025deaa4a..a5f6dffef07a 100644
>--- a/drivers/infiniband/hw/nes/nes_cm.c
>+++ b/drivers/infiniband/hw/nes/nes_cm.c
>@@ -1768,6 +1768,7 @@ static void handle_rst_pkt(struct nes_cm_node
>*cm_node, struct sk_buff *skb,
> 	case NES_CM_STATE_FIN_WAIT1:
> 	case NES_CM_STATE_LAST_ACK:
> 		cm_node->cm_id->rem_ref(cm_node->cm_id);
>+		/* fall through */
> 	case NES_CM_STATE_TIME_WAIT:
> 		cm_node->state = NES_CM_STATE_CLOSED;
> 		rem_ref_cm_node(cm_node->cm_core, cm_node); diff --git
>a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
>index 812b59d8f13c..c392f83c0629 100644
>--- a/drivers/infiniband/hw/nes/nes_hw.c
>+++ b/drivers/infiniband/hw/nes/nes_hw.c
>@@ -3632,7 +3632,7 @@ static void nes_process_iwarp_aeqe(struct
>nes_device *nesdev,
> 				aeq_info |=
>NES_AEQE_AEID_RDMAP_ROE_UNEXPECTED_OPCODE;
> 				aeqe->aeqe_words[NES_AEQE_MISC_IDX] =
>cpu_to_le32(aeq_info);
> 			}
>-
>+			/* fall through */
> 		case NES_AEQE_AEID_RDMAP_ROE_BAD_LLP_CLOSE:
> 		case NES_AEQE_AEID_LLP_TOO_MANY_RETRIES:
> 		case
>NES_AEQE_AEID_DDP_UBE_INVALID_MSN_NO_BUFFER_AVAILABLE:
>--
>2.14.2

Acked-by: Faisal Latif <fasial.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
