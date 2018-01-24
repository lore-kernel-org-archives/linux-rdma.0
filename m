From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] libhns: Support cq record doorbell
Date: Wed, 24 Jan 2018 13:51:41 +0200
Message-ID: <20180124115141.GG1393@mtr-leonro.local>
References: <20180118043717.GC8414@ziepe.ca>
 <9e577314-4fcb-45de-6909-d5b3be570196@huawei.com>
 <20180118161949.GA18973@ziepe.ca>
 <a33a1337-665f-4cd4-5b39-b12d9f03af72@huawei.com>
 <20180119200029.GD3437@ziepe.ca>
 <68e02f2a-0474-bc73-a784-fd52dbbde552@huawei.com>
 <20180120164625.GA14372@ziepe.ca>
 <124fa0b2-ac35-a103-205b-252fddea2665@huawei.com>
 <20180123150421.GA30670@ziepe.ca>
 <91b5f324-cfaf-e778-2d6c-46000267f2cb@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KVy3XSgRgEDVTe6j"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <91b5f324-cfaf-e778-2d6c-46000267f2cb-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--KVy3XSgRgEDVTe6j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 24, 2018 at 06:35:20PM +0800, Liuyixian (Eason) wrote:
>
>
> On 2018/1/23 23:04, Jason Gunthorpe wrote:
> > On Tue, Jan 23, 2018 at 08:51:09PM +0800, Liuyixian (Eason) wrote:
> >> Could you please give me further comments on that email?  If you don't
> >> agree with what I said in that email, can you give some suggestions
> >> to resolve compatibility issue?
> >
> > You can't have a not compatible in your table.
> >
> > You need to add some kind of mechanism for userspace to enable the new
> > features conditionally.
> >
> > Jason
> >
> Thanks, I will consider your suggestion in next version patch set.

ABI_VERSION cam help you to achieve that.

Thanks

>
> Eason
>

--KVy3XSgRgEDVTe6j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpoc00ACgkQ5GN7iDZy
WKdIpQ//VL9/EU4tlnKURZG7VrJXwtZi+GG4C51/t/75jD1/UVM6ZJKKcdZL6/OA
JiMfsmSYcuJHtzcU2EZwK2/mqtwFqPy+UxIkSDV8RgPJqh8hg3DjyqXXfUil3qh0
SxPsoYKtPySNLYxDmjDVCBTOCxSTNZa1YdWH1cAKUiyydIMIPZv0NHPyLS9PfwoL
e1fNaU4dwlDPQ1jfdcmBlDpk7XBY7vyUfYORCLZXc8UhLlKrxs9laj0tUGrPQZqg
kguUU7ioIFKzdRiMyFbDysQB1RrSpg9ewwrVNoysBjh6WQzxjGklmQgUbJ1cjz8r
/yxYIbubazIVPbnMBxJ7zKKol70LDXg/QV39RtrhEwiTGzO8bKILcorTZ+MVEbtI
Cl7zaE8z1Yn9ZU3h1zi9vyrLSh9fCzbDSgDGB1uLdas35KcmrmUaYeFBZEsfqW3E
3Ug2c2ofUlko921tSJUt2toF3kLp/K+OO4+tVaJhrVkArvSGf2NXqRNocE5T2m1E
/+b8QQHpUuTdGFNA5/6HRIYP4RAfWMv7nTSd+dqPdGfgLyzU0wPXjm59gYX1KszB
01vJoRTtt2LbCSXO5LJSMTFFW1mWj3tQVJlRTgcNO9O78lZfU1Nj2S8dAl9n0okd
tln13qHKBOlOZocxL6UCFXCd73UG0oZXkfodzLZk+ghGvey80SE=
=SmOb
-----END PGP SIGNATURE-----

--KVy3XSgRgEDVTe6j--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
