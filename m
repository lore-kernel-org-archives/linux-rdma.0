From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rdma cm + XRC
Date: Tue, 10 Aug 2010 17:23:39 -0600
Message-ID: <20100810232339.GO11306@obsidianresearch.com>
References: <4C5331DC.9080109@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com> <4C618334.7010106@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com> <20100810171405.GM11306@obsidianresearch.com> <4C61BF26.9060003@systemfabricworks.com> <20100810225435.GA2999@obsidianresearch.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A960131B@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A960131B-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 10, 2010 at 04:18:57PM -0700, Hefty, Sean wrote:
> > Well.. the XRC domain needs to be an input to create_ep just like
> > the PD :(
> > 
> > In looking at how this API turned out maybe the PD should have been
> > carried in the rdma_addrinfo? Certainly I would put the XRC domain
> > in there.. Recall my original comments about the PD being used to
> > restrict device selection in rdma_getaddrinfo.
> 
> Personally, if I had it to do over, I don't know that I would have
> exposed the PD through the librdmacm at all.  Does anyone ever
> allocate more than one per device?

That isn't a half bad idea I guess, and if it was in rdma_addinfo it
could be 0 = use global PD/XRC and 99% of apps can just do that..

Maybe you should just go ahead and do that? It would not be hard to
do so and even keep ABI (but not API) compatability. Now would be the
time :)

> I feel similarly about the XRC domain.  Is there any real reason to
> expose it?  What if we just defined a 1:1 relationship between PDs
> and XRC domains, or between XRC domains and XRC TGT QPs?

Near as I can tell it serves the same purpose as the PD, to provide
a form of security within a single process..

I could imagine things like storage apps wanting to use them -
MR's/etc need to be carefully compartmentalized if you do not entirely
trust your peer.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
