From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/3] IB Netlink Interface and RDMA CM exports
Date: Thu, 18 Nov 2010 16:23:10 +0200
Message-ID: <4CE536CE.6010705@voltaire.com>
References: <4CE00A72.30001@voltaire.com>	<20101115031904.GA3566@obsidianresearch.com>	<1289836604.2258.1091.camel@nirm-desktop>	<20101116062602.GA488@obsidianresearch.com>	<1289923079.2258.1149.camel@nirm-desktop> <aday68riqhm.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aday68riqhm.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> I think we should probably put this in the core module rather than creating yet another module.  I don't really see what the advantage of separating netlink into its own module is.
If we're going on putting the netlink code in an existing module, 
ib_core would fit better, since there are occasions  where uverbs will 
not be loaded but still we'd like very much (...) to trace things such 
as rdma_cm connections made by kernel ULPs such as nfs-rdma, iser, rds 
and alike.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
