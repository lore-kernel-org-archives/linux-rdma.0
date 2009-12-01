From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Tue, 1 Dec 2009 16:28:23 +0200
Message-ID: <20091201142823.GA17213@mtls03>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>
 <20091125001136.GP6188@obsidianresearch.com>
 <20091130133406.GA32123@mtls03>
 <5A90523D-56AE-4675-AA39-B6876FB32999@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5A90523D-56AE-4675-AA39-B6876FB32999-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 30, 2009 at 09:03:47AM -0500, Jeff Squyres wrote:
> Per my prior question: is it expected that IBoE will function
> *exactly* the same as real IB?  The addition of the port attribute
> seems to imply not.

IBoE and IB should work exactly the same from the perspective of a
user level application that makes use of rdmacm to create connections.
Such apps can ignore the new attribute. And we believe this should
cover the vast majority of apps.  The new port attribute optionally
allows the distinction for apps that need it (e.g. those that do not
use the rdmacm, apps that have a reason to prefer one over the other
when there is a choice, etc).

> 
> Additionally, per Jason's question, why not simply expose this as an
> additional device?  E.g., can you APM across a real IB port and an
> IBoE port on the same CX2?  I'm guessing that they're *effectively*
> different devices; it might make sense expose them as different
> virtual device_t's.  Just my $0.02.

Yes. It should be possible to do APM across them. And with the ABI
compatible link-protocol attribute we see no reason to force the
isolation.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
