From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/3] IB Netlink Interface and RDMA CM exports
Date: Mon, 15 Nov 2010 17:56:44 +0200
Message-ID: <1289836604.2258.1091.camel@nirm-desktop>
References: <4CE00A72.30001@voltaire.com>
	 <20101115031904.GA3566@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101115031904.GA3566-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> I'd really prefer that this not be seperate modules. I think it would
> be good to stick the core stuff as part of ib_uverbs. Especially since
> it doesn't look too big. For embedded you can have a
> CONFIG_RDMA_NETLINK or something. (For embedded I think it would use
> less memory to be able to forgo sysfs and use netlink entirely, someday.)
> 
Well, the main reason for the module separation is to allow
extensibility and independence.
Code separation is just a bonus. I like the idea of having the runtime
option to use this interface (or not).
A part of the patch is CONFIG_IB_NETLINK, which compiles all of the new
modules. 
What I wanted to achieve is an IB independent infrastructure that can be
used 
in parts. I.e a plugin for every module (the first example is rdma_cm).
This way only the modules of interest are joined to the infrastructure. 
The necessity of this flexibility can be examined of course.
> Ideally I think the netlink schema should build up from QPs and add on
> IB CM, and IB RDMA CM information seperately as appropriate. Getting
> info on non-CM QPs is very important as well, IMHO. Maybe the first
> cut only reports the RDMA CM QPs but the schema should support
> reporting everything. 
> 
I agree. That's one of the main goals.
For example, I have plans for adding ipoib exports as well as other
ideas.
> I'll comment on what you have specifically later, but just a quick
> glance makes me wonder if you reviewed how the 'ss' program exchanges
> very similar information over netlink for IP sockets when you designed
> this??
> 
> Jason
Yes I have actually. Some ideas are from NETLINK_INET_DIAG which is the
back-end for ss.
There are a few differences here that made the result different. 
I'd say this is a mix between NETLINK_INET_DIAG and NETLINK_NETFILTER.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
