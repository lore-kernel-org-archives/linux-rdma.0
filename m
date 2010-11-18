From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/3] IB Netlink Interface and RDMA CM exports
Date: Thu, 18 Nov 2010 15:24:10 +0200
Message-ID: <1290086650.2258.1179.camel@nirm-desktop>
References: <4CE00A72.30001@voltaire.com>
	 <20101115031904.GA3566@obsidianresearch.com>
	 <1289836238.2258.1088.camel@nirm-desktop>  <adapqu3iq9i.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapqu3iq9i.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2010-11-17 at 13:39 -0800, Roland Dreier wrote:
> > Well, the main reason for the module separation is to allow
>  > extensibility and independence.
> 
> I don't understand how the physical location of object code has anything
> to do with extensibility and independence?  ie what is the relevance of
> what .ko file the netlink support code sits in?
> 
>  - R.
Using a different ib_netlink module is an easy way to keep other IB
modules independent of the linux netlink mecahinsm and allows for
runtime loading and unloading of the netlink interface seperately for
each possible IB module. (RDMA CM in the current patch set)

Anyway, I realize now that these qualities are not very desirable (by
anyone but me apparently...), so I'll rework the patch set.

Thanks,
Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
