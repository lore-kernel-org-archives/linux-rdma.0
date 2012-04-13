From: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: =?UTF-8?Q?ib=5Fsrpt=20and=20mellanox=20mthca=20device?=
Date: Fri, 13 Apr 2012 11:47:36 +0300
Message-ID: <273131eb997f295f6b1f3d103a7013d4@omrb.pnpi.spb.ru>
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
 <41b9ab2a9c7e7a58c7e7a5b41bf1d9e8@omrb.pnpi.spb.ru>
 <CAL1RGDVjhpzSDUvkpdkG8u2YPwAWmt_szUw=wb3j3=gsb-iW-g@mail.gmail.com>
 <4F87423D.8010104@redhat.com>
 <7d60e33d04e8dbae38f7cbf79a830801@omrb.pnpi.spb.ru>
 <1334289638.3137.4938.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334289638.3137.4938.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Nicholas!

Sure i'll post init.d for gentoo. Also there is question about lio* and=
=20
related libs tarballs. Where i can find them?


Nicholas A. Bellinger =D0=BF=D0=B8=D1=81=D0=B0=D0=BB 2012-04-13 07:00:
> On Fri, 2012-04-13 at 00:18 +0300, Alexey Shvetsov wrote:
>> Hi Andy!
>>
>> Well this were exactly this issue. Can someone commit fix to rtslib
>> git?
>>
>
> Hi Alexey,
>
> Thanks for the heads up here..  Pushed this patch into rtslib.git.
>
>> PS i have patch with gentoo init.d for lio-utils
>>
>
> Sure, please feel free to post your init.d patch.  :)
>
> Btw, we've been updating the TargetCLI wiki entries to point to the
> downstream distro packages + installation instructions for end users=20
> of
> LIO here:
>
> http://linux-iscsi.org/wiki/Targetcli#Download
>
> If you mind taking a moment, and please let me know what information=20
> for
> Gentoo should be added and will get it added into the wiki.
>
> Thanks!
>
> --nab

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
