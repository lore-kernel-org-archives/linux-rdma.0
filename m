From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
Date: Thu, 9 Feb 2017 11:24:17 +0200
Message-ID: <CAAKD3BBunKCb6Z-FObOD0covTt3gCXDn3oic4LNbU3J5JHiQJw@mail.gmail.com>
References: <20170130195412.GE24466@obsidianresearch.com> <VI1PR0502MB30081EBFBEE5994B77D58BB9D14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130211420.GB27111@obsidianresearch.com> <VI1PR0502MB30081EC9B35269636B4C2FBCD14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130221437.GA28117@obsidianresearch.com> <VI1PR0502MB3008B16A0F103D729209EA16D14A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170131005340.GA30809@obsidianresearch.com> <CAAKD3BDbkFHbCi+gHyCXCGV2xi5E9FA+KgwKz+6dBJEtsV0ZkQ@mail.gmail.com>
 <20170208174040.GC30720@obsidianresearch.com> <VI1PR0502MB3008417F3E388B617291147CD1450@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170209000157.GA14556@obsidianresearch.com> <VI1PR0502MB3008153CDFD7F9C7CCAB022CD1450@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008153CDFD7F9C7CCAB022CD1450-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 9, 2017 at 2:15 AM, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
>> -----Original Message-----
>> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
>> Sent: Wednesday, February 8, 2017 6:02 PM
>> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>; Roland Dreier
>> <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Matan Barak
>> <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
>>
>> On Thu, Feb 09, 2017 at 12:00:09AM +0000, Parav Pandit wrote:
>>
>> > > That still breaks link local addresses on vlan devices, so it is an
>> > > ugly hack, not a solution.
>> >
>> > In presence of vlan, shouldn't we be passing the ifindex of the vlan
>> netdev?
>>
>> yes, that is exactly my point...
>
> Oh ok. I get it. I am on right path to fix it than.
>
> Additionally,
> when there is macvlan based slave device present on this vlan device, I will pass the ifindex of that particular netdev.
> Now since we don't have MAC address coming in ib_wc nor in IB/RoCEv2 Annex spec, code needs to refer to the
> (a) ifaddr of the vlan netdev
> and
> (b) ifaddr of the slave netdevs
> Compare the DGID of the grh with ifaddr and use that netdev's ifindex for the first matching entry.
>
> Sounds reasonable now?
>

Since we don't get the DMAC address, I think the GID cache shouldn't
carry entries which the hardware
can't differentiate upon. It might be ok for some cases in the
transmit side (as you choose the smac
based on the netdev attached to the GID entry, but if you add a vxlan
based interface, you won't
be able to add the appropriate headers). We can leave this as is or
making it symmetrical.

So, when adding a GID, we need to consult the hardware capabilities
regarding the metadata
it can provide in the completion. If the hardware isn't capable of
creating/stripping one of the headers
of this netdev, there's no reason to add it.

If the hardware supports creating/stripping the required headers but
it doesn't support reporting
them in the completion or all fields are supported but there are
conflicting entries, you could
either consult the ingress route before adding these GIDs or add them
both and consult the
ingress route when creating an AH from the completion entry and GRH data.
I think adding them both, selecting the first one and validating with
the ingress route is the way
to go.

The link local address falls into this case as well.

>
>>
>> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
