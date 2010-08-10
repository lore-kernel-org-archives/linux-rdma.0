From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rdma cm + XRC
Date: Tue, 10 Aug 2010 16:54:35 -0600
Message-ID: <20100810225435.GA2999@obsidianresearch.com>
References: <4C5331DC.9080109@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954BA1C@orsmsx501.amr.corp.intel.com> <4C618334.7010106@systemfabricworks.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954C0C2@orsmsx501.amr.corp.intel.com> <20100810171405.GM11306@obsidianresearch.com> <4C61BF26.9060003@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C61BF26.9060003-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 10, 2010 at 04:05:42PM -0500, frank zago wrote:

> It seems the new API has too many constraints for XRC. There are a
> couple things that don't fit:

I'll try to take a more careful look at this later, but just want to
say that the new APIs are so new that we could still change them - not
supporting XRC seems like a API design failing that might haunt us
later?

Keep in mind that rdma_getaddrinfo is the scheme to be used for CM
address resolution scalability, so it seems natural that anyone using
RDMA CM and XRC would want to use both together.

> - XRC needs a domain, which must be created before creating the QP,
> but after we know the device to use. In addition it also needs a
> file descriptor. The application may want to use a different fd
> depending on the device. Currently the domain can only be created in
> the middle of rdma_create_ep().

Well.. the XRC domain needs to be an input to create_ep just like
the PD :(

In looking at how this API turned out maybe the PD should have been
carried in the rdma_addrinfo? Certainly I would put the XRC domain
in there.. Recall my original comments about the PD being used to
restrict device selection in rdma_getaddrinfo.

Not sure what the FD is about (been awhile since the libibverbs XRC
patches were posted)?

> - The server side of the connection also needs an SRQ. It's not
> obvious whether it's the application or rdma cm to create that
> SRQ. And that SRQ number must be given to the client side,
> presumably in the private data.

All rdma_create_ep could do is setup the XRC INI QP and XRC TGT QP,
the XRC SRQ is associated with the XRC domain so it has to be managed
by the app.

The private data is passed into rdma_connect, after create_ep, so
there seems to be no problem there, the app can format up the SRQ
number according to the CM private data protocol it is using..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
