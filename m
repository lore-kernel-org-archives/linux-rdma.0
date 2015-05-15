From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH RFC] Documentation/infiniband: Add docs for rdma-helpers
Date: Fri, 15 May 2015 10:12:45 +0200
Message-ID: <5555AA7D.7080503@profitbricks.com>
References: <1431523472-10888-1-git-send-email-yun.wang@profitbricks.com> <1431529914.2377.22.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431529914.2377.22.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 05/13/2015 05:11 PM, Doug Ledford wrote:
[snip]
>> +
>> +  For core layer, below helpers are used to check if a paticular capability
>> +  is supported by the port.
> 
> The following helpers are used to check the specific capabilities of a
> particular port before utilizing those capabilities.

Will be in next version :-)

> 
>> +
>> +    rdma_cap_ib_mad		- Infiniband Management Datagrams.
>> +    rdma_cap_ib_smi		- Infiniband Subnet Management Interface.
>> +    rdma_cap_ib_cm		- Infiniband Communication Manager.
> InfiniBand Connection Management

Me too used to think it's 'connection', while I found some docs explain
this as 'communication'... but anyway, 'connection' sounds
more close to what it did in kernel :-)

>> +    rdma_cap_iw_cm		- IWARP Communication Manager.
> iWARP Connection Management
>> +    rdma_cap_ib_sa		- Infiniband Subnet Administration.
>> +    rdma_cap_ib_mcast		- Infiniband Multicast.
> InfiniBand Multicast join/leave protocol
>> +    rdma_cap_read_multi_sge	- RDMA Read Multiple Scatter-Gather Entries.
> RDMA Read verb supports more than 1 sge in the work request

Will be in next version :-)

>> +    rdma_cap_af_ib		- Native Infiniband Address.
>> +    rdma_cap_eth_ah		- Ethernet Address Handler.
> Queue Pair is InfiniBand transport, but uses Ethernet address instead of
> native InfiniBand address (aka, this is a RoCE QP, and that means
> ethertype 0x8915 + GRH for RoCEv1 and IP/UDP to well known UDP port for
> RoCEv2)

Shall we put this long description into USAGE? Here maybe list
all the helpers to give some quick overview with a brief
description, what's your opinion?

>> +
>> +USAGE
>> +
>> +  if (rdma_cap_XX(device, i)) {
>> +	/* The port i of device support XX */
>> +	...
>> +  } else {
>> +	/* The port i of device don't support XX */
>> +	...
>> +  }
>> +
>> +  rdma_cap_ib_mad
>> +  ---------------
>> +    Management Datagrams (MAD) is the prototype of management packet
>> +    to be used by all the kinds of infiniband managers, use the helper
>> +    to verify the port before utilize related features.
> Management Datagrams (MAD) are a required part of the InfiniBand
> specification and are supported on all InfiniBand devices.  A slightly
> extended version are also supported on OPA interfaces.
> 
> I would drop all instances of "use the helper to verify..." as that's
> redundant.  This whole doc is about using the helpers to verify things.

Agree, will be dropped in next version.

And all the comments below make sense, will be merged ;-)

Regards,
Michael Wang

> 
>> +
>> +  rdma_cap_ib_smi
>> +  ---------------
>> +    Subnet Management Interface (SMI) will handle SMP packet from SM
>> +    in an infiniband fabric, use the helper to verify the port before
>> +    utilize related features.
>> +
>> +  rdma_cap_ib_cm
>> +  ---------------
>> +    Communication Manager (CM) will handle the connections between
>        ^Connection Manager (CM) service, used to ease the process of
> connecting to a remote host.  The IB CM can be used to connect to remote
> hosts using either InfiniBand or RoCE connections.  iWARP has its own
> connection manager, see below.
>> +    adaptors, currently there are two different implementation,
>> +    IB or IWARP, use the helper to verify whether the port using
>> +    IB-CM or not
>> +
>> +  rdma_cap_iw_cm
>> +  ---------------
>> +    IWARP has it's own implemented CM which is different from infiniband,
>       iWARP connection manager.  Similar to the IB Connection Manager,
> but only used on iWARP devices.
>> +    use the helper to check whether the port using IWARP-CM or not.
>> +
>> +  rdma_cap_ib_sa
>> +  ---------------
>> +    Subnet Administration (SA) is the database built by SM in an
>> +    infiniband fabric, use the helper to verify the port before
>> +    utilize related features.
>> +
>> +  rdma_cap_ib_mcast
>> +  ---------------
>> +    Multicast is the feature for one QP to send messages to multiple
>> +    QP in an infiniband fabric, use the helper to verify the port before
>> +    utilize related features.
> 
> InfiniBand (and OPA) use a different multicast mechanism than
> traditional IP multicast found on Ethernet devices.  If this capability
> is true, then traditional IPv4/IPv6 multicast is handled by the IPoIB
> layer and direct multicast joins and leaves are handled per the
> InfiniBand specifications.
> 
>> +
>> +  rdma_cap_read_multi_sge
>> +  ---------------
>> +    RDMA read operation could support multiple scatter-gather entries,
>> +    use the helper to verify wthether the port support this feature
>> +    or not.
> 
> Certain devices (iWARP in particular) have restrictions on the number of
> scatter gather elements that can be present in an RDMA READ work
> request.  This is true if the device does not have that restriction.
> 
>> +  rdma_cap_af_ib
>> +  ---------------
>> +    RDMA address format could be ethernet or infiniband, use the helper
>> +    to verify whether the port support infiniband format or not.
> 
> Many code paths for traditional InfiniBand and RoCE links are the same,
> but need minor differences to accommodate the different addresses on the
> two types of connections.  This helper is true when the address of the
> specific connection is of the InfiniBand native variety.
> 
>> +
>> +  rdma_cap_eth_ah
>> +  ---------------
>> +    Infiniband address handler format is special in ethernet fabric, use
>> +    the helper to verify whether the port is using ethernet format or not.
> 
> This helper is true when the address of the specific connection is of
> the Ethernet (RoCE) variety.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
