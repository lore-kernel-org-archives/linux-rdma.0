From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
Date: Wed, 8 Feb 2017 18:02:44 +0200
Message-ID: <CAAKD3BDbkFHbCi+gHyCXCGV2xi5E9FA+KgwKz+6dBJEtsV0ZkQ@mail.gmail.com>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
 <20170130195412.GE24466@obsidianresearch.com> <VI1PR0502MB30081EBFBEE5994B77D58BB9D14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130211420.GB27111@obsidianresearch.com> <VI1PR0502MB30081EC9B35269636B4C2FBCD14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130221437.GA28117@obsidianresearch.com> <VI1PR0502MB3008B16A0F103D729209EA16D14A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170131005340.GA30809@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170131005340.GA30809-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> > That sounds broken, there should never be walking of device or anything silly
>> > like that to determine the ingress netdev. The only place that is done is when
>> > constructing the GID cache.
>>
>> GID table can have two gid entries with same GID content in there,
>> but gid_attr->net can be different.
>
> A incoming packet *cannot* match two GID table entries - that is by
> definition.
>
> Yes, two table entries can have the same GID.
>
> However, it is invalid to search the GID table by GID alone for
> rocee. The GID table can only be searched with the full network
> headers. For instance (DMAC,VLAN_ID,ROCE Version,GRH.DGID,etc).
>
> This is what the hardware should be doing when it decides if it will
> accept a packet or not. Packets that do not match GID table entries
> should not be received. Each UD QP should have a list of GID table
> entries it will accept packets for. (this addition is necessary for
> namespaces)
>
> In IB the matching GID table entry is placed in wc.sgid_index.
>
> I argued that rocee should do the same, but since mlx didn't implement
> this in hardware they didn't want to take the performance cost when
> building the WC.
>
> So, you have to reconstruct the wc.sgid_index that the hardware used
> in software - and this will always match a single GID table entry.
>
> Since GID table entries are associated with a single netdev, this
> gives you everything needed to process at ingress.
>
>> Without considering net_ns, GID cache query is equally broken.
>
> Again, you must never, ever, search the GID table with only a GID or
> IP address. That is always wrong for rocee..
>

Actually, I think one of the problems here is that we insert GIDs
which aren't supported by the hardware.
For example, if we can't supply VNI, why would we add such a GID entry?
The hardware won't be able to strip/build such a header anyway.

So, assuming we only insert a combination of netdevices which could be actually
described by the hardware, we could try to match these attributes in
the gid cache table.
Once we have such a match, we could verify that with the ingress route
(actually, we could use
ingress route starting from get_netdev() as well).

Since RoCE is symmetrical (you don't know if an AH is for rx/tx in UD
and you need to select
a single sgid_index for RC connections), we need to verify that it
matches an egress route
bounded to this netdevice.

Regarding the CM, it could be implemented through the network stack as
well. It'll actually give
the correct netdev. Saying that, I'm not sure all hardwares support that.

As a quick fix, setting ifindex to get_netdev's ifindex in link local
addresses and filter out unsupported
netdevices in the GID cache, seems like a reasonable solution to me.

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
