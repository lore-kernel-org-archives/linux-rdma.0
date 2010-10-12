From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC 0/2] IB/umad: Export mad snooping to userspace
Date: Tue, 12 Oct 2010 15:50:55 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA46E@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA11D@orsmsx501.amr.corp.intel.com>
 <20101012203528.GP24268@obsidianresearch.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA2A6@orsmsx501.amr.corp.intel.com>
 <20101012211052.GT24268@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101012211052.GT24268-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > TBH, I think this would be much better off integrating with the
> > > existing paths tcpdump/setc uses rather than yet again something new
> >
> > This ties in with the existing MAD interface, which isn't going away
> > anytime soon, if ever.
> 
> I didn't say the MAD interface was going away, I said it was not the
> interface everything else in the kernel uses for packet capture.

My focus is tying this functionality in with the existing IB stack.  The MAD, verbs, and HCA drivers do not use net_device, sk_buff, or anything in netdev, and I don't have the time or inclination to try to add it.  We have an interface that allows registration to receive MADs; this provides a simple extension of that interface.

I'm mainly interested in capturing MAD data, not all packets.  We don't have access to any of the headers, or even an easy way to know the destination for sent MADs.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
