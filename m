From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 1/4] ib/core: handle EDR/FDR extended speeds
Date: Mon, 19 Sep 2011 14:14:13 -0600
Message-ID: <20110919201413.GB28454@obsidianresearch.com>
References: <201109191906.05360.marcela@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A8237316E64FDC@ORSMSX101.amr.corp.intel.com>
 <CAKzyTszd0LSOaY4RFCw2WpNBBQcgfkUYFSOy6q+rC1SjSb4q3A@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6508C@ORSMSX101.amr.corp.intel.com>
 <CAKzyTsxxuB=k+N+rxPmfx8zZZApDdr-_FfajDstDVa7M1nV8xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKzyTsxxuB=k+N+rxPmfx8zZZApDdr-_FfajDstDVa7M1nV8xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 19, 2011 at 02:26:13PM -0400, Hal Rosenstock wrote:
 
> Right.
> 
> > Why carry that same concept into a software interface? ??It seems complex.
> 
> So as not to break existing verbs apps by inventing new values to
> existing fields which wouldn't be understood.

Every app I've ever worked with that needs this information uses one
function to map the speed to whatever it needs, sprinkling the
information that function needs all over the place will only make it
harder to update the app.

If we are going to change the structure can we at least introduce
something sane, like a 'uint64_t link_rate_in_bps' so we don't have
this problem again?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
