From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Tue, 10 May 2016 11:18:19 -0600
Message-ID: <20160510171819.GB2879@obsidianresearch.com>
References: <20160504181135.GA15355@obsidianresearch.com>
 <21d9307f-766e-9aaa-54d3-207a4a4d5d8c@mellanox.com>
 <20160505181423.GB5957@obsidianresearch.com>
 <alpine.DEB.2.20.1605052116570.1091@east.gentwo.org>
 <20160506225523.GA21309@obsidianresearch.com>
 <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org>
 <20160509163537.GA15479@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04A390@ORSMSX109.amr.corp.intel.com>
 <20160509200507.GA23911@obsidianresearch.com>
 <20160510045801.GV29160@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160510045801.GV29160-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 10, 2016 at 07:58:01AM +0300, Leon Romanovsky wrote:
> > The Collab Summit discussions ended with a general consensus that some
> > things would go to the driver-specific channel, while hardware
> > behavior related to the common uAPI would go through at least a
> > multi-vendor sign off process - like IBTA.
> 
> We did ALL and much more from the discussed for RSS patches and at the end,
> we saw half a word from the maintainer about the future plans for its acceptance.

Where is the 'multi-vendor sign off' part of the process?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
