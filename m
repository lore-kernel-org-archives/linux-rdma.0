From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH libibverbs 2/3] Add support for TCP segmentation offload (TSO)
Date: Sun, 21 Aug 2016 09:59:26 +0300
Message-ID: <CAJ3xEMjYP=+Kpeda1JaMK6M7xrjC+ikKwDa=bj4dqrDzoGSO2A@mail.gmail.com>
References: <1469708382-29408-1-git-send-email-yishaih@mellanox.com>
 <1469708382-29408-3-git-send-email-yishaih@mellanox.com> <80ff6d05-201a-3fa6-deab-2dbb035a89c3@mellanox.com>
 <HE1PR05MB1418BA4382257289AB9DEA63CE150@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <CAJ3xEMgsaNq0bp005WPeU9X8H3tvpmCUymNKb0Ht8c6O---JSg@mail.gmail.com> <5c895498-caad-0ac3-5a66-286fc1ab2906@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5c895498-caad-0ac3-5a66-286fc1ab2906-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 19, 2016 at 12:26 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>
>>>> why is that needed? what's the proposed/possible applicative usage of
>>>> that bit?
>>>
>>>
>>> It's consistent with the kernel API that adds similar bit for LSO.
>>> http://lxr.free-electrons.com/source/include/rdma/ib_verbs.h#L842
>>
>>
>> C&P is not something you want to use as argument, specifically if no
>> one uses this 10y old define nowadays (and maybe never)
>>
>> net.git]# git grep IB_WC_LSO drivers/infiniband/ include/rdma/
>> drivers/infiniband/hw/mlx4/cq.c: wc->opcode    = IB_WC_LSO;
>> include/rdma/ib_verbs.h:        IB_WC_LSO,
>
>
> IPoIB never looks at wc->opcode, does it mean that it is redundant?

I tend to agree :)

> I tend to agree that something that is not used shouldn't exist, but
> my concern is what is the semantics in the lack of IBV_WC_TSO? You post
> IBV_WR_TSO and when you get the completion and happen to look at the
> wc->opcode, what would you expect to see?

again, fact is that the application (ipoib) doesn't need it, as you
can see mlx5 even doesn't implement that.

The application should expect a completion of a send, that's it.

# git grep WR_LSO drivers/infiniband/
drivers/infiniband/hw/mlx4/qp.c:                        if (wr->opcode
== IB_WR_LSO) {
drivers/infiniband/hw/mlx5/qp.c:        if (wr->opcode == IB_WR_LSO) {
drivers/infiniband/sw/rxe/rxe_comp.c:   case IB_WR_LSO:
         return IB_WC_LSO;

drivers/infiniband/ulp/ipoib/ipoib_ib.c:
priv->tx_wr.wr.opcode   = IB_WR_LSO;

[root@r-dcs58 net.git]# git grep WC_LSO drivers/infiniband/
drivers/infiniband/hw/mlx4/cq.c:                        wc->opcode
= IB_WC_LSO;
drivers/infiniband/sw/rxe/rxe_comp.c:   case IB_WR_LSO:
         return IB_WC_LSO;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
