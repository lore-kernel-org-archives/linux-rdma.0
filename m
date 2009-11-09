From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: QoS in local SA entity
Date: Mon, 9 Nov 2009 10:38:52 -0800
Message-ID: <5C9CD47F123648F0A926E151BF775484@amr.corp.intel.com>
References: <4AF2C00A.4040808@voltaire.com> <9BF1CEFA7F6F44F5B5641065C4914EB5@amr.corp.intel.com> <4AF66473.2050303@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF66473.2050303-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>L1. compute source address
>L2. issue kernel rdma_bind to source address and resolve <device, port,
>pkey>
>L3. issue ACM address (DGID) resolution call using (<device, port,
>pkey>, dest-ip)
>
>makes sense? if yes, what's the need in the address configuration file?

Here is where we're at today:

rdma_resolve_addr:
	- Source sends a multicast request to destination IP
	- Destination performs a path record query
	- Destination sends a response with IP to DGID mapping

rdma_resolve_route:
	- Source performs a path record query

The current implementation of ACM converts this to:
	** Source sends a multicast request to destination IP
	** Destination sends a response with IP to DGID mapping
	- Path record is constructed from multicast group information	

ACM needs to know what the local addresses are, so it can respond to requests
for those addresses.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
