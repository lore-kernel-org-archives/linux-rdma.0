From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] IB/core: Use hop-limit from IP stack for RoCE
Date: Mon, 4 Jan 2016 10:23:57 +0200
Message-ID: <CAAKD3BBsw4nQLGZ9T8OMi2b4ZijZYVsNLjdhAs5Fxt6fhPZdPA@mail.gmail.com>
References: <1451829552-32337-1-git-send-email-matanb@mellanox.com>
	<1451829552-32337-3-git-send-email-matanb@mellanox.com>
	<20160103190349.GA20412@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160103190349.GA20412-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 3, 2016 at 9:03 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, Jan 03, 2016 at 03:59:11PM +0200, Matan Barak wrote:
>> @@ -434,6 +434,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
>>       int ret;
>>       enum rdma_network_type net_type = RDMA_NETWORK_IB;
>>       enum ib_gid_type gid_type = IB_GID_TYPE_IB;
>> +     int hoplimit = grh->hop_limit;
>
>>               ah_attr->grh.flow_label = flow_class & 0xFFFFF;
>> -             ah_attr->grh.hop_limit = 0xFF;
>> +             ah_attr->grh.hop_limit = hoplimit;
>
> No, this is wrong for IB. Please be careful to follow the IB
> specification language for computing a hop limit on a reversible path.
>

You're right, this should be 0xff. Thanks.

> No idea about rocee, but I can't believe using grh->hop_limit is right
> there either.
>

Regarding RoCE, the hop limit is set from the routing table (in the
same function):
ret = rdma_addr_find_l2_eth_by_grh(&dgid, &sgid,
                                                           ah_attr->dmac,

wc->wc_flags & IB_WC_WITH_VLAN ?
                                                           NULL : &vlan_id,
                                                           &if_index,
&hoplimit);



> Jason
>

Regards,
Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
