From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC v1 for accelerated IPoIB 05/25] IB/ipoib: Support ipoib
 acceleration options callbacks
Date: Wed, 15 Mar 2017 18:27:23 +0200
Message-ID: <CAAk-MO96BbTnn=gzdZhRpQUENn=AVUJv1JhPbrSYrNHOrbFVeg@mail.gmail.com>
References: <1489429896-10781-1-git-send-email-erezsh@mellanox.com>
 <1489429896-10781-6-git-send-email-erezsh@mellanox.com> <20170313201049.GB2738@obsidianresearch.com>
 <CAAk-MO8-bnWRu7BDtYDhNePj+76X4Vb7gFNhED8irLNtqR7tCw@mail.gmail.com> <20170314160616.GE3244@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170314160616.GE3244-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 14, 2017 at 6:06 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Mar 14, 2017 at 04:39:20PM +0200, Erez Shitrit wrote:
>
>> >> -static int ipoib_dev_init_default(struct net_device *dev, struct ib_device *ca,
>> >> -                               int port)
>> >> +static int ipoib_dev_init_default(struct net_device *dev,
>> >> +                               struct ib_device *hca, int *qp_num)
>> >>  {
>> >> -     struct ipoib_dev_priv *priv = netdev_priv(dev);
>> >> +     struct ipoib_dev_priv *priv = ipoib_priv(dev);
>> >> +
>> >> +     netif_napi_add(dev, &priv->napi, ipoib_poll, NAPI_POLL_WEIGHT);
>> >
>> > All these 'default' functions are part of the 'rn driver'. They should
>> > not be calling ipoib_priv, you said you didn't want ipoib_dev_priv
>> > leaking into the drivers.
>>
>> Do you mean in the name of the function?   drma_netdev_init_default
>> instead of ipoib_dev_init_default ?
>
> No, I mean ipoib_priv() should only be called by IPOIB core code and
> ipoib_dev_priv() should only be called by code under the rdma_netdev
> interface.
>
> The names you picked are confusing.
>
> This is the core code priv:
>
>  struct ipoib_dev_priv *priv = ipoib_priv(dev);
>
> And this is the rdma_netdev priv:
>
>   struct ipoib_rn_default *priv = ipoib_dev_priv(dev)
>   struct ipoib_rn_mlx5 *priv = ipoib_dev_priv(dev)
>
> Rename ipoib_dev_priv() to something that doesn't collide with the
> structure.

OK, will change the function  ipoib_dev_priv to something like  ipoib_accel_priv

>
> Move things like priv->napi into ipoib_rn_default, only the stuff
> under rdma_netdev should touch NAPI.

When no accelerator is around, ipoib should work as before, and the
struct struct ipoib_dev_priv is the one who does all datapath and
control.

>
> Try hard not to use 'struct ipoib_dev_priv' inside the callbacks
> related to the default rn netdev implementation.

OK

>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
