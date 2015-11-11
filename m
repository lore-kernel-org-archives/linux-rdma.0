From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/core: Expose a device attribute for rdma_read
 access flags
Date: Wed, 11 Nov 2015 02:25:10 -0800
Message-ID: <20151111102510.GA25218@infradead.org>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-2-git-send-email-sagig@mellanox.com>
 <1447156270.7089.3.camel@opteya.com>
 <5641E4C9.7000206@talpey.com>
 <5641E644.7080101@mellanox.com>
 <20151110130648.GA10682@infradead.org>
 <20151110134147.GA12814@infradead.org>
 <56430542.5090008@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56430542.5090008-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2015 at 11:07:14AM +0200, Sagi Grimberg wrote:
> 
> 
> On 10/11/2015 15:41, Christoph Hellwig wrote:
> >FYI, this is the API I'd aim for (only SRP and no HW driver converted
> >yet):
> 
> This looks fine, although personally I find scope and direction flags
> more confusing than access_flags (but maybe it's just me).

Looking at the drivers the current flags seem to confuse programmes
hard, given that the choises seem to be random values that just happen
to work:

rkeys:
iser:		lwrite | rwrite | rread
srp:		lwrite | rwrite | rread
rds:		lwrite | rread | rwrite
rds:		rwrite
xprdtrdma (wr):	rwrite | lwrite
xprdtrdma (rd):	rread

lkeys:
isert:		lwrite
svcrdma:	lwrite | rwrite

moving to a model where the consumer clearly says what they intend
to do with the MR seem much better than that.

> I think that the real issue here is the server/target side which needs
> extra logic for rdma_read and memory registration. If we can put this
> logic in the core and give ULPs an API that looks something like:
> - ib_rdma_read()
> - ib_rdma_write()
> 
> then maybe we don't need to change our flags?

The current flags don't make any sense for someone trying to use
the API.  They're pointless leakage of badly designed protocol specs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
