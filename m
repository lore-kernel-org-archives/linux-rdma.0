From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH v3 07/28] IB/Verbs: Reform IB-ulp ipoib
Date: Mon, 13 Apr 2015 15:46:03 -0400
Message-ID: <20150413194602.GA21467@phlsvsds.ph.intel.com>
References: <552BB470.4090407@profitbricks.com> <552BB5AC.6050101@profitbricks.com> <20150413192701.GA19112@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150413192701.GA19112@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Michael Wang <yun.wang@profitbricks.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 13, 2015 at 01:27:01PM -0600, Jason Gunthorpe wrote:
> On Mon, Apr 13, 2015 at 02:25:16PM +0200, Michael Wang wrote:
> >  	dev_list = kmalloc(sizeof *dev_list, GFP_KERNEL);
> >  	if (!dev_list)
> > @@ -1673,13 +1671,19 @@ static void ipoib_add_one(struct ib_device *device)
> >  	}
> >  
> >  	for (p = s; p <= e; ++p) {
> > -		if (rdma_port_get_link_layer(device, p) != IB_LINK_LAYER_INFINIBAND)
> > +		if (!rdma_tech_ib(device, p))
> >  			continue;
> >  		dev = ipoib_add_port("ib%d", device, p);
> >  		if (!IS_ERR(dev)) {
> >  			priv = netdev_priv(dev);
> >  			list_add_tail(&priv->list, dev_list);
> >  		}
> > +		count++;
> > +	}
> > +
> > +	if (!count) {
> > +		kfree(dev_list);
> > +		return;
> >  	}
> 
> This doesn't quite look right, it should be 'goto error1'

Looks like you replied to the wrong patch.  ??  I don't see error1 in ipoib_add_one.

For the ib_cm module...

Yes I think it should go to "error1".  However, see below...

This is the type of clean up error which would be avoided if a call to
cap_ib_cm_dev() were done at the top of the function.

> 
> But then I read 'goto error1' and it doesn't look like it can handle
> cm_dev->port being NULL, so more fixing is needed.

I think this is highlighting an existing dependency which we don't want but
exists.

It appears the code currently does not support this situation.

Dev
	port 1 : cap_is_cm == true
	port 2 : cap_is_cm == false
	port 3 : cap_is_cm == true

Because the error handling bails when port 2 fails...  Leaving both port 1 and
port 3 uninitialized.  :-(

Ira

> 
> Ditto for cm_remove_one
> 
> Should audit all uses of cm_dev->port[] to make sure they can all
> handle NULL.
> 
> Jason
