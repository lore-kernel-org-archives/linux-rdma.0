From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v7 01/13] PCI/P2PDMA: Support peer-to-peer memory
Date: Tue, 25 Sep 2018 10:25:40 -0700
Message-ID: <1537896340.11137.19.camel@acm.org>
References: <20180925162231.4354-1-logang@deltatee.com>
 <20180925162231.4354-2-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180925162231.4354-2-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2018-09-25 at 10:22 -0600, Logan Gunthorpe wrote:
> [ ... ]

Hi Logan,

It's great to see this patch series making progress. Unfortunately I didn't
have the time earlier to have a closer look at this patch series. I hope that
you don't mind that I ask a few questions about the implementation?

> +static void pci_p2pdma_percpu_kill(void *data)
> +{
> +	struct percpu_ref *ref = data;
> +
> +	if (percpu_ref_is_dying(ref))
> +		return;
> +
> +	percpu_ref_kill(ref);
> +}

The percpu_ref_is_dying() test should either be removed or a comment should be
added above it that explains why it is necessary. Is the purpose of that call
perhaps to protect against multiple calls of pci_p2pdma_percpu_kill()? If so,
which mechanism serializes these multiple calls?

> +static void pci_p2pdma_release(void *data)
> +{
> +	struct pci_dev *pdev = data;
> +
> +	if (!pdev->p2pdma)
> +		return;
> +
> +	wait_for_completion(&pdev->p2pdma->devmap_ref_done);
> +	percpu_ref_exit(&pdev->p2pdma->devmap_ref);
> +
> +	gen_pool_destroy(pdev->p2pdma->pool);
> +	pdev->p2pdma = NULL;
> +}

Which code frees the memory pdev->p2pdma points at? Other functions similar to
pci_p2pdma_release() call devm_remove_action(), e.g. hmm_devmem_ref_exit().

> +static int pci_p2pdma_setup(struct pci_dev *pdev)
> +{
> +	int error = -ENOMEM;
> +	struct pci_p2pdma *p2p;
> +
> +	p2p = devm_kzalloc(&pdev->dev, sizeof(*p2p), GFP_KERNEL);
> +	if (!p2p)
> +		return -ENOMEM;
> +
> +	p2p->pool = gen_pool_create(PAGE_SHIFT, dev_to_node(&pdev->dev));
> +	if (!p2p->pool)
> +		goto out;
> +
> +	init_completion(&p2p->devmap_ref_done);
> +	error = percpu_ref_init(&p2p->devmap_ref,
> +			pci_p2pdma_percpu_release, 0, GFP_KERNEL);
> +	if (error)
> +		goto out_pool_destroy;
> +
> +	percpu_ref_switch_to_atomic_sync(&p2p->devmap_ref);

Why are percpu_ref_init() and percpu_ref_switch_to_atomic_sync() called
separately instead of passing PERCPU_REF_INIT_ATOMIC to percpu_ref_init()?
Would using PERCPU_REF_INIT_ATOMIC eliminate a call_rcu_sched() call and
hence make this function faster?

> +static struct pci_dev *find_parent_pci_dev(struct device *dev)
> +{
> +	struct device *parent;
> +
> +	dev = get_device(dev);
> +
> +	while (dev) {
> +		if (dev_is_pci(dev))
> +			return to_pci_dev(dev);
> +
> +		parent = get_device(dev->parent);
> +		put_device(dev);
> +		dev = parent;
> +	}
> +
> +	return NULL;
> +}

The above function increases the reference count of the device it returns a
pointer to. It is a good habit to explain such behavior above the function
definition.

> +static void seq_buf_print_bus_devfn(struct seq_buf *buf, struct pci_dev *pdev)
> +{
> +	if (!buf)
> +		return;
> +
> +	seq_buf_printf(buf, "%s;", pci_name(pdev));
> +}

NULL checks in functions that print to a seq buffer are unusual. Is it
possible that a NULL pointer gets passed as the first argument to
seq_buf_print_bus_devfn()?

> +struct pci_p2pdma_client {
> +	struct list_head list;
> +	struct pci_dev *client;
> +	struct pci_dev *provider;
> +};

Is there a reason that the peer-to-peer client and server code exist in the
same source file? If not, have you considered to split the p2pdma.c file into
two files - one with the code for devices that provide p2p functionality and
another file with the code that supports p2p users? I think that would make it
easier to follow the code.

> +/**
> + * pci_free_p2pmem - allocate peer-to-peer DMA memory
> + * @pdev: the device the memory was allocated from
> + * @addr: address of the memory that was allocated
> + * @size: number of bytes that was allocated
> + */
> +void pci_free_p2pmem(struct pci_dev *pdev, void *addr, size_t size)
> +{
> +	gen_pool_free(pdev->p2pdma->pool, (uintptr_t)addr, size);
> +	percpu_ref_put(&pdev->p2pdma->devmap_ref);
> +}
> +EXPORT_SYMBOL_GPL(pci_free_p2pmem);

Please fix the header of this function - there is a copy-paste error in the
function header.

Thanks,

Bart.
