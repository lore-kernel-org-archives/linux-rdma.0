From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC v1 for accelerated IPoIB 05/25] IB/ipoib: Support ipoib
 acceleration options callbacks
Date: Wed, 15 Mar 2017 12:11:38 +0200
Message-ID: <CAAk-MO8cRpqF_3aHHZr5wpgOb4x6Bp_1bN-u7_zj2yzze7vv=A@mail.gmail.com>
References: <1489429896-10781-1-git-send-email-erezsh@mellanox.com>
 <1489429896-10781-6-git-send-email-erezsh@mellanox.com> <20170314063538.GB79937@knc-06.sc.intel.com>
 <CAAk-MO8gQ5x-4Ubk1nzPntEWa2ivTK6uXyJ4eC7fmtUCNnOdfA@mail.gmail.com> <20170314160021.GD3244@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170314160021.GD3244-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 14, 2017 at 6:00 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Mar 14, 2017 at 04:42:55PM +0200, Erez Shitrit wrote:
>> >> +       if (!hca->alloc_rdma_netdev)
>> >> +               dev = ipoib_create_netdev_default(hca, name,
>> >> ipoib_setup_common);
>> >> +       else
>> >> +               dev = hca->alloc_rdma_netdev(hca, port, RDMA_NETDEV_IPOIB,
>> >> +                                            name, NET_NAME_UNKNOWN,
>> >> +                                            ipoib_setup_common);
>> >> +       if (!dev) {
>> >> +               kfree(priv);
>> >> +               return NULL;
>> >> +       }
>> >
>> >
>> > This will break ipoib on hfi1 as hfi1 will define alloc_rdma_netdev for
>> > OPA_VNIC type. We should probably look for a dedicated return type
>> > (-ENODEV?) to determine of the driver supports specified rdma netdev type.
>> > Or use a ib device attribute to suggest driver support ipoib rdma netdev.
>>
>> sorry, I don't understand that, we are in ipoib driver, so the type is
>> RDMA_NETDEV_IPOIB, if hfi wants to implement it should use the same
>> flag, and to use OPA_VNIC for vnic.
>
> He means it should look like this:
>
>  if (hca->alloc_rdma_netdev)
>      dev = hca->alloc_rdma_netdev(hca, port, RDMA_NETDEV_IPOIB,
>                                             name, NET_NAME_UNKNOWN,
>                                             ipoib_setup_common);
>
>  if (IS_ERR(dev) && PTR_ERR(dev) != ENOTSUP)
>       goto out;
>
>  dev = ipoib_create_netdev_default(hca, name, ipoib_setup_common);
>  if (IS_ERR(dev))
>       goto out;
>
>  WARN_ON(dev == NULL);
>
>   [...]
>
> out:
>       return PTR_ERR(dev);

OK, got it. will arrange the code accordingly. thank you both.

>
> And I'm confused why 'ipoib_create_netdev_default' doesn't need the
> same function signature as hca->alloc_rdma_netdev

I can pass both of them the same parameters, just to be consistent,
(the default doesn't need the type RDMA_NETDEV_IPOIB and the port).

>
> Both drivers should implement hca->alloc_rdma_netdev to return ENOTSUP

Both is for vnic and ipoib ?

> if RDMA_NETDEV is not supported.
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
