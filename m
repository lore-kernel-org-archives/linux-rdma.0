From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: ib_srpt and mellanox mthca device
Date: Thu, 12 Apr 2012 02:09:25 -0700
Message-ID: <CAL1RGDVh=n5rEB5GqmPaDvuNAKRkoVEro9LYr785zQpz7xR0vg@mail.gmail.com>
References: <5f95768153388b91a2ffa0cd118d7ad8@omrb.pnpi.spb.ru>
 <CAL1RGDWNqMdQGrXbh2gj==_KvVRF1mUQw2D3NqEhjvuq2q2+6Q@mail.gmail.com>
 <97cccba5ba7ddc74e87b0791050fa755@omrb.pnpi.spb.ru> <CAL1RGDVbqOQP+AH4f9cs+mEngXVTOy7r7gRjJ=SU_rMmvCg3Qg@mail.gmail.com>
 <fa3a67e9423946c0bbd23abb3f60921a@omrb.pnpi.spb.ru> <CAL1RGDVn1Roo-KaZW_r_WAQudbEZ2+mXD2RqNS68Rg=UBTRe7Q@mail.gmail.com>
 <806c99edea592c69d0aa9073bae2a3b9@omrb.pnpi.spb.ru> <CAL1RGDXT1gshgxA+c9M==zxarKnjKZtcy4dROtOnKVmc9+u9HQ@mail.gmail.com>
 <2f4564980ae4cdafdc456a8e41b4ab04@omrb.pnpi.spb.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2f4564980ae4cdafdc456a8e41b4ab04-heEE5zn7HfaV8fSEjHp0FA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 11, 2012 at 10:52 PM, Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org> wrote:
> Seems like this card doesnt support srq
> store linux # ibv_srq_pingpong
> Couldn't get local LID

Actually that message comes later ... it looks like ibv_create_srq() did work.

> PS on nodes with mlx4 devices ibv_srq_pingpong works
>
> also with yout change it doesnt report anything new

Are you sure you're actually loading the patched module?
I don't see how it could fail to print something if ib_create_srq()
fails.  You could try adding a printk() to the very beginning of
srpt_add_one() and making sure that shows up.

(That would explain why my first patch didn't fix things for you)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
