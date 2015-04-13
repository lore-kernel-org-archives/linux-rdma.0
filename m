From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Stepping down as maintainer (was Re: [PATCH for-next 0/9] mlx4
 changes in virtual GID management)
Date: Mon, 13 Apr 2015 11:53:30 -0600
Message-ID: <20150413175330.GC17521@obsidianresearch.com>
References: <CAG4TOxPQX+hBiEcaWD7DOAeLEmi9bWMeE06to+QyCdo3pAU+Yw@mail.gmail.com>
 <CAJ3xEMiky+s55zsqH0Vxpw8wmk3uGsx1wyMdNqsFihCaiBDgtw@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC07D4@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FC07D4-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 13, 2015 at 04:10:16PM +0000, Hefty, Sean wrote:
> > Unfortunately, Sean -- you haven't provided for > 2 months any
> > feedback on the patches to the CM/CMA modules which you own/maintain
> > for supporting name-spaces and such which are part of enabling proper
> > RDMA support for containers.
> > http://marc.info/?l=linux-netdev&m=142366747608908&w=2 This makes your
> > co-maintainer position sort of problematic, BTW. Jason, any chance you
> > can look on
> > that?
> 
> Linux does not pull anything from me directly.  My own patches to
> the code that I supposedly maintain take *years* to get upstream.  I
> fail to see how or why I need to review patches from a hostile
> party.

I expect the patch flow process will change..

We do actually need to all work together, so I urge you both to keep
talking and hash something out.

Or, I was also a bit annoyed by your last email, the tone just seemed
inappropriate/in-gracious for the situation.

As far as patches go, you keep asking for reviews, but where are the
reviews from Mellanox? I count 45 @mellanox folks who contributed to
the kernel, but I wouldn't have guessed that based on mailing
list participation.

I see patches from Yann, Michael, Ira, and Yuval at least on the list
that have seen general silence from your corner. That's just this last
month or so.

Look - the only way a subsystem can function properly is if all
parties who want to continuously change the shared subystem core
realise they have to contribute back review-hours and discussion
leadership *AT LEAST* equal to what they receive.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
