From: Roland Dreier <roland@purestorage.com>
Subject: Re: ib_srpt and mellanox mthca device
Date: Thu, 12 Apr 2012 12:17:22 -0700
Message-ID: <CAL1RGDVjhpzSDUvkpdkG8u2YPwAWmt_szUw=wb3j3=gsb-iW-g@mail.gmail.com>
References: <5f95768153388b91a2ffa0cd118d7ad8@omrb.pnpi.spb.ru>
 <CAL1RGDWNqMdQGrXbh2gj==_KvVRF1mUQw2D3NqEhjvuq2q2+6Q@mail.gmail.com>
 <97cccba5ba7ddc74e87b0791050fa755@omrb.pnpi.spb.ru> <CAL1RGDVbqOQP+AH4f9cs+mEngXVTOy7r7gRjJ=SU_rMmvCg3Qg@mail.gmail.com>
 <fa3a67e9423946c0bbd23abb3f60921a@omrb.pnpi.spb.ru> <CAL1RGDVn1Roo-KaZW_r_WAQudbEZ2+mXD2RqNS68Rg=UBTRe7Q@mail.gmail.com>
 <806c99edea592c69d0aa9073bae2a3b9@omrb.pnpi.spb.ru> <CAL1RGDXT1gshgxA+c9M==zxarKnjKZtcy4dROtOnKVmc9+u9HQ@mail.gmail.com>
 <2f4564980ae4cdafdc456a8e41b4ab04@omrb.pnpi.spb.ru> <CAL1RGDVh=n5rEB5GqmPaDvuNAKRkoVEro9LYr785zQpz7xR0vg@mail.gmail.com>
 <CAL1RGDXFVTD88ZF9rWoaDpOU7PuzdPcF7PSP4Ac6icgD=FPQLQ@mail.gmail.com> <41b9ab2a9c7e7a58c7e7a5b41bf1d9e8@omrb.pnpi.spb.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <41b9ab2a9c7e7a58c7e7a5b41bf1d9e8@omrb.pnpi.spb.ru>
Sender: target-devel-owner@vger.kernel.org
To: Alexey Shvetsov <alexxy@gentoo.org>
Cc: linux-rdma@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 12, 2012 at 12:02 PM, Alexey Shvetsov <alexxy@gentoo.org> wrote:

> Also another question. I still cannot create target with targetcli nor with
> configfs. It alays said that wwn is invalid and seems cannot register ib
> device. Can it be related to order of module loading. I have this problems
> both with mlx4 and mthca device. Or may it be related to firmware version.
> Its branded HP devices. Can I use non OEM firmware for them?

The HCA / firmware shouldn't matter, nor should the module load order.

I actually don't really have any experience setting up targets with srpt,
so I don't know the sequence of configfs / targetcli stuff, or which wwn
it might be talking about.

Perhaps someone on target-devel (cc'ed) can help...

 - R.
