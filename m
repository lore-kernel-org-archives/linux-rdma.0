From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] IB Netlink Interface and RDMA CM exports
Date: Thu, 18 Nov 2010 12:44:56 -0800
Message-ID: <ada62vuicon.fsf@cisco.com>
References: <4CE00A72.30001@voltaire.com>
	<20101115031904.GA3566@obsidianresearch.com>
	<1289836604.2258.1091.camel@nirm-desktop>
	<20101116062602.GA488@obsidianresearch.com>
	<1289923079.2258.1149.camel@nirm-desktop> <aday68riqhm.fsf@cisco.com>
	<20101118071828.GA19281@obsidianresearch.com>
	<1290085789.2258.1166.camel@nirm-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290085789.2258.1166.camel@nirm-desktop> (Nir Muchtar's message
	of "Thu, 18 Nov 2010 15:09:49 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > 1. ib_netlink will not be in a different module. Instead it will be a
 > part of ib_uverbs.

Not sure what Jason thinks, but I would say ib_core -- we would want to
use this independent of user verbs.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
