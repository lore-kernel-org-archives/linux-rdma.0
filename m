From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v7 02/13] PCI/P2PDMA: Add sysfs group to display p2pmem
 stats
Date: Tue, 25 Sep 2018 11:31:20 -0700
Message-ID: <1537900280.11137.30.camel@acm.org>
References: <20180925162231.4354-1-logang@deltatee.com>
 <20180925162231.4354-3-logang@deltatee.com>
 <1537896555.11137.22.camel@acm.org>
 <9241a6af-9826-d1ff-c13b-882cb3b6a34a@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <9241a6af-9826-d1ff-c13b-882cb3b6a34a-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
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

On Tue, 2018-09-25 at 12:15 -0600, Logan Gunthorpe wrote:
> On 2018-09-25 11:29 a.m., Bart Van Assche wrote:
> > On Tue, 2018-09-25 at 10:22 -0600, Logan Gunthorpe wrote:
> > > @@ -83,9 +132,14 @@ static int pci_p2pdma_setup(struct pci_dev *pdev)
> > >  
> > >  	pdev->p2pdma = p2p;
> > >  
> > > +	error = sysfs_create_group(&pdev->dev.kobj, &p2pmem_group);
> > > +	if (error)
> > > +		goto out_pool_destroy;
> > > +
> > >  	return 0;
> > >  
> > >  out_pool_destroy:
> > > +	pdev->p2pdma = NULL;
> > >  	gen_pool_destroy(p2p->pool);
> > >  out:
> > >  	devm_kfree(&pdev->dev, p2p);
> > 
> > This doesn't look right to me. Shouldn't devm_remove_action() be called instead
> > of devm_kfree() if sysfs_create_group() fails?
> 
> That makes no sense to me. We are reversing a devm_kzalloc() not a
> custom action....

In case what I wrote was not clear: both devm_kzalloc() and
devm_add_action_or_reset() have to be reversed if sysfs_create_group() fails.
devm_add_action_or_reset() calls devres_add(). The latter function adds an
element to the dev->devres_head list. So I think that only calling devm_kfree()
if sysfs_create_group() fails will lead to corruption of the dev->devres_head
list.

Bart.
