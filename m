From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Use vmalloc for WR buffers when needed
Date: Fri, 25 Sep 2015 08:51:22 +0800
Message-ID: <56049A8A.6040101@oracle.com>
References: <1443091747-13881-1-git-send-email-wen.gang.wang@oracle.com>
 <CAJ3xEMgN4_gk4_hVXOW2GhcfnXxgPnm=Lrc7JwkxBAeKv4KRAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgN4_gk4_hVXOW2GhcfnXxgPnm=Lrc7JwkxBAeKv4KRAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or,

=E5=9C=A8 2015=E5=B9=B409=E6=9C=8824=E6=97=A5 19:57, Or Gerlitz =E5=86=99=
=E9=81=93:
> On Thu, Sep 24, 2015 at 1:49 PM, Wengang Wang <wen.gang.wang@oracle.c=
om> wrote:
>> @@ -786,8 +787,14 @@ static int create_qp_common(struct mlx4_ib_dev =
*dev, struct ib_pd *pd,
>>                  if (err)
>>                          goto err_mtt;
>>
>> -               qp->sq.wrid  =3D kmalloc(qp->sq.wqe_cnt * sizeof (u6=
4), gfp);
>> -               qp->rq.wrid  =3D kmalloc(qp->rq.wqe_cnt * sizeof (u6=
4), gfp);
>> +               qp->sq.wrid =3D kmalloc(qp->sq.wqe_cnt * sizeof(u64)=
, gfp);
>> +               if (!qp->sq.wrid)
>> +                       qp->sq.wrid =3D __vmalloc(qp->sq.wqe_cnt * s=
izeof(u64),
>> +                                               gfp, PAGE_KERNEL);
> On other spots of mlx4, we're using vmalloc and not __vmalloc, any
> pros/cons for going that way too here?

vmalloc is just using GFP_KERNEL | __GFP_HIGHMEM, we can't pass in the=20
flag gfp with it.  We should respect orginal code which needs to pass=20
the flag.

thanks,
wengang

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
