From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] IB Netlink Interface and RDMA CM exports
Date: Wed, 17 Nov 2010 13:34:29 -0800
Message-ID: <aday68riqhm.fsf@cisco.com>
References: <4CE00A72.30001@voltaire.com>
	<20101115031904.GA3566@obsidianresearch.com>
	<1289836604.2258.1091.camel@nirm-desktop>
	<20101116062602.GA488@obsidianresearch.com>
	<1289923079.2258.1149.camel@nirm-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289923079.2258.1149.camel@nirm-desktop> (Nir Muchtar's message
	of "Tue, 16 Nov 2010 17:57:59 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I was under the impression that a different module is appropriate here
 > based on the structure of the IB modules and similar modules like
 > netfilter_netlink, and other architectures in the kernel. However, I'm
 > naturally open to other views. If the other way around is the consensus
 > nowadays, and I'm in minority here, then certainly, things can be done
 > the other way. I'd be happy to hear other views to concur/reject my
 > view.

I think we should probably put this in the core module rather than
creating yet another module.  I don't really see what the advantage of
separating netlink into its own module is.

We probably over-modularized the RDMA stack early on, it might in fact
make sense to collapse things down from where they are now.

In fact I'm not sure even for embedded it's worth making this something
that can be configured out.  We probably have too many config options
that no one ever uses as it is.  Are there any embedded systems that are
both so small that a few K of code matters and also use RDMA?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
