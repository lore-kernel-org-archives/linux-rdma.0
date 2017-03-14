From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC v1 for accelerated IPoIB 04/25] IB/verb: Add ipoib_options
 struct and API
Date: Tue, 14 Mar 2017 15:25:01 +0200
Message-ID: <CAAk-MO8dZJKYgpWT8p1fz0O6y2wTx4jxoJhYf21ikMOef_xUMg@mail.gmail.com>
References: <1489429896-10781-1-git-send-email-erezsh@mellanox.com>
 <1489429896-10781-5-git-send-email-erezsh@mellanox.com> <20170313200136.GA2738@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170313200136.GA2738-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 13, 2017 at 10:01 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Mar 13, 2017 at 08:31:15PM +0200, Erez Shitrit wrote:
>
>> diff --git a/include/rdma/ib_ipoib_accel_ops.h b/include/rdma/ib_ipoib_accel_ops.h
>> new file mode 100644
>> index 000000000000..148a5529a559
>> +++ b/include/rdma/ib_ipoib_accel_ops.h
>
> Both patches need a better naming scheme for this file..
>
> rn_opa_vnic.h
> rn_ipoib.h
>
> Maybe?

Can work for me.

vnic?

>
>> +struct rdma_netdev {
>> +     void *clnt_priv;
>> +
>> +     /* control functions */
>> +     void (*set_id)(struct net_device *netdev, int id);
>
>> +     /* IB resource allocation function, returns new UD QP */
>> +     int (*ib_dev_init)(struct net_device *dev, struct ib_device *hca,
>> +                        int *qp_num);
>
> Why can't some combination of alloc_rdma_netdev and ndo.open do this stuff?
>
>> +     void (*ib_dev_cleanup)(struct net_device *dev, struct ib_device *hca);
>
> Ditto
>
>> +     /* send packet */
>> +     void (*send)(struct net_device *dev, struct sk_buff *skb,
>> +                  struct ipoib_ah *address, u32 dqpn, u32 dqkey);
>
>> +     /* multicast */
>> +     int (*attach_mcast)(struct net_device *dev, struct ib_device *hca,
>> +                         union ib_gid *gid, u16 lid, int set_qkey);
>> +     int (*detach_mcast)(struct net_device *dev, struct ib_device *hca,
>> +                         union ib_gid *gid, u16 lid);
>
> It would make more sense to store the struct ib_device pointer in the
> struct rdma_netdev.

Yes, I can add the ib_device and the qp_number to the rdma_netdev, and
in that way will take out the extra parameters for these functions and
be able to use ndo_ops.

>
> Should 'lid' be 'mlid'?

yes. will change

>
>> +     int qp_num;
>
> This one probably belongs in ipoib_rdma_netdev
>
>> +     void *context;
>
> What is this? Why is something other than ipoib_priv or ipoib_dev_priv
> needed?

ipoib_priv is doesn't known in the lower layers, that context is used
to keep data (qp pointer in that case) that is not available
otherwise.

>
>
>>                                               struct ib_wq_attr *attr,
>>                                               u32 wq_attr_mask,
>>                                               struct ib_udata *udata);
>> +     struct ib_ipoib_accel_ops * (*get_ipoib_accel_ops)(struct ib_device *device);
>
> rebase error? Not sure how this compiles

yes, will take it out. (was compiled with that, probably because it is
not in used.)

>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
