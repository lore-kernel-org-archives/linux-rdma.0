From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH 03/26] IB/ocrdma: Improve size determinations in
 ocrdma_mbx_get_dcbx_config()
Date: Wed, 8 Mar 2017 15:54:10 +0200
Message-ID: <20170308135409.GB4828@yuval-lap>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <907034da-34ae-9e5b-6e56-3a2feb4924da@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <907034da-34ae-9e5b-6e56-3a2feb4924da@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 08, 2017 at 01:45:43PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 7 Mar 2017 19:09:20 +0100
> 
> Replace the specification of data structures by references for variables
> as the parameter for the operator "sizeof" to make the corresponding size
> determinations a bit safer according to the Linux coding style convention.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> index d5a3127b6df8..85bebb887c5c 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -2901,9 +2901,8 @@ static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
>  	struct pci_dev *pdev = dev->nic_info.pdev;
>  	struct ocrdma_mqe_sge *mqe_sge = cmd.u.nonemb_req.sge;
>  
> -	memset(&cmd, 0, sizeof(struct ocrdma_mqe));
> -	cmd.hdr.pyld_len = max_t (u32, sizeof(struct ocrdma_get_dcbx_cfg_rsp),
> -					sizeof(struct ocrdma_get_dcbx_cfg_req));
> +	memset(&cmd, 0, sizeof(cmd));
> +	cmd.hdr.pyld_len = max_t(u32, sizeof(*rsp), sizeof(*req));
>  	req = dma_alloc_coherent(&pdev->dev, cmd.hdr.pyld_len, &pa, GFP_KERNEL);
>  	if (!req) {
>  		status = -ENOMEM;
> @@ -2915,8 +2914,7 @@ static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
>  	mqe_sge->pa_lo = (u32) (pa & 0xFFFFFFFFUL);
>  	mqe_sge->pa_hi = (u32) upper_32_bits(pa);
>  	mqe_sge->len = cmd.hdr.pyld_len;
> -
> -	memset(req, 0, sizeof(struct ocrdma_get_dcbx_cfg_req));
> +	memset(req, 0, sizeof(*req));
>  	ocrdma_init_mch(&req->hdr, OCRDMA_CMD_GET_DCBX_CONFIG,
>  			OCRDMA_SUBSYS_DCBX, cmd.hdr.pyld_len);
>  	req->param_type = ptype;
> @@ -2926,9 +2924,8 @@ static int ocrdma_mbx_get_dcbx_config(struct ocrdma_dev *dev, u32 ptype,
>  		goto mbx_err;
>  
>  	rsp = (struct ocrdma_get_dcbx_cfg_rsp *)req;
> -	ocrdma_le32_to_cpu(rsp, sizeof(struct ocrdma_get_dcbx_cfg_rsp));
> -	memcpy(dcbxcfg, &rsp->cfg, sizeof(struct ocrdma_dcbx_cfg));
> -
> +	ocrdma_le32_to_cpu(rsp, sizeof(*rsp));
> +	memcpy(dcbxcfg, &rsp->cfg, sizeof(*dcbxcfg));
>  mbx_err:
>  	dma_free_coherent(&pdev->dev, cmd.hdr.pyld_len, req, pa);
>  mem_err:

Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>

> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
