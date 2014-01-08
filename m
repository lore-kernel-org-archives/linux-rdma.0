From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -next] IB/usnic: fix some error return code
Date: Wed, 8 Jan 2014 00:31:40 +0000
Message-ID: <97F52CD2-C7EE-4009-AD75-C77168D10DAF@cisco.com>
References: <CAPgLHd_evqPnt2rjTX3B=jhfD5qmvDk_QdKBgTE2iSZiWw7mOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPgLHd_evqPnt2rjTX3B=jhfD5qmvDk_QdKBgTE2iSZiWw7mOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <3F071ED1E362F14B96631CB06CFAFF99-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "<sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "<hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "<yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>" <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>, "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

http://www.spinics.net/lists/linux-rdma/msg18127.html is a superset of patch below.  There is a slight difference in handling of the return value of usnic_ib_discover_pf between the patches, but the difference is superficial.  

Upinder

On Dec 15, 2013, at 9:50 PM, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
> 
> This patch make usnic_ib_discover_pf() only return ERR_PTR()
> only and fix to return a negative error code from the error
> handling case instead of 0.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
> ---
> drivers/infiniband/hw/usnic/usnic_ib_main.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> index 2bbfa09..e07cccc 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> @@ -406,6 +406,7 @@ static struct usnic_ib_dev *usnic_ib_discover_pf(struct usnic_vnic *vnic)
> 	err = usnic_ib_sysfs_register_usdev(us_ibdev);
> 	if (err) {
> 		usnic_ib_device_remove(us_ibdev);
> +		us_ibdev = ERR_PTR(err);
> 		goto out;
> 	}
> 
> @@ -460,7 +461,8 @@ int usnic_ib_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> 	}
> 
> 	pf = usnic_ib_discover_pf(vf->vnic);
> -	if (!pf) {
> +	if (IS_ERR(pf)) {
> +		err = PTR_ERR(pf);
> 		usnic_err("Failed to discover pf of vnic %s with err%d\n",
> 				pci_name(pdev), err);
> 		goto out_clean_vnic;
> @@ -543,7 +545,8 @@ static int __init usnic_ib_init(void)
> 		return err;
> 	}
> 
> -	if (pci_register_driver(&usnic_ib_pci_driver)) {
> +	err = pci_register_driver(&usnic_ib_pci_driver);
> +	if (err) {
> 		usnic_err("Unable to register with PCI\n");
> 		goto out_umem_fini;
> 	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
