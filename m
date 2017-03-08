From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH 10/26] IB/ocrdma: Improve another size determination in
 ocrdma_init_emb_mqe()
Date: Wed, 8 Mar 2017 16:22:57 +0200
Message-ID: <20170308142256.GI4828@yuval-lap>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <4d92b910-f0fb-1362-0392-fccd8af1d169@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4d92b910-f0fb-1362-0392-fccd8af1d169@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 08, 2017 at 02:02:46PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 7 Mar 2017 20:33:29 +0100
> 
> Replace the specification of a data structure by a pointer dereference
> as the parameter for the operator "sizeof" to make the corresponding size
> determination a bit safer according to the Linux coding style convention.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> index 7d1e1caa90de..aa32bc9f323d 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -352,7 +352,7 @@ static void *ocrdma_init_emb_mqe(u8 opcode, u32 cmd_len)
>  {
>  	struct ocrdma_mqe *mqe;
>  
> -	mqe = kzalloc(sizeof(struct ocrdma_mqe), GFP_KERNEL);
> +	mqe = kzalloc(sizeof(*mqe), GFP_KERNEL);
>  	if (!mqe)
>  		return NULL;
>  	mqe->hdr.spcl_sge_cnt_emb |=

Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>

> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
