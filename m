From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] librdmacm: Add support for extended join multicast
 API V2
Date: Fri, 17 Nov 2017 15:22:24 -0700
Message-ID: <20171117222224.GR4276@ziepe.ca>
References: <20171114185720.609975150@linux.com>
 <20171114185739.838757957@linux.com>
 <20171114192558.GL4263@ziepe.ca>
 <alpine.DEB.2.20.1711141349370.13532@nuc-kabylake>
 <20171114195659.GP4263@ziepe.ca>
 <alpine.DEB.2.20.1711150921450.19575@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1711150921450.19575@nuc-kabylake>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 15, 2017 at 09:22:14AM -0600, Christopher Lameter wrote:
> On Tue, 14 Nov 2017, Jason Gunthorpe wrote:
> 
> > > Index: rdma-core/debian/librdmacm1.symbols
> > > ===================================================================
> > > +++ rdma-core/debian/librdmacm1.symbols
> > > @@ -31,7 +31,7 @@ librdmacm.so.1 librdmacm1 #MINVER#
> > >   rdma_get_src_port@RDMACM_1.0 1.0.19
> > >   rdma_getaddrinfo@RDMACM_1.0 1.0.15
> > >   rdma_join_multicast@RDMACM_1.0 1.0.15
> > > - rdma_join_multicast_ex@RDMACM_1.1 1.0.15
> > > + rdma_join_multicast_ex@RDMACM_1.1 1.0.16
> >
> > No, just '16', not '1.0.16'

I fixed eveything and put the series into a PR:

https://github.com/linux-rdma/rdma-core/pull/254

Please check it and let me know.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
