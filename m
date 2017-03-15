From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC v1 for accelerated IPoIB 25/25] mlx5_ib: skeleton for
 mlx5_ib to support ipoib_ops
Date: Wed, 15 Mar 2017 10:42:58 +0200
Message-ID: <CAAk-MO-xtC55t7XqsvFp95CX9MxSiNrPhr_hma2d3Vg8a4+ZgA@mail.gmail.com>
References: <1489429896-10781-1-git-send-email-erezsh@mellanox.com>
 <1489429896-10781-26-git-send-email-erezsh@mellanox.com> <20170313202720.GC2738@obsidianresearch.com>
 <CAAk-MO9ekfWZT-C2SKTw129t=UQty9w2+wzQsvY1Od0k1zSrpA@mail.gmail.com> <20170314161013.GF3244@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170314161013.GF3244-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 14, 2017 at 6:10 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Mar 14, 2017 at 04:53:24PM +0200, Erez Shitrit wrote:
>
>> > Why isn't this stuff in open/close?
>>
>> According to ipoib control flows, there is a different between
>> open/close to init/cleanup for example, in open/close the driver
>> doesn't destroy hw resources, just change the state, it destroys
>> them in cleanup.
>
> So put it in mlx5_alloc_rdma_netdev then?
>
> Or ndo.init as was suggested?
>
> Or in the void (*setup)(struct net_device *)
>
>> >> +     param.size_base_priv = sizeof(struct ipoib_rdma_netdev);
>> >
>> > This is really weird, the code in mlx5i_create_netdev calls
>> > ipoib_dev_priv so it must assume the struct is a ipoib_rdma_netdev.
>>
>> It is the same attitude as in the vnic/hfi
>> (https://patchwork.kernel.org/patch/9587815/)
>
> Not quite, they call alloc_netdev_mqs directly, here indirects through
> mlx5i_create_netdev which assumes a priv layout, Just drop
> param.size_base_priv and put that same calculation in
> mlx5i_create_netdev..

Agree, will fix that. thanks.

>
> Jason
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
