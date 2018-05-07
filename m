From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH v2 net 0/2] IB/ipoib: ip link support
Date: Mon, 7 May 2018 20:29:25 +0300
Message-ID: <CAJ3xEMhzv-CW0XdENn9koScBcxrhXDqEd-Es8=b6edzmHCZrkQ@mail.gmail.com>
References: <20180101224347.xdxguvvr4g7jrxq4@inn> <1515534167-13062-1-git-send-email-denisd@mellanox.com>
 <20180115.131309.1163036253579166139.davem@davemloft.net> <20180118042549.GA11171@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180118042549.GA11171@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Alex Vesker <valex@mellanox.com>, Denis Drozdov <denisd@mellanox.com>
Cc: David Miller <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Linux Netdev List <netdev@vger.kernel.org>, Jason Gunthorpe <jgg@mellanox.com>, Don Dutile <ddutile@redhat.com>, Honggang Li <honli@redhat.com>, Noa Spanier <noas@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 18, 2018 at 7:25 AM, Jason Gunthorpe <jgg@mellanox.com> wrote:
> On Mon, Jan 15, 2018 at 01:13:09PM -0500, David Miller wrote:
>> From: Denis Drozdov <denisd@mellanox.com>
>> Date: Tue,  9 Jan 2018 23:42:45 +0200
>>
>> > IP link was broken due to the changes in IPoIB for the rdma_netdev
>> > support after commit cd565b4b51e5
>> > ("IB/IPoIB: Support acceleration options callbacks").
>> >
>> > This patchset restores IPoIB pkey creation and removal using rtnetlink.
>> > The first patch introduces changes in the rtnetlink code in order to allow
>> > IPOIB allocate and free the netdevice.
>> >
>> > The second patch establishes appropriate rtnetlink callbacks for IPoIB
>> > device and restores IPoIB netlink support
>> >
>> > Changes since v1:
>> > - Fixed double free_netdev calls in ops->free_link in netdev_run_todo
>> > - Removed priv_size from ipoib_link_ops as not required anymore.
>>
>> Please fix your control flow so that the existing netlink op can do
>> the right thing.
>
> Okay. Since this bug has been outstanding in RDMA for so long, I've
> looked pretty carefully at this..
>
> This patch does go too far, but ipoib does appear to legitimately need
> something special here and no amount of 'control flow fixing' in ipoib
> will solve it.
>
> The fundamental issue is that ipoib no longer has a generic software
> netdev for the child interface. Instead the child interface is bound
> directly to one of several *full* hardware drivers. ie the child and
> the master are basically exactly the same HW dependent code.
>
> Since the child is a full hardware netdev, it has its own HW driven
> needs for priv_size, txqs, rxqs, etc. There is no 'one size fits all'
> value like for all the other software based newlink users. It depends
> on the HW device installed in the system (eg mlx4, mlx5, hfi1)
>
> The only problem with rtnl newlink is that it wants to use priv_size,
> txqs, and rxqs values from a singleton static global structure (eg
> ipoib_link_ops) which cannot know in advance which ipoib HW driver is
> in use by the specific parent the child is being created for.
>
> This is what needs to be fixed. ipoib simply needs to have
> parent-dependent inputs to the alloc_netdev_mqs in rtnl_create_link.
>
> The patch proposes
>
>   struct net_device *(*alloc_link)(struct net *src_net,
>                                    const char *dev_name,
>                                    struct nlattr *tb[]);
>
> To let ipoib allocate the netdev, and then obviosly figure out the
> right parameters internally.
>
> This patch also adds some free related stuff, but that seems to be
> going too far. ipoib can use the normal free paths. The above is all
> that is necessary.
>
> An alternative would be something like:
>
>   struct rtnl_alloc_params {
>        size_t priv_size;
>        int txqs;
>        int rxqs;
>   };
>   void (*get_alloc_parameters)(struct net_device *net,
>                                struct rtnl_alloc_params *parms);
>
> To let ipoib tell rtnl_create_link what parameters to use based on
> 'net' instead of taking them from the global singleton.
>
> Do you see another choice?
>
> Can you accept one of these options?
>
> Thanks,
> Jason
> (BTW, Doug & I are now co-maintaining RDMA, so I say the above with my
>  maintainer hat on. This is a serious userspace visible regression bug
>  on our side, and I really want to see it fixed.)


Guys,

This is broken upstream for a long time, and now in few distributions
that picked
the patches that introduce the breakage, what is the plan?

Or.
