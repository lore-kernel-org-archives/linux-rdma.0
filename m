From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/3] IB Netlink Interface and RDMA CM exports
Date: Sun, 14 Nov 2010 20:19:04 -0700
Message-ID: <20101115031904.GA3566@obsidianresearch.com>
References: <4CE00A72.30001@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CE00A72.30001-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 14, 2010 at 06:12:34PM +0200, Nir Muchtar wrote:
> This patch set provides means for communicating internal data from IB modules
> to the userspace.It is composed of three components:

I would like to review this more closely when I am not at a trade
show, but thanks for getting this done! IMHO some netlink support can
make a big difference to the visibility of the IB stuff.

> 1. Main ib_netlink module which is independent of IB modules.(ib_netlink.ko).
> 2. "plug-in" modules per client IB module.(only ib_netlink_rdma_cm.ko for now).
>    Depends on (1) and (3). Their role is to keep (1) and (3) independent
>    as well as choosing callbacks to call, based on the requested op.
>    This doesn't actually happen in ib_netlink_rdma_cm.ko because at the moment,
>    only one callback is implemented.
> 3. additional callbacks which are implemented inside existing IB modules.
>    (only rdma_cm for now).
>    No additional dependencies, and existing flows stay untouched.

I'd really prefer that this not be seperate modules. I think it would
be good to stick the core stuff as part of ib_uverbs. Especially since
it doesn't look too big. For embedded you can have a
CONFIG_RDMA_NETLINK or something. (For embedded I think it would use
less memory to be able to forgo sysfs and use netlink entirely, someday.)

Ideally I think the netlink schema should build up from QPs and add on
IB CM, and IB RDMA CM information seperately as appropriate. Getting
info on non-CM QPs is very important as well, IMHO. Maybe the first
cut only reports the RDMA CM QPs but the schema should support
reporting everything. 

I'll comment on what you have specifically later, but just a quick
glance makes me wonder if you reviewed how the 'ss' program exchanges
very similar information over netlink for IP sockets when you designed
this??

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
