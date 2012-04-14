From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: ib_srpt and mellanox mthca device
Date: Fri, 13 Apr 2012 18:27:17 -0700
Message-ID: <1334366837.12540.16.camel@haakon2.linux-iscsi.org>
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
	 <273131eb997f295f6b1f3d103a7013d4@omrb.pnpi.spb.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <273131eb997f295f6b1f3d103a7013d4-heEE5zn7HfaV8fSEjHp0FA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2012-04-13 at 11:47 +0300, Alexey Shvetsov wrote:
> Hi Nicholas!
> 
> Sure i'll post init.d for gentoo.

Thanks, I'll look for your patch.  :)

>  Also there is question about lio* and 
> related libs tarballs. Where i can find them?
> 

configshell/rtslib/targetcli will generate a release tarball from doing
'make release' with the respective git trees.

The lio-utils.git tarball is generated while making a rpm or deb
package, but currently does not have a method for 'make release'.

As Andy has done with this tree, we will end up merging the necessary
init.d/python pieces from lio-utils.git directly into the targetcli.git
tree in the near future and deprecate lio-utils.

--nab


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
