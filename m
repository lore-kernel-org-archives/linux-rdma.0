From: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: =?UTF-8?Q?ib=5Fsrpt=20and=20mellanox=20mthca=20device?=
Date: Thu, 12 Apr 2012 08:52:09 +0300
Message-ID: <2f4564980ae4cdafdc456a8e41b4ab04@omrb.pnpi.spb.ru>
References: <5f95768153388b91a2ffa0cd118d7ad8@omrb.pnpi.spb.ru>
 <CAL1RGDWNqMdQGrXbh2gj==_KvVRF1mUQw2D3NqEhjvuq2q2+6Q@mail.gmail.com>
 <97cccba5ba7ddc74e87b0791050fa755@omrb.pnpi.spb.ru>
 <CAL1RGDVbqOQP+AH4f9cs+mEngXVTOy7r7gRjJ=SU_rMmvCg3Qg@mail.gmail.com>
 <fa3a67e9423946c0bbd23abb3f60921a@omrb.pnpi.spb.ru>
 <CAL1RGDVn1Roo-KaZW_r_WAQudbEZ2+mXD2RqNS68Rg=UBTRe7Q@mail.gmail.com>
 <806c99edea592c69d0aa9073bae2a3b9@omrb.pnpi.spb.ru>
 <CAL1RGDXT1gshgxA+c9M==zxarKnjKZtcy4dROtOnKVmc9+u9HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXT1gshgxA+c9M==zxarKnjKZtcy4dROtOnKVmc9+u9HQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland!

Seems like this card doesnt support srq
store linux # ibv_srq_pingpong
Couldn't get local LID

PS on nodes with mlx4 devices ibv_srq_pingpong works

also with yout change it doesnt report anything new
Loading kernel module for a network device with CAP_SYS_MODULE=20
(deprecated).  Use CAP_NET_ADMIN and alias netdev-ib0 instead.
ib_mthca: Mellanox InfiniBand HCA driver v1.0 (April 4, 2008)
ib_mthca: Initializing 0000:4b:00.0
ib_mthca 0000:4b:00.0: irq 49 for MSI/MSI-X
ib_mthca 0000:4b:00.0: irq 50 for MSI/MSI-X
ib_mthca 0000:4b:00.0: irq 51 for MSI/MSI-X
srpt_add_one(mthca0) failed.

Roland Dreier =D0=BF=D0=B8=D1=81=D0=B0=D0=BB 2012-04-12 04:24:
>> I tryed this patch but it doesnt work i still get
>> ib_mthca: Initializing 0000:4b:00.0
>> ib_mthca 0000:4b:00.0: irq 49 for MSI/MSI-X
>> ib_mthca 0000:4b:00.0: irq 50 for MSI/MSI-X
>> ib_mthca 0000:4b:00.0: irq 51 for MSI/MSI-X
>> srpt_add_one(mthca0) failed.
>
> Hmm, in srpt_add_one(), where it says
>
> 	sdev->srq =3D ib_create_srq(sdev->pd, &srq_attr);
> 	if (IS_ERR(sdev->srq))
> 		goto err_mr;
>
> can you change that to
>
> 	sdev->srq =3D ib_create_srq(sdev->pd, &srq_attr);
> 	if (IS_ERR(sdev->srq)) {
>                 pr_err("ib_create_srq failed: %d\n",=20
> PTR_ERR(sdev->srq));
> 		goto err_mr;
>         }
>
> and report what that prints?
>
> Also, does the userspace test program ibv_srq_pingpong from=20
> libibverbs
> work on this system?
>
> Thanks,
>  - R.

--=20
Best Regards,
Alexey 'Alexxy' Shvetsov
Petersburg Nuclear Physics Institute, Russia
Department of Molecular and Radiation Biophysics
Gentoo Team Ru
Gentoo Linux Dev
mailto:alexxyum-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
mailto:alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org
mailto:alexxy-heEE5zn7HfaV8fSEjHp0FA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
