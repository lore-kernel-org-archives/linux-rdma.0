From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 02/12] pci-p2p: Add sysfs group to display p2pmem stats
Date: Thu, 4 Jan 2018 15:25:29 -0700
Message-ID: <20180104222529.GS11972@mellanox.com>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-3-logang@deltatee.com>
 <20180104215040.GE189897@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180104215040.GE189897-1RhO1Y9PlrlHTL0Zs8A6p5iNqAH0jzoTYJqu5kTmcBRl57MIdRCFDg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 04, 2018 at 03:50:40PM -0600, Bjorn Helgaas wrote:
> >  		This is similar to /sys/bus/pci/drivers_autoprobe, but
> >  		affects only the VFs associated with a specific PF.
> > +
> > +What:		/sys/bus/pci/devices/.../p2pmem/available
> 
> I wonder if "p2pdma" would be a more suggestive term?  It's not really
> the *memory* that is peer-to-peer; the peer-to-peer part is referring
> to *access* to the memory.

There have been out of tree patches using P2P DMA for a long time, and
some of the use cases have nothing to do with 'memory' - eg DMA to
'registers'

I notice that this series particularly focus on treating the target
BAR as 'memory' - ie it puts genalloc on top of the BAR, and I guess
treat all addresses as equal and interchangable.

If this series gets accepted I would expect proposals to extend this
infrastructure to allow for P2P for registers in some way as well.

So I think the 'p2pmem' name is a good choice only when it is in
places that talk about the genalloc part of this design.

We should reserve p2pdma to talk about the generic infrastructure
unrelated to the genalloc pool.

Since these sysfs's seem to report the genalloc pool status, p2pmem
seems like a good choice to me.

> > @@ -82,6 +130,9 @@ static int pci_p2pmem_setup(struct pci_dev *pdev)
> >  	if (error)
> >  		goto out_pool_destroy;
> >  
> > +	if (sysfs_create_group(&pdev->dev.kobj, &p2pmem_group))
> > +		dev_warn(&pdev->dev, "failed to create p2p sysfs group\n");
> 
> Not sure the warning (by itself) is worthwhile.  If we were going to
> disable the feature if sysfs_create_group() failed, that's one thing,
> but we aren't doing anything except generating a warning, which the
> user can't really do anything with.  If the user is looking for the
> sysfs file, its absence will be obvious even without the message.

Don't most of the failure paths inside sysfs_create_group cause prints
anyhow?

Jason
