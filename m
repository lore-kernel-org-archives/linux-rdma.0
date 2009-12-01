From: Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Tue, 1 Dec 2009 15:00:46 -0600 (CST)
Message-ID: <alpine.DEB.2.00.0912011459540.10926@router.home>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com> <20091125001136.GP6188@obsidianresearch.com> <20091130133406.GA32123@mtls03> <5A90523D-56AE-4675-AA39-B6876FB32999@cisco.com> <20091201142823.GA17213@mtls03>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091201142823.GA17213@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 1 Dec 2009, Eli Cohen wrote:

> On Mon, Nov 30, 2009 at 09:03:47AM -0500, Jeff Squyres wrote:
> > Per my prior question: is it expected that IBoE will function
> > *exactly* the same as real IB?  The addition of the port attribute
> > seems to imply not.
>
> IBoE and IB should work exactly the same from the perspective of a
> user level application that makes use of rdmacm to create connections.
> Such apps can ignore the new attribute. And we believe this should
> cover the vast majority of apps.  The new port attribute optionally
> allows the distinction for apps that need it (e.g. those that do not
> use the rdmacm, apps that have a reason to prefer one over the other
> when there is a choice, etc).

rdmacm only? I would expect syscall API compatibility? For our use case
this needs to work with multicast traffic.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
