From: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 02/10] PCI/P2PDMA: Add sysfs group to display p2pmem
 stats
Date: Thu, 1 Mar 2018 11:44:50 -0600
Message-ID: <20180301174450.GF13722@bhelgaas-glaptop.roam.corp.google.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-3-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180228234006.21093-3-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 28, 2018 at 04:39:58PM -0700, Logan Gunthorpe wrote:
> Attributes display the total amount of P2P memory, the amount available
> and whether it is published or not.

Can you add enough text here to make the body of the changelog
complete in itself?  That might mean just repeating the subject, which
is fine.

> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci | 25 +++++++++++++++++
>  drivers/pci/p2pdma.c                    | 50 +++++++++++++++++++++++++++++++++
>  2 files changed, 75 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 44d4b2be92fd..f5656dae21be 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -323,3 +323,28 @@ Description:
>  
>  		This is similar to /sys/bus/pci/drivers_autoprobe, but
>  		affects only the VFs associated with a specific PF.
> +
> +What:		/sys/bus/pci/devices/.../p2pmem/available
> +Date:		November 2017
> +Contact:	Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> +Description:
> +		If the device has any Peer-to-Peer memory registered, this
> +	        file contains the amount of memory that has not been
> +		allocated (in decimal).
> +
> +What:		/sys/bus/pci/devices/.../p2pmem/size
> +Date:		November 2017
> +Contact:	Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> +Description:
> +		If the device has any Peer-to-Peer memory registered, this
> +	        file contains the total ammount of memory that the device

s/ammount/amount/

> +		provides (in decimal).
> +
> +What:		/sys/bus/pci/devices/.../p2pmem/published
> +Date:		November 2017
> +Contact:	Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> +Description:
> +		If the device has any Peer-to-Peer memory registered, this
> +	        file contains a '1' if the memory has been published for
> +		use inside the kernel or a '0' if it is only intended
> +		for use within the driver that published it.
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index ec0a6cb9e500..a57df78f6a32 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -29,6 +29,53 @@ struct pci_p2pdma {
>  	bool published;
>  };
>  
> +static ssize_t size_show(struct device *dev, struct device_attribute *attr,
> +			 char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	size_t size = 0;
> +
> +	if (pdev->p2pdma->pool)
> +		size = gen_pool_size(pdev->p2pdma->pool);
> +
> +	return snprintf(buf, PAGE_SIZE, "%zd\n", size);
> +}
> +static DEVICE_ATTR_RO(size);
> +
> +static ssize_t available_show(struct device *dev, struct device_attribute *attr,
> +			      char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	size_t avail = 0;
> +
> +	if (pdev->p2pdma->pool)
> +		avail = gen_pool_avail(pdev->p2pdma->pool);
> +
> +	return snprintf(buf, PAGE_SIZE, "%zd\n", avail);
> +}
> +static DEVICE_ATTR_RO(available);
> +
> +static ssize_t published_show(struct device *dev, struct device_attribute *attr,
> +			      char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", pdev->p2pdma->published);
> +}
> +static DEVICE_ATTR_RO(published);
> +
> +static struct attribute *p2pmem_attrs[] = {
> +	&dev_attr_size.attr,
> +	&dev_attr_available.attr,
> +	&dev_attr_published.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group p2pmem_group = {
> +	.attrs = p2pmem_attrs,
> +	.name = "p2pmem",
> +};
> +
>  static void pci_p2pdma_percpu_release(struct percpu_ref *ref)
>  {
>  	struct pci_p2pdma *p2p =
> @@ -55,6 +102,7 @@ static void pci_p2pdma_release(void *data)
>  	percpu_ref_exit(&pdev->p2pdma->devmap_ref);
>  
>  	gen_pool_destroy(pdev->p2pdma->pool);
> +	sysfs_remove_group(&pdev->dev.kobj, &p2pmem_group);
>  	pdev->p2pdma = NULL;
>  }
>  
> @@ -83,6 +131,8 @@ static int pci_p2pdma_setup(struct pci_dev *pdev)
>  	if (error)
>  		goto out_pool_destroy;
>  
> +	error = sysfs_create_group(&pdev->dev.kobj, &p2pmem_group);
> +
>  	pdev->p2pdma = p2p;

I think these two statements are out of order, since the attributes
dereference pdev->p2pdma.  And it looks like you set "error"
unnecessarily, since you return immediately looking at it.

>  	return 0;
> -- 
> 2.11.0
> 
