From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC v1 12/19] RDMA/irdma: Implement device supported verb APIs
Date: Fri, 15 Feb 2019 15:32:21 -0700
Message-ID: <20190215223221.GC8001@ziepe.ca>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-13-shiraz.saleem@intel.com>
 <20190215173539.GD30706@ziepe.ca>
 <20190215221902.GA7092@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190215221902.GA7092@ssaleem-MOBL4.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 15, 2019 at 04:19:02PM -0600, Shiraz Saleem wrote:
> On Fri, Feb 15, 2019 at 10:35:39AM -0700, Jason Gunthorpe wrote:
> > On Fri, Feb 15, 2019 at 11:10:59AM -0600, Shiraz Saleem wrote:
> >
> [..]
> 
> > > + */
> > > +int irdma_register_rdma_device(struct irdma_device *iwdev)
> > > +{
> > > +	int ret;
> > > +	struct irdma_ib_device *iwibdev;
> > > +
> > > +	ret = irdma_init_rdma_device(iwdev);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	iwibdev = iwdev->iwibdev;
> > > +	rdma_set_device_sysfs_group(&iwibdev->ibdev, &irdma_attr_group);
> > > +	if (iwdev->rf->sc_dev.hw_attrs.hw_rev == IRDMA_GEN_1)
> > > +		/* backward compat with old user-space libi40iw */
> > > +		iwibdev->ibdev.driver_id = RDMA_DRIVER_I40IW;
> > 
> > Really? Then what is the problem in rdma-core? 
> 
> Let me try to explain. There are some assumptions here since we dont
> know the timelines for how the removal of i40iw/libi40iw works.
> 
> In the ideal scenario, if i40iw/libi40iw can be removed at the
> point of irdma/libirdma submission, then we just rename driver_id enum
> RDMA_DRIVER_I40IW to RDMA_DRIVER_IRDMA. Older rdma-core which contain libi40iw
> will also continue to work.
> 
> If its a staged approach in which irdma and i40iw will exist for a while before
> deprecation of i40iw (which is what is assumed here) then we need a seperate
> driver id RDMA_DRIVER_IRDMA.
> 
> X722 device registration via irdma driver (only when i40iw is disabled) uses
> RDMA_DRIVER_I40IW to work with existing libi40iw.
> 
> E810 device registration uses RDMA_DRIVER_IRDMA. libirdma uses
> RDMA_DRIVER_IRDMA and really only associates with E810 devs.

I don't understand why you need two driver IDs. If this driver is
fully ABI compatible with I40IW user space, then just use that ID.

The new X722 features should be designed to extend the ABI already
defined for I40IW, just like every other driver has done for new
capabilities and features.

Generally since our userspace is using PCI-ID probing to match
drivers, a new chip (ie X722) will not bind to an old user space until
that userspace knows the new chip id and thus knows how to support the
extended ABI. 

The userspace should use the new ABI in a way that cause an old kernel
to reject it for extra safety.

Jason
