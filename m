From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 00/15 ibacm] ACM Cache Preloading (and some cosmetic cleanups)
Date: Fri, 28 Jun 2013 11:18:26 -0400
Message-ID: <51CDA942.9070505@dev.mellanox.co.il>
References: <51C43267.1030301@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A823736FD375AE@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD375AE-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/28/2013 3:45 AM, Hefty, Sean wrote:
> I've pulled in this series, with the changes mentioned in a separate email, plus updates to the patches below (mostly renames of functions, variables, enums, etc.).  The updated patches are available from my ibacm.git tree in the preload branch.

Thanks for getting this done so quickly!

> Please look over those changes and see if you agree with them.  

I looked them over and retested this. I have a few minor fixups to
follow shortly.

> They should be as listed below:
> 
>> Patches 1-9 clean up documentation and sample config files.
> 
> Removed sample config files from the source tree.
> 
>> Patch 10 adds the ability to preload the GID and LID destination caches.
> 
> I modified the variable names and enums used for preloading, with other naming changes.
> 
> route_preload - is now used to indicate if the routing data should be preloaded and the format to be used.
> route_data_file - stores the file name containing the routing data.  The default name is ibacm_route.data
> 
> The code to parse the file should be mostly unchanged.

I didn't notice any parsing changes but might have glanced over this.

>> Patch 11 updates the ACM documentation for this.
>> Patch 12 fixes the inet_pton buffer space.
>> Patch 13 fixes IPv6 support in acme.
> 
> Relocated some common functionality into a static function and used sockaddr_storage to store the resulting addresses.
> 
>> Patch 14 adds the ability to preload the IPv4 and IPv6 destination caches.
> 
> Name changes similar to those done for patch 10.
> 
> addr_preload - indicates if the address data should be preloaded and the format to use
> addr_data_file - stores the file name containing the address data.  The default name is ibacm_addr.data.

Nit: Default is ibacm_hosts.data rather than ibacm_addr.data.

The one thing I noticed is that the check for using this (address)
preload option without the previous (route) preload option was
eliminated. This is probably the case in the long run but it is not the
case with these current options. Should it be added back in ?

>> Patch 15 adds a performance testing option to acme.
> 
> Overall, the changes look good.  I just needed to figure out what to call everything and tried to keep things consistent.  My preload branch has been compile tested, but I have not yet run it.
> 
> I only noticed one gap in the implementation, which I commented on directly in the code. 
> The changes require that the routing data be loaded first before the address data.  This is 
> the opposite of what occurs for normal operation, where the address is resolved before the route.

Understood. To restate this, it stems from address preload being host/IP
to IB GID and route preload being GID and LID to PR so the later is
needed first to populate the former (to PRs).

> It would be nice if the address and routing preload data were more independent, but that can be 
> added later, maybe, someday.

Agreed. I'll keep this in mind in terms of future changes.

-- Hal

> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
