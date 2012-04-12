From: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: =?UTF-8?Q?ib=5Fsrpt=20and=20mellanox=20mthca=20device?=
Date: Thu, 12 Apr 2012 22:02:58 +0300
Message-ID: <41b9ab2a9c7e7a58c7e7a5b41bf1d9e8@omrb.pnpi.spb.ru>
References: <5f95768153388b91a2ffa0cd118d7ad8@omrb.pnpi.spb.ru>
 <CAL1RGDWNqMdQGrXbh2gj==_KvVRF1mUQw2D3NqEhjvuq2q2+6Q@mail.gmail.com>
 <97cccba5ba7ddc74e87b0791050fa755@omrb.pnpi.spb.ru>
 <CAL1RGDVbqOQP+AH4f9cs+mEngXVTOy7r7gRjJ=SU_rMmvCg3Qg@mail.gmail.com>
 <fa3a67e9423946c0bbd23abb3f60921a@omrb.pnpi.spb.ru>
 <CAL1RGDVn1Roo-KaZW_r_WAQudbEZ2+mXD2RqNS68Rg=UBTRe7Q@mail.gmail.com>
 <806c99edea592c69d0aa9073bae2a3b9@omrb.pnpi.spb.ru>
 <CAL1RGDXT1gshgxA+c9M==zxarKnjKZtcy4dROtOnKVmc9+u9HQ@mail.gmail.com>
 <2f4564980ae4cdafdc456a8e41b4ab04@omrb.pnpi.spb.ru>
 <CAL1RGDVh=n5rEB5GqmPaDvuNAKRkoVEro9LYr785zQpz7xR0vg@mail.gmail.com>
 <CAL1RGDXFVTD88ZF9rWoaDpOU7PuzdPcF7PSP4Ac6icgD=FPQLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXFVTD88ZF9rWoaDpOU7PuzdPcF7PSP4Ac6icgD=FPQLQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland!

Also another question. I still cannot create target with targetcli nor=20
with configfs. It alays said that wwn is invalid and seems cannot=20
register ib device. Can it be related to order of module loading. I hav=
e=20
this problems both with mlx4 and mthca device. Or may it be related to=20
firmware version. Its branded HP devices. Can I use non OEM firmware fo=
r=20
them?

Roland Dreier =D0=BF=D0=B8=D1=81=D0=B0=D0=BB 2012-04-12 17:46:
> On Thu, Apr 12, 2012 at 2:09 AM, Roland Dreier
> <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
>> Are you sure you're actually loading the patched module?
>> I don't see how it could fail to print something if ib_create_srq()
>> fails. =C2=A0You could try adding a printk() to the very beginning o=
f
>> srpt_add_one() and making sure that shows up.
>>
>> (That would explain why my first patch didn't fix things for you)
>
> Indeed, I just replicated your problem on my system and confirmed
> that the patch adding "srq_attr.srq_type =3D IB_SRQT_BASIC" does
> let mthca devices get through srpt_add_one().  I'll get ready to send
> that fix upstream.
>
> It seems quite likely you forgot to install the patched ib_srpt=20
> module
> or something similar.
>
> Thanks,
>   Roland

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
