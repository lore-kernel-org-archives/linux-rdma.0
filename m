From: Erez Shitrit <erezsh@dev.mellanox.co.il>
Subject: Re: [RFC v1 for accelerated IPoIB 04/25] IB/verb: Add ipoib_options
 struct and API
Date: Thu, 16 Mar 2017 17:17:55 +0200
Message-ID: <CAAk-MO8vPepHWHF_2GMbtC3yyxht1VFs=3Gu1r+drDs7ZbdpOg@mail.gmail.com>
References: <1489429896-10781-1-git-send-email-erezsh@mellanox.com>
 <1489429896-10781-5-git-send-email-erezsh@mellanox.com> <20170313200136.GA2738@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170313200136.GA2738@obsidianresearch.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Erez Shitrit <erezsh@mellanox.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, netdev@vger.kernel.org, valex@mellanox.com, Leon Romanovsky <leonro@mellanox.com>, saedm@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 13, 2017 at 10:01 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
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
>
> Should 'lid' be 'mlid'?
>
>> +     int qp_num;
>
> This one probably belongs in ipoib_rdma_netdev
>
>> +     void *context;

The QP as a part of the HW resources, it is created in the low-level
driver, and used by the upper ipoib for few reasons, (for example the
mac of the ipoib interface includes from the qp_num)
Now, if we want to use the ndo's init/uninit i need to store member
variables (qp_num and context) in the rdma_netdev, that will let me
use the ndos as is.
rdma_netdev is the one who belongs to both layers, ipoib and the low-level.

>
> What is this? Why is something other than ipoib_priv or ipoib_dev_priv
> needed?
>
>
>>                                               struct ib_wq_attr *attr,
>>                                               u32 wq_attr_mask,
>>                                               struct ib_udata *udata);
>> +     struct ib_ipoib_accel_ops * (*get_ipoib_accel_ops)(struct ib_device *device);
>
> rebase error? Not sure how this compiles
>
> Jason
