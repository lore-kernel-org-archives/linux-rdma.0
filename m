From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: New providers in rdma-core
Date: Wed, 19 Oct 2016 10:28:36 -0700
Message-ID: <6b57d79c-dbd3-cd9b-061e-27a3d3968845@vmware.com>
References: <CALq1K=+nEP0jFOCxj30HA0+bg0L1bF5+xiBcAC2bRwUz+M6+eQ@mail.gmail.com>
 <20161019163913.GA30843@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161019163913.GA30843-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon/Christoph,

On Wed, Oct 19, 2016 at 09:39:13AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 19, 2016 at 07:18:04PM +0300, Leon Romanovsky wrote:
> > Hi All,
> > 
> > I want to remind you that latest kernel is exposing different vendor
> > specific structures (include/uapi/rdma/*-abi.,h) and new coming user
> > space drivers should use these headers directly and not copy/paste the
> > code from them.
> > 
> > In the future, we will convert already accepted drivers too.
> 
> Requiring installed super updtodate kernel headers isn't going to
> help development.  It would be good to keep a copy of the kernel
> headers in the rdma-core repo, similar to what most kernel tools
> tied to bleeding edge ABIs do.

Thanks for the heads up. I had a few questions regarding the ABI stuff.
What happens in case of providers that arent part of the kernel as yet?
I would like to send out a pull request soonish for libpvrdma. I would 
need to include the abi files in that request since cmake would fail.
Or do you want me to wait till Doug adds the PVRDMA driver to the tree?

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
