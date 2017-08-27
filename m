From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH] IB/usnic: check for allocation failure
Date: Sun, 27 Aug 2017 11:32:09 +0300
Message-ID: <20170827083208.GB5681@yuvallap>
References: <20170825083030.rga3kllp55xnr3jf@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170825083030.rga3kllp55xnr3jf@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Christian Benvenuti <benve@cisco.com>, Upinder Malhi <umalhi@cisco.com>, Dave Goodell <dgoodell@cisco.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 25, 2017 at 11:43:59AM +0300, Dan Carpenter wrote:
> usnic_uiom_get_dev_list() can return ERR_PTR(-ENOMEM) so we should check
> for that.
> 
> Fixes: e3cf00d0a87f ("IB/usnic: Add Cisco VIC low-level hardware driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> index e5f57dd49980..e8523882e33b 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -164,6 +164,8 @@ find_free_vf_and_create_qp_grp(struct usnic_ib_dev *us_ibdev,
>  	if (usnic_ib_share_vf) {
>  		/* Try to find resouces on a used vf which is in pd */
>  		dev_list = usnic_uiom_get_dev_list(pd->umem_pd);
> +		if (IS_ERR(dev_list))
> +			return ERR_CAST(dev_list);
>  		for (i = 0; dev_list[i]; i++) {
>  			dev = dev_list[i];
>  			vf = pci_get_drvdata(to_pci_dev(dev));

Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
