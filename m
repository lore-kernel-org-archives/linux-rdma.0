From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH 04/26] IB/ocrdma: Delete unnecessary variable
 initialisations in ocrdma_mbx_get_dcbx_config()
Date: Wed, 8 Mar 2017 16:06:14 +0200
Message-ID: <20170308140613.GD4828@yuval-lap>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <5780384b-87ef-fb39-6804-35f7eaada0c7@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5780384b-87ef-fb39-6804-35f7eaada0c7@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 08, 2017 at 01:48:46PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 7 Mar 2017 19:25:55 +0100
> 
> The local variables "req" and "rsp" will be set to appropriate pointers
> a bit later. Thus omit the explicit initialisations at the beginning.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> index 85bebb887c5c..517a18e9351a 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -2895,9 +2895,8 @@ static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
>  	int status;
>  	dma_addr_t pa;
>  	struct ocrdma_mqe cmd;
> -
> -	struct ocrdma_get_dcbx_cfg_req *req = NULL;
> -	struct ocrdma_get_dcbx_cfg_rsp *rsp = NULL;
> +	struct ocrdma_get_dcbx_cfg_req *req;
> +	struct ocrdma_get_dcbx_cfg_rsp *rsp;

Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>

>  	struct pci_dev *pdev = dev->nic_info.pdev;
>  	struct ocrdma_mqe_sge *mqe_sge = cmd.u.nonemb_req.sge;
>  
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
