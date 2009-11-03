From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm/mckey: enforce local binding for unmapped	multicast addresses
Date: Tue, 3 Nov 2009 08:43:01 -0800
Message-ID: <72E827020C9E497DB3CAA3DD720E9604@amr.corp.intel.com>
References: <Pine.LNX.4.64.0911011130140.6591@zuben.voltaire.com> <AB1AB5E171B44E1AA5FAFB87901C69C7@amr.corp.intel.com> <4AF037F7.9080100@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF037F7.9080100-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I am still not sure to follow you. My basic thought was that unmapped
>multicast addresses are MGIDs specified by the application such that
>rdma-cm doesn't treat them as IPv6 multicast address and no mapping is
>applied on them. 

This is basically correct, but the MGIDs must be of the format 0xFF1-scope-A01B.
The kernel keys off this in the address to determine if the mapping should be
made.

>1. "if SA receives a request to create a multicast group with the MGID
>undefined"
>2.  "the MGID that it creates shall be of the following format"
>
>so there are two parts here, 1st request the SA to create a new group,
>assign it an MGID (what about joining this node/port to the group), 2nd,
>getting back the MGID created by the SA. Looking on the rdma-cm kernel
>code, I don't see where/how it specifies to the SA  that the MGID is
>undefined? shouldn't it not set the MGID bit in the component mask in
>this case? next, I don't see where the MGID created by the SA is given

>From 15.2.5.17.2:

"MGID undefined" means either the MGID bit in the component mask is not set, or
if the MGID bit in the component mask is set, the MGID component of
MCMemberRecord:MGID is 0.

If the join request is for an address of 0, then the MGID will be 0 in the SA
join request.  The SA will assign an MGID starting with 0xFF1-scope-A01B.  When
the join request completes, the MCMemberRecord information is given to the user
as part of the multicast join event in the form of address handle attributes.
(See cma_ib_mc_handler.)

What's missing is Jason's patch to fix the IPv6 mapping, and a way to extend the
rdma_cm to support the full range of unmapped addresses.  I just haven't been
able to get to either of these yet.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
