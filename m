From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/ipoib: Allow mcast packets from other VFs
Date: Sun, 6 Mar 2016 14:13:18 +0200
Message-ID: <CAJ3xEMgKafcZv-u_VteAXsDXQMy2NE45cEQzWHHS-f-KxY_nNg@mail.gmail.com>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
	<1456851143-138332-10-git-send-email-eli@mellanox.com>
	<20160306115006.GA23975@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160306115006.GA23975-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 6, 2016 at 1:50 PM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Mar 01, 2016 at 06:52:22PM +0200, Eli Cohen wrote:

>> @@ -239,6 +233,27 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
>>       else
>>               skb->pkt_type = PACKET_MULTICAST;
>>
>> +     sgid = &((struct ib_grh *)skb->data)->sgid;
>> +
>> +     /*
>> +      * Drop packets that this interface sent, ie multicast packets
>> +      * that the HCA has replicated.
>> +      */
>> +     if (wc->slid == priv->local_lid && wc->src_qp == priv->qp->qp_num) {
>> +             int need_repost = 1;
>> +
>> +             if ((wc->wc_flags & IB_WC_GRH) &&
>> +                 memcmp(&sgid->global.interface_id,
>> +                        &priv->local_gid.global.interface_id,
>> +                        sizeof(sgid->global.interface_id)))

> 1. Why can't we do sgid->global.interface_id !=
> priv->local_gid.global.interface_id

you mean get better perf for A !=B on 64bit ARCHs? yes, we can do
that,  I guess.


> 2. Don't we need also to check subnet_prefix? i.e. is it possible to have
> same interface_id on different networks?

We're trying to figure out if this is US (node X, port Y) who send
this packet, and looking
for the minimal thing to compare on.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
