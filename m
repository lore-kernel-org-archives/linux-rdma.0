From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC for accelerated IPoIB 00/27] Enhanced mode for IPoIB driver
Date: Thu, 2 Mar 2017 21:13:33 +0200
Message-ID: <CAAk-MO9tAHioaSXv8MPu=Kf3QSxjuQhAt6vYRVCzuNriXkm-+A@mail.gmail.com>
References: <1488376954-8346-1-git-send-email-erezsh@mellanox.com> <20170301182039.GC14791@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301182039.GC14791-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 1, 2017 at 8:20 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Mar 01, 2017 at 04:02:08PM +0200, Erez Shitrit wrote:
>>     /* default accelerating functions, same as before */
>>     struct ib_ipoib_accel_ops default_ipoib_accel_ops = {
>>             .ib_dev_init = ipoib_dev_init_default,
>>             .ib_dev_cleanup = ipoib_dev_uninit_default,
>>             .ib_dev_open = ipoib_ib_dev_open_default,
>>             .ib_dev_stop = ipoib_ib_dev_stop_default,
>>             .send = ipoib_send,
>>             .create_netdev = ipoib_create_netdev_default,
>>             .attach_mcast = ipoib_mcast_attach,
>>             .dettach_mcast = ipoib_mcast_dettach,
>>     };
>
> This is so ridiculously close to what opa_vnic is doing, please try to
> work with them to figure out some common version of your
> 'create_netdev':
>
> +struct ib_ipoib_accel_ops {
> +
> +       /*
> +        * HW provider driver creates the net_device for IPoIB.
> +        * hca: The current ib device.
> +        * name: is the format of the new network device (probably ib%d)
> +        */
> +       struct net_device * (*create_netdev)(struct ib_device *hca,
> +                                            const char *name,
> +                                            void (*setup)(struct net_device *));
>
>
> vs:
>
> @@ -2110,6 +2128,15 @@  struct ib_device {
>
> +       struct net_device *(*alloc_rdma_netdev)(
> +                                       struct ib_device *device,
> +                                       u8 port_num,
> +                                       enum rdma_netdev_t type,
> +                                       const char *name,
> +                                       unsigned char name_assign_type,
> +                                       void (*setup)(struct net_device *));
>
>
> I've pointed out again and again you two are working on the same
> thing.
>
> It is inexplicable to me you couldn't use this opa_vnic patch as a
> starting point for the ipoib api:
>
> https://patchwork.kernel.org/patch/9587819/
>
> I would propose you add a RDMA_NETDEV_IPOIB to their stuff and a
> rdma_netdev_get_ipoib_ops(struct net_device *) to get your
> rdma_netdev_ipoib_ops.
>

We agree that both of the implementations look similar in some way,
and we think that at the end we can give one api that will work for
both of us.
but, we need to remember that IPoIB acceleration and VNIC are coming
to solve different issues.

Anyway, It doesn't right for us to use the api as it is in the VNIC
code, there are few differences that according to them we started with
a different set of functions:

1. We added acceleration to IPoIB driver which is generic network
device driver and should work over any other HW specific vendor,
without exposing the way the acceleration is done beneath, so we
preferred not to  tie the implementation to the term "netdev ndo,
The VNIC driver is free to do whatever it likes to because it "knows"
what is going on in the low-level-driver (which is from the same
vendor)
also, we tried to keep the IPoIB code as before, the only changes is
by separating control from data-path, that derived the meaning of the
functions we exported, only data-path or HW resources handling.

2. we wanted to keep the IPoIB code as clean as we can, so we created
a "default acceleration" that works the same way as it was before, the
idea that leads that is to separate the HW specific from the
control/management area, and that is done better/simpler with the set
of functions that are exposed.

3. We are using some functions that are not part of the ndo calls or
are used differently for example:
We need functions to attach / detach mcast, we are using send function
that needs to get the ah object We can do some hacking but we think it
is cleaner that way.

I think that we can change the create_netdev api to be like is in the
VNIC code, but we would like to keep the rest of the functions in our
struct and suggest the VNIC driver will use it in order to get the
pointer of the create_netdev, We think that struct of pointers to
functions can be flexible to future needs with no need to consider the
ndo existence.

meaning:
one verb that expose struct of functions.
for IPoIB we will use all of them.
for VNIC it will use the create_netdev only.
both of the driver are able to use them for their specific needs.

> I also wonder why there are so many ops, for instance the approach of
> having the driver set .ndo_stop and others seems better.
>
> ipoib could either 'wrapper' that pointer after calling
> alloc_rdma_netdev or it could export enough utility functions for the
> driver to implement the needed behavior. (eg this may be more in line
> with the "midlayer mistake" thinking of
> https://lwn.net/Articles/336262/)
>
> Maybe Niranjana has some suggestions based on learning in vnic, they
> tried a few different schemes.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
