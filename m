From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/5] travis: Test Debian packaging under Artful
 container
Date: Thu, 2 Nov 2017 11:55:22 -0600
Message-ID: <20171102175522.GR18874@ziepe.ca>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-6-leon@kernel.org>
 <20171102170554.GO18874@ziepe.ca>
 <20171102173255.GC16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102173255.GC16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 02, 2017 at 07:32:55PM +0200, Leon Romanovsky wrote:
> On Thu, Nov 02, 2017 at 11:05:54AM -0600, Jason Gunthorpe wrote:
> > On Thu, Nov 02, 2017 at 06:55:56PM +0200, Leon Romanovsky wrote:
> > > From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > This will be compiled with GCC 7 coming with Ubuntu Artful
> >
> > Hurm. This point of this is to test the latest gcc, not just the GCC
> > in a distro.
> >
> > We should be testing gcc-8 here, but it isn't available for
> > trusty right now. :(
> >
> > Then the lines:
> >
> >       - ubuntu-toolchain-r-test
> >
> > and
> >
> >       - gcc-7
> >
> > Should be removed from the .travis.yml as well in this patch.
> 
> lib32gcc-7-dev depends on gcc-7 and it depends on
> ubuntu-toolchain-r-test.

We can probably use the 32 bit packages that come with trusty..

Arguably though it might be better to test with 32 bit gcc-latest..

Even better would be to do 32 bit test under docker where we could make
32 bit cross work 100% ..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
