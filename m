From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/12] pci-p2p: Clear ACS P2P flags for all client
 devices
Date: Fri, 5 Jan 2018 10:18:15 -0700
Message-ID: <20180105101815.0fcbc142@t450s.home>
References: <20180104190137.7654-1-logang@deltatee.com>
        <20180104190137.7654-5-logang@deltatee.com>
        <20180104215721.GF189897@bhelgaas-glaptop.roam.corp.google.com>
        <20180104153551.3118f71b@t450s.home>
        <20fdb5bb-0236-c093-ed53-e12664022f53@deltatee.com>
        <20180104203300.79487c98@w520.home>
        <77ec7893-6ff5-ebdf-163d-fc4e02077cc2@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <77ec7893-6ff5-ebdf-163d-fc4e02077cc2-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 5 Jan 2018 10:10:51 -0700
Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:

> On 04/01/18 08:33 PM, Alex Williamson wrote:
> > That's exactly what IOMMU groups represent, the smallest set of devices
> > which have DMA isolation from other devices.  By poking this hole, the
> > IOMMU group is invalid.  We cannot turn off ACS only for a specific
> > device, in order to enable p2p it needs to be disabled at every
> > downstream port between the devices where we want to enable p2p.
> > Depending on the topology, that could mean we're also enabling p2p for
> > unrelated devices.  Those unrelated devices might be in active use and
> > the p2p IOVAs now have a different destination which is no longer IOMMU
> > translated.  
> 
> Oh, so IOMMU groups are created based on the existing hierarchy at boot 
> time and not based on the user's needs for isolation?

Yes, IOMMU groups expose the isolation of the system as devices are
discovered.  Nothing currently accounts for intentionally decreasing
the isolation between devices.  Thanks,

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
