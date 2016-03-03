From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 3/9] IB/core: add a helper to check for READ WITH
 INVALIDATE support
Date: Thu, 3 Mar 2016 10:53:01 -0700
Message-ID: <20160303175301.GD15387@obsidianresearch.com>
References: <1456784410-20166-1-git-send-email-hch@lst.de>
 <1456784410-20166-4-git-send-email-hch@lst.de>
 <56D55ABA.6070007@dev.mellanox.co.il>
 <005f01d173d1$68309af0$3891d0d0$@opengridcomputing.com>
 <20160303131050.GA22022@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160303131050.GA22022@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@lst.de>
Cc: Steve Wise <swise@opengridcomputing.com>, 'Sagi Grimberg' <sagig@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 03, 2016 at 02:10:50PM +0100, 'Christoph Hellwig' wrote:
> On Tue, Mar 01, 2016 at 09:45:40AM -0600, Steve Wise wrote:
> > > > +static inline bool rdma_has_read_invalidate(struct ib_device *dev, u32 port_num)
> > > 
> > > Is rdma_device_sup_read_inv() a better name?
> > 
> > or rdma_dev_supports_read_inv()
> 
> I looked at the naming and I think a rdma_device_* or rdma_dev_* is
> simplify wrong - per the official decree we can support different
> protocols on different ports, and that's why we also pass the port_num
> to this function.  How about rdma_cap_read_inv?

We can't support different protocols on different ports. The ports
hung off a struct device must be similar. The rules might be bent a
bit for rocee/ib sharing (not a great idea, IMHO) but certainly iwap
and !iwarp cannot share a struct device.

Jason
