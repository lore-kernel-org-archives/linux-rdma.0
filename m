From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/srpt: Suppress a compiler warning
Date: Mon, 30 Mar 2015 16:22:20 +0300
Message-ID: <55194E0C.702@dev.mellanox.co.il>
References: <5519275F.6070102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5519275F.6070102-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/30/2015 1:37 PM, Bart Van Assche wrote:
> Remove a BUG_ON(!ch) statement because it is superfluous - if
> the ch pointer would be NULL then the assignment in the first
> line of srpt_map_sg_to_ib_sge() would trigger a kernel oops anyway.
>
> This patch suppresses the following compiler warning:
>
> Possible null pointer dereference: ch - otherwise it is redundant to
> check it against null.
>
> Reported-by: David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srpt/ib_srpt.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c
> b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 6e0a477..4e74fc8 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1095,7 +1095,6 @@ static int srpt_map_sg_to_ib_sge(struct
> srpt_rdma_ch *ch,
>   	int count, nrdma;
>   	int i, j, k;
>
> -	BUG_ON(!ch);
>   	BUG_ON(!ioctx);
>   	cmd = &ioctx->cmd;
>   	dir = cmd->data_direction;
>

Acked-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
