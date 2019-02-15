From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC v1 12/19] RDMA/irdma: Implement device supported verb APIs
Date: Fri, 15 Feb 2019 16:19:02 -0600
Message-ID: <20190215221902.GA7092@ssaleem-MOBL4.amr.corp.intel.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-13-shiraz.saleem@intel.com>
 <20190215173539.GD30706@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190215173539.GD30706@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 15, 2019 at 10:35:39AM -0700, Jason Gunthorpe wrote:
> On Fri, Feb 15, 2019 at 11:10:59AM -0600, Shiraz Saleem wrote:
>
[..]

> > + */
> > +int irdma_register_rdma_device(struct irdma_device *iwdev)
> > +{
> > +	int ret;
> > +	struct irdma_ib_device *iwibdev;
> > +
> > +	ret = irdma_init_rdma_device(iwdev);
> > +	if (ret)
> > +		return ret;
> > +
> > +	iwibdev = iwdev->iwibdev;
> > +	rdma_set_device_sysfs_group(&iwibdev->ibdev, &irdma_attr_group);
> > +	if (iwdev->rf->sc_dev.hw_attrs.hw_rev == IRDMA_GEN_1)
> > +		/* backward compat with old user-space libi40iw */
> > +		iwibdev->ibdev.driver_id = RDMA_DRIVER_I40IW;
> 
> Really? Then what is the problem in rdma-core? 

Let me try to explain. There are some assumptions here since we dont
know the timelines for how the removal of i40iw/libi40iw works.

In the ideal scenario, if i40iw/libi40iw can be removed at the
point of irdma/libirdma submission, then we just rename driver_id enum
RDMA_DRIVER_I40IW to RDMA_DRIVER_IRDMA. Older rdma-core which contain libi40iw
will also continue to work.

If its a staged approach in which irdma and i40iw will exist for a while before
deprecation of i40iw (which is what is assumed here) then we need a seperate
driver id RDMA_DRIVER_IRDMA.

X722 device registration via irdma driver (only when i40iw is disabled) uses
RDMA_DRIVER_I40IW to work with existing libi40iw.

E810 device registration uses RDMA_DRIVER_IRDMA. libirdma uses
RDMA_DRIVER_IRDMA and really only associates with E810 devs.

When both user-space and driver i40iw are deprecated, we rename RDMA_DRIVER_I40IW
to RDMA_DRIVER_IRDMA and have just one id.

Alternate suggestions are welcome.

Some clarity on how a replacement driver should be submitted would be appreciated.
 
> Why are we getting a replacement driver instead of fixing the old one?

Our goal with this driver is to avoid code duplication and support current
and future HW.

Not sure what is there to fix in the old i40iw driver. The old driver was never
designed for a single driver model, multiple HW or protocols or even named appropriately.
(as this was not a requirement back then).
 
> 
> This is very long, I didn't read it super closely :(
> 
> Jason
