From: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: ib_srpt and mellanox mthca device
Date: Thu, 12 Apr 2012 13:59:41 -0700
Message-ID: <4F87423D.8010104@redhat.com>
References: <5f95768153388b91a2ffa0cd118d7ad8@omrb.pnpi.spb.ru> <CAL1RGDWNqMdQGrXbh2gj==_KvVRF1mUQw2D3NqEhjvuq2q2+6Q@mail.gmail.com> <97cccba5ba7ddc74e87b0791050fa755@omrb.pnpi.spb.ru> <CAL1RGDVbqOQP+AH4f9cs+mEngXVTOy7r7gRjJ=SU_rMmvCg3Qg@mail.gmail.com> <fa3a67e9423946c0bbd23abb3f60921a@omrb.pnpi.spb.ru> <CAL1RGDVn1Roo-KaZW_r_WAQudbEZ2+mXD2RqNS68Rg=UBTRe7Q@mail.gmail.com> <806c99edea592c69d0aa9073bae2a3b9@omrb.pnpi.spb.ru> <CAL1RGDXT1gshgxA+c9M==zxarKnjKZtcy4dROtOnKVmc9+u9HQ@mail.gmail.com> <2f4564980ae4cdafdc456a8e41b4ab04@omrb.pnpi.spb.ru> <CAL1RGDVh=n5rEB5GqmPaDvuNAKRkoVEro9LYr785zQpz7xR0vg@mail.gmail.com> <CAL1RGDXFVTD88ZF9rWoaDpOU7PuzdPcF7PSP4Ac6icgD=FPQLQ@mail.gmail.com> <41b9ab2a9c7e7a58c7e7a5b41bf1d9e8@omrb.pnpi.spb.ru> <CAL1RGDVjhpzSDUvkpdkG8u2YPwAWmt_szUw=wb3j3=gsb-iW-g@mail.gmai
 l.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVjhpzSDUvkpdkG8u2YPwAWmt_szUw=wb3j3=gsb-iW-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/12/2012 12:17 PM, Roland Dreier wrote:
> On Thu, Apr 12, 2012 at 12:02 PM, Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org> wrote:
> 
>> Also another question. I still cannot create target with targetcli nor with
>> configfs. It alays said that wwn is invalid and seems cannot register ib
>> device. Can it be related to order of module loading. I have this problems
>> both with mlx4 and mthca device. Or may it be related to firmware version.
>> Its branded HP devices. Can I use non OEM firmware for them?
> 
> The HCA / firmware shouldn't matter, nor should the module load order.
> 
> I actually don't really have any experience setting up targets with srpt,
> so I don't know the sequence of configfs / targetcli stuff, or which wwn
> it might be talking about.
> 
> Perhaps someone on target-devel (cc'ed) can help...

I also have no experience as yet using srpt, but see this post, it may
help use targetcli with it? Although if you also are having trouble via
configfs directly, then perhaps not.

http://permalink.gmane.org/gmane.linux.scsi.target.devel/1513

HTH -- Regards -- Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
