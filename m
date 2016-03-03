From: 'Christoph Hellwig' <hch@lst.de>
Subject: Re: [PATCH 3/9] IB/core: add a helper to check for READ WITH
	INVALIDATE support
Date: Thu, 3 Mar 2016 14:10:50 +0100
Message-ID: <20160303131050.GA22022@lst.de>
References: <1456784410-20166-1-git-send-email-hch@lst.de> <1456784410-20166-4-git-send-email-hch@lst.de> <56D55ABA.6070007@dev.mellanox.co.il> <005f01d173d1$68309af0$3891d0d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <005f01d173d1$68309af0$3891d0d0$@opengridcomputing.com>
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'Sagi Grimberg' <sagig@dev.mellanox.co.il>, 'Christoph Hellwig' <hch@lst.de>, linux-rdma@vger.kernel.org, sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 01, 2016 at 09:45:40AM -0600, Steve Wise wrote:
> > > +static inline bool rdma_has_read_invalidate(struct ib_device *dev, u32 port_num)
> > 
> > Is rdma_device_sup_read_inv() a better name?
> 
> or rdma_dev_supports_read_inv()

I looked at the naming and I think a rdma_device_* or rdma_dev_* is
simplify wrong - per the official decree we can support different
protocols on different ports, and that's why we also pass the port_num
to this function.  How about rdma_cap_read_inv?
