From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: ib_srpt and mellanox mthca device
Date: Wed, 11 Apr 2012 18:24:11 -0700
Message-ID: <CAL1RGDXT1gshgxA+c9M==zxarKnjKZtcy4dROtOnKVmc9+u9HQ@mail.gmail.com>
References: <5f95768153388b91a2ffa0cd118d7ad8@omrb.pnpi.spb.ru>
 <CAL1RGDWNqMdQGrXbh2gj==_KvVRF1mUQw2D3NqEhjvuq2q2+6Q@mail.gmail.com>
 <97cccba5ba7ddc74e87b0791050fa755@omrb.pnpi.spb.ru> <CAL1RGDVbqOQP+AH4f9cs+mEngXVTOy7r7gRjJ=SU_rMmvCg3Qg@mail.gmail.com>
 <fa3a67e9423946c0bbd23abb3f60921a@omrb.pnpi.spb.ru> <CAL1RGDVn1Roo-KaZW_r_WAQudbEZ2+mXD2RqNS68Rg=UBTRe7Q@mail.gmail.com>
 <806c99edea592c69d0aa9073bae2a3b9@omrb.pnpi.spb.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <806c99edea592c69d0aa9073bae2a3b9-heEE5zn7HfaV8fSEjHp0FA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> I tryed this patch but it doesnt work i still get
> ib_mthca: Initializing 0000:4b:00.0
> ib_mthca 0000:4b:00.0: irq 49 for MSI/MSI-X
> ib_mthca 0000:4b:00.0: irq 50 for MSI/MSI-X
> ib_mthca 0000:4b:00.0: irq 51 for MSI/MSI-X
> srpt_add_one(mthca0) failed.

Hmm, in srpt_add_one(), where it says

	sdev->srq = ib_create_srq(sdev->pd, &srq_attr);
	if (IS_ERR(sdev->srq))
		goto err_mr;

can you change that to

	sdev->srq = ib_create_srq(sdev->pd, &srq_attr);
	if (IS_ERR(sdev->srq)) {
                pr_err("ib_create_srq failed: %d\n", PTR_ERR(sdev->srq));
		goto err_mr;
        }

and report what that prints?

Also, does the userspace test program ibv_srq_pingpong from libibverbs
work on this system?

Thanks,
 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
