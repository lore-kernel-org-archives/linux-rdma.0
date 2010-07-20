From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH for-2.6.36] ib: fix some sparse warnings
Date: Tue, 20 Jul 2010 13:15:25 -0500
Message-ID: <4C45E7BD.4010404@opengridcomputing.com>
References: <Pine.LNX.4.64.1007201458210.3835@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1007201458210.3835-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Or Gerlitz wrote:
> fixed the following drivers/infiniband sparse pointed issues
>
>   CHECK   drivers/infiniband/hw/cxgb3/iwch_cm.c
> iwch_cm.c:140:5: warning: symbol 'iwch_l2t_send' was not declared. Should it be static?
>   CHECK   drivers/infiniband/hw/nes/nes_verbs.c
> nes_verbs.c:1944:45: warning: Using plain integer as NULL pointer
> nes_verbs.c:1944:48: warning: Using plain integer as NULL pointer
>   CHECK   drivers/infiniband/hw/nes/nes_cm.c
> nes_cm.c:2645:43: warning: mixing different enum types
> nes_cm.c:2645:43:     int enum iw_cm_event_type  versus
> nes_cm.c:2645:43:     int enum iw_cm_event_status
>   CHECK   drivers/infiniband/ulp/iser/iser_initiator.c
> iser_initiator.c:173:5: warning: symbol 'iser_alloc_rx_descriptors' was not declared. Should it be static?
>
> Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> --------
>
> I didn't address these two
>
>   CHECK   drivers/infiniband/hw/cxgb3/iwch_cq.c
> drivers/infiniband/hw/cxgb3/iwch_cq.c:192:9: warning: context imbalance in 'iwch_poll_cq_one' - different lock contexts for basic block
>   CHECK   drivers/infiniband/hw/cxgb3/iwch_qp.c
> drivers/infiniband/hw/cxgb3/iwch_qp.c:805:13: warning: context imbalance in '__flush_qp' - unexpected unlock
>
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
> index ebfb117..3cdb535 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
> @@ -137,7 +137,7 @@ static void stop_ep_timer(struct iwch_ep *ep)
>  	put_ep(&ep->com);
>  }
>
> -int iwch_l2t_send(struct t3cdev *tdev, struct sk_buff *skb, struct l2t_entry *l2e)
> +static int iwch_l2t_send(struct t3cdev *tdev, struct sk_buff *skb, struct l2t_entry *l2e)
>  {
>  	int	error = 0;
>  	struct cxio_rdev *rdev;
> diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
> index 986d6f3..98887af 100644
> --- a/drivers/infiniband/hw/nes/nes_cm.c
> +++ b/drivers/infiniband/hw/nes/nes_cm.c
> @@ -2565,7 +2565,7 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
>  	u16 last_ae;
>  	u8 original_hw_tcp_state;
>  	u8 original_ibqp_state;
> -	enum iw_cm_event_type disconn_status = IW_CM_EVENT_STATUS_OK;
> +	enum iw_cm_event_status  disconn_status = IW_CM_EVENT_STATUS_OK;
>  	int issue_disconn = 0;
>  	int issue_close = 0;
>  	int issue_flush = 0;
> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
> index 9bc2d74..0df51a4 100644
> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
> @@ -1941,7 +1941,7 @@ static int nes_reg_mr(struct nes_device *nesdev, struct nes_pd *nespd,
>  	u8  use_256_pbls = 0;
>  	u8  use_4k_pbls = 0;
>  	u16 use_two_level = (pbl_count_4k > 1) ? 1 : 0;
> -	struct nes_root_vpbl new_root = {0, 0, 0};
> +	struct nes_root_vpbl new_root = {0, NULL, NULL};
>  	u32 opcode = 0;
>  	u16 major_code;
>
> diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
> index 0b9ef07..95a08a8 100644
> --- a/drivers/infiniband/ulp/iser/iser_initiator.c
> +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
> @@ -170,7 +170,7 @@ static void iser_create_send_desc(struct iser_conn	*ib_conn,
>  }
>
>
> -int iser_alloc_rx_descriptors(struct iser_conn *ib_conn)
> +static int iser_alloc_rx_descriptors(struct iser_conn *ib_conn)
>  {
>  	int i, j;
>  	u64 dma_addr;
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
