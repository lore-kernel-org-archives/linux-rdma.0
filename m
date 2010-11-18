From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/3] IB Netlink Interface and RDMA CM exports
Date: Thu, 18 Nov 2010 09:13:22 -0700
Message-ID: <20101118161322.GB7419@obsidianresearch.com>
References: <4CE00A72.30001@voltaire.com> <20101115031904.GA3566@obsidianresearch.com> <1289836604.2258.1091.camel@nirm-desktop> <20101116062602.GA488@obsidianresearch.com> <1289923079.2258.1149.camel@nirm-desktop> <aday68riqhm.fsf@cisco.com> <4CE536CE.6010705@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CE536CE.6010705-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 18, 2010 at 04:23:10PM +0200, Or Gerlitz wrote:
> Roland Dreier wrote:
> >I think we should probably put this in the core module rather than 
> >creating yet another module.  I don't really see what the advantage of 
> >separating netlink into its own module is.

> If we're going on putting the netlink code in an existing module, 
> ib_core would fit better, since there are occasions  where uverbs will 
> not be loaded but still we'd like very much (...) to trace things such 
> as rdma_cm connections made by kernel ULPs such as nfs-rdma, iser, rds 
> and alike.

Nir's patch is really in two parts -
 1) The creation of NETLINK_INFINIBAND and associated dispatch of
    ops carried on the class
 2) The processing of IBNL_RDMA_CM_STATS op

The #1 should live in ib_core, but #2 should have parts in ib_verbs,
ib_uverbs, rdma_cm, and ib_cm, at least. To get a complete picure of
the QPs we will need information from all those places ..

What I would like to see is for ib_verbs to own the IBNL_RDMA_CM_STATS
op, to walk the QP list and call out to the other modules to add
appropriate netlink attributes.

Some other ops that would be great to see in future:
 - Report CQ status and information - enough to correlate with lsof
 - Report RDMA devices and the information we see in sysfs today
 - Report IPOIB path information through the usual IP netlink
 - netlink notifications for IB evens, like port up/down/etc

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
