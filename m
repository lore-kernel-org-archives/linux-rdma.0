From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/3] IB Netlink Interface and RDMA CM exports
Date: Thu, 18 Nov 2010 15:09:49 +0200
Message-ID: <1290085789.2258.1166.camel@nirm-desktop>
References: <4CE00A72.30001@voltaire.com>
	 <20101115031904.GA3566@obsidianresearch.com>
	 <1289836604.2258.1091.camel@nirm-desktop>
	 <20101116062602.GA488@obsidianresearch.com>
	 <1289923079.2258.1149.camel@nirm-desktop> <aday68riqhm.fsf@cisco.com>
	 <20101118071828.GA19281@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101118071828.GA19281-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-11-18 at 00:18 -0700, Jason Gunthorpe wrote:
> On Wed, Nov 17, 2010 at 01:34:29PM -0800, Roland Dreier wrote:
> 
> > In fact I'm not sure even for embedded it's worth making this something
> > that can be configured out.  We probably have too many config options
> > that no one ever uses as it is.  Are there any embedded systems that are
> > both so small that a few K of code matters and also use RDMA?
> 
> I experimented with re-tasking rxe to act as a soft-IB. The only
> reason to do this was to run IPOIB, and the system was very small. So
> in that instance I did benefit from running without may of the IB
> modules - but I would have been entirely happy with a CONFIG_XX
> controlled by CONFIG_EMBEDDED, since the system didn't use modules at
> all anyhow.
> 
So, in an attempt to arrive at a consensus:
1. ib_netlink will not be in a different module. Instead it will be a
part of ib_uverbs.
2. I will rework the message serialization in both sides to use nl
attributes and to be transported one record at a time.
3. For now, there will be no config option for ib_netlink.

Is that acceptable? Are there anymore issues to attend to?

Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
