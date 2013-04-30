From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 for-next 1/5] IB/core: Add RSS and TSS QP groups -
 suggesting BOF during OFA conf to further discuss that
Date: Tue, 30 Apr 2013 10:28:41 -0600
Message-ID: <20130430162841.GA29903@obsidianresearch.com>
References: <CAJZOPZL1eminwg+MVAC+8y4Pg3Nff=aeMN9ic57SB3cRAg8Hnw@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A823736FD1E64F@ORSMSX109.amr.corp.intel.com>
 <20130425201255.GB31863@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A823736FD1EF16@ORSMSX109.amr.corp.intel.com>
 <20130425204357.GD31863@obsidianresearch.com>
 <CAJZOPZK8hcfm2OCnsJkhCiRNxOFXOB0xc9i7tmB4qEnkXrXC0Q@mail.gmail.com>
 <20130425214058.GF31863@obsidianresearch.com>
 <CAJZOPZLMtoxYyQO24F5_2Gr7ye0AFPQ5aZHp4dZFu1LQFK_cYg@mail.gmail.com>
 <20130429203653.GA25804@obsidianresearch.com>
 <517F8919.8060108@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <517F8919.8060108-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 30, 2013 at 12:04:25PM +0300, Shlomo Pongratz wrote:

> >And.. 'tss_qpn_mask_sz' seems unnecessarily limiting, using
> >  WC.srcQPN + ipoib_header.tss_qpn_offset == real QPN
> >  (ie use a signed offset, not a mask)
> >Seems much better than
> >  Wc.srcQPN & ~((1<<(ipoib_header.tss_qpn_mask_sz >> 12))-1) == real QPN
> >  (Did I even get that right?)

> Your suggestion could have been valid if the the IPoIB header was larger.
> Please note that the a QPN occupies 3 octets and thus its value lies
> in the range of [0..0xFFFFFF].

I am aware of this, and it isn't really a problem, adaptors that
allocate randomly across the entire QPN space would not be compatible
with this approach, but most adaptors allocate QPNs
quasi-contiguously.

Basically, at startup, IPoIB would allocate a TX QP, then allocate TSS
QPs, and throw away any that can't fit in the encoding, until it
reaches the target number or tries too long. No need for a special API
to the driver.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
