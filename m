From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH 3/9] IB/core: add a helper to check for READ WITH	INVALIDATE support
Date: Thu, 3 Mar 2016 09:31:51 -0600
Message-ID: <00b601d17561$cef73500$6ce59f00$@opengridcomputing.com>
References: <1456784410-20166-1-git-send-email-hch@lst.de> <1456784410-20166-4-git-send-email-hch@lst.de> <56D55ABA.6070007@dev.mellanox.co.il> <005f01d173d1$68309af0$3891d0d0$@opengridcomputing.com> <20160303131050.GA22022@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160303131050.GA22022@lst.de>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@lst.de>
Cc: 'Sagi Grimberg' <sagig@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> 
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

Given rdma_cap_ is used a lot already, I say that sounds good.
