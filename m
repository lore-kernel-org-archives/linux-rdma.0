From: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 3/9] IB/core: add a helper to check for READ WITH
	INVALIDATE support
Date: Thu, 3 Mar 2016 18:56:31 +0100
Message-ID: <20160303175631.GA28218@lst.de>
References: <1456784410-20166-1-git-send-email-hch@lst.de> <1456784410-20166-4-git-send-email-hch@lst.de> <56D55ABA.6070007@dev.mellanox.co.il> <005f01d173d1$68309af0$3891d0d0$@opengridcomputing.com> <20160303131050.GA22022@lst.de> <20160303175301.GD15387@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160303175301.GD15387-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 03, 2016 at 10:53:01AM -0700, Jason Gunthorpe wrote:
> > I looked at the naming and I think a rdma_device_* or rdma_dev_* is
> > simplify wrong - per the official decree we can support different
> > protocols on different ports, and that's why we also pass the port_num
> > to this function.  How about rdma_cap_read_inv?
> 
> We can't support different protocols on different ports. The ports
> hung off a struct device must be similar. The rules might be bent a
> bit for rocee/ib sharing (not a great idea, IMHO) but certainly iwap
> and !iwarp cannot share a struct device.

That's how I would like to see it.  But the way how all the cap checks
are done on a per port basis implies something different.

And for this series I'm not going to changes this.  In the long run
I'd be much happier if this nonsense of passing a port number to
the capability checks would go away.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
