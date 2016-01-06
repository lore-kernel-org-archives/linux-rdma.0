From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 10/15] IB/srpt: Fix srpt_handle_cmd() error paths
Date: Wed, 6 Jan 2016 16:31:47 +0200
Message-ID: <568D2553.8050302@dev.mellanox.co.il>
References: <568BD0FC.70207@sandisk.com> <568BD249.1000100@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568BD249.1000100-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 05/01/2016 16:25, Bart Van Assche wrote:
> The target core function that should be called if target_submit_cmd()
> fails is target_put_sess_cmd(). Additionally, change the return type
> of srpt_handle_cmd() from int into void.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srpt/ib_srpt.c | 24 ++++++++++++------------
>   1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 1857d17..395bc1b 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1482,15 +1482,14 @@ static int srpt_check_stop_free(struct se_cmd *cmd)
>   /**
>    * srpt_handle_cmd() - Process SRP_CMD.
>    */
> -static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
> -			   struct srpt_recv_ioctx *recv_ioctx,
> -			   struct srpt_send_ioctx *send_ioctx)
> +static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
> +			    struct srpt_recv_ioctx *recv_ioctx,
> +			    struct srpt_send_ioctx *send_ioctx)
>   {
>   	struct se_cmd *cmd;
>   	struct srp_cmd *srp_cmd;
>   	u64 data_len;
>   	enum dma_data_direction dir;
> -	sense_reason_t ret;
>   	int rc;
>
>   	BUG_ON(!send_ioctx);
> @@ -1518,8 +1517,7 @@ static int srpt_handle_cmd(struct srpt_rdma_ch *ch,
>   	if (srpt_get_desc_tbl(send_ioctx, srp_cmd, &dir, &data_len)) {
>   		pr_err("0x%llx: parsing SRP descriptor table failed.\n",
>   		       srp_cmd->tag);
> -		ret = TCM_INVALID_CDB_FIELD;
> -		goto send_sense;
> +		goto put;

Do you still need to call target_put_sess_cmd() in this failure?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
