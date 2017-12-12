From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] Support writing man pages in MarkDown
Date: Tue, 12 Dec 2017 16:27:21 -0700
Message-ID: <20171212232721.GN16588@mellanox.com>
References: <20171212225936.GA29558@ziepe.ca>
 <1828884A29C6694DAF28B7E6B8A82373AB1C234C@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1C234C-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 12, 2017 at 11:11:15PM +0000, Hefty, Sean wrote:
> > Since this may be a problem, I am thinking about following the
> > libfabric approach and either including the precompiled man pages in
> > the source tree, or just providing a framework for downstream to add-
> > on precompiled files (with a cbuild command to make them) Looking for
> > feedback on what path is best..
> 
> FWIW, one of the reasons libfabric went with pre-compiled man pages
> was to include a date for the last edit.  A service automatically
> updates the date when updating the page.

This isn't going to be so useful here since all the markdown pages
were created today..

What I did was to copy the date from the original man page over to the
markdown header:

date: 2015-01-29

So the date visible in the man page doesn't change from what it was
before (which in turn is a kind of meaningless value these days since
we never bothered to keep it up to date in most cases)

Other projects don't bother with the date, for instance systemd just
drops in in the package version number in that space, which actually
seems more usefull to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
