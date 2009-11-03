From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] librdmacm/mckey: enforce local binding for unmapped	multicast
 addresses
Date: Tue, 03 Nov 2009 16:02:31 +0200
Message-ID: <4AF037F7.9080100@voltaire.com>
References: <Pine.LNX.4.64.0911011130140.6591@zuben.voltaire.com> <AB1AB5E171B44E1AA5FAFB87901C69C7@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AB1AB5E171B44E1AA5FAFB87901C69C7-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> Unmapped multicast groups only support the case where the SA has created the
> group with the MGID undefined.  The MGID must be in this format: 0xff1 scope 0xA01B (see figure 196 on page 928 of the spec).  The kernel checks for this specific address format to see if it needs to convert the address or not [...] wanted the ability to create a group a get back a unique group ID
I am still not sure to follow you. My basic thought was that unmapped 
multicast addresses are MGIDs specified by the application such that 
rdma-cm doesn't treat them as IPv6 multicast address and no mapping is 
applied on them. From the spec location you have pointed me I understand 
that the intention is for a request to the SA to generate a unique MGID:

1. "if SA receives a request to create a multicast group with the MGID 
undefined"
2.  "the MGID that it creates shall be of the following format"

so there are two parts here, 1st request the SA to create a new group, 
assign it an MGID (what about joining this node/port to the group), 2nd, 
getting back the MGID created by the SA. Looking on the rdma-cm kernel 
code, I don't see where/how it specifies to the SA  that the MGID is 
undefined? shouldn't it not set the MGID bit in the component mask in 
this case? next, I don't see where the MGID created by the SA is given 
back to the application. I guess still miss something here, can you 
clarify, thanks

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
