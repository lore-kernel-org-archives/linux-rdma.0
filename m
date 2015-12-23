From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/cma: cma_match_net_dev needs to take into account port_num
Date: Wed, 23 Dec 2015 18:20:04 +0200
Message-ID: <CAAKD3BAqTaiiYnSz4tOca17nWJ9po_JH5ccG=+1b-WRkPemObQ@mail.gmail.com>
References: <1450710084-22547-1-git-send-email-matanb@mellanox.com>
	<56792A4B.8060101@mellanox.com>
	<56799D61.9010206@redhat.com>
	<CAAKD3BDmenFsiZTDiw8OEW-F0GqK62+zJ-TVywyYd4YDtzxrCA@mail.gmail.com>
	<567AC6E4.3030100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567AC6E4.3030100-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 23, 2015 at 6:08 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 12/22/2015 02:26 PM, Matan Barak wrote:
>> On Tue, Dec 22, 2015 at 8:58 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> On 12/22/2015 05:47 AM, Or Gerlitz wrote:
>>>> On 12/21/2015 5:01 PM, Matan Barak wrote:
>>>>> Previously, cma_match_net_dev called cma_protocol_roce which
>>>>> tried to verify that the IB device uses RoCE protocol. However,
>>>>> if rdma_id didn't have a bounded port, it used the first port
>>>>> of the device.
>>>>>
>>>>> In VPI systems, the first port might be an IB port while the second
>>>>> one could be an Ethernet port. This made requests for unbounded rdma_ids
>>>>> that come from the Ethernet port fail.
>>>>> Fixing this by passing the port of the request and checking this port
>>>>> of the device.
>>>>>
>>>>> Fixes: b8cab5dab15f ('IB/cma: Accept connection without a valid netdev
>>>>> on RoCE')
>>>>> Signed-off-by: Matan Barak<matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>
>>>> seems that the patch is missing from patchworks, I can't explain that.
>>>
>>> I've already downloaded it and marked it accepted.
>>>
>>
>> Thanks Doug. Would you like that I'll repost the patch with the commit
>> message changed as Or suggested or is the current version good enough?
>>
>> Regarding the Ethernet loopback issue, I started looking into that,
>> but as Or stated, it's broken even before the RoCE patches.
>
> Ping.  Any progress on this?

Yeah, there's some progress - the basic problem is that we don't have
a bounded ndev and thus cma_resolve_iboe_route returns -ENODEV.
The root cause for this is that we have to store the ndev in
cma_bind_loopback. Even after doing that, cma_set_loopback changes the
sgid to be the localhost GID, which doesn't exist in the GID table and
thus will fail later in the GID lookup.
I think that regarding loopback, we actually want to send the data on
the link local default GID, which is guaranteed to exist. That's why I
think we should:
1. Change the cma_src_addr and cma_dst_addr in cma_bind_loopback to be
the default GID.
2. Store the associated ndev of this default GID as the bounded device.
3. In cma_resolve_loopback, get the MAC of this bounded device and
store it as the DMAC.
4. In cma_resolve_iboe_route, don't try to do route resolve if the
dGID matches the default GID.

It's still not working though, but this is where I'm headed. What do you think?


>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
>

Regards,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
