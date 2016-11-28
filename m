From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/4] IB/mlx4: Fix out-of-range array index in
 destroy qp flow
Date: Mon, 28 Nov 2016 10:31:07 +0200
Message-ID: <20161128083107.GB6380@leon.nu>
References: <1480252702-8005-1-git-send-email-leon@kernel.org>
 <1480252702-8005-2-git-send-email-leon@kernel.org>
 <BLUPR02MB1683B2E832867815771A4B2C818B0@BLUPR02MB1683.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BLUPR02MB1683B2E832867815771A4B2C818B0-Y8PPn9RqzNfZ9ihocuPUdanrV9Ap65cLvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 27, 2016 at 04:56:19PM +0000, Bart Van Assche wrote:
> On 11/27/16 05:18, Leon Romanovsky wrote:
> > Fixes: 9433c188915c ("IB/mlx4: Invoke UPDATE_QP for proxy QP1 on MAC changes")
> > Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Hello Leon,
>
> Commit ID 9433c188915c refers to a patch that was merged in kernel
> version v3.15. Shouldn't a "Cc: stable" tag be added to this patch and
> also to the other patches in this series?

I'm extra cautions with stable tags and prefer to finalize my stable
checker in my submissions scripts first, before adding it manually and
I have plans to use it next kernel release.

Thanks

>
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYO+tLAAoJEORje4g2clin40cP/27w0+zH+kWcVZaE43bSDTJP
wGmSEQQiUOeohexSuQb3PJb7f5Sq07z5hhALYOFEUL3YoxEbKX9kJu/YK0gMxtCi
TLXFLHJEhY/YRGpRpGfxnW4SUCaHUt5Jq9kSEsfVvi0kAQJQdf+L8ySHV3lAkIhA
Ge3uYq+jjUmmszp9wn7iF+t1NrCmBj6fJFvES/bp+251/Ikf4toN8JVf//LHeEQC
mKPVyRJt+H2zP5UEtctFmVvegi7/w/yQoWsulZ26Zkx6gAQiIVKD6vT3As0QeL7j
e0Ddc0v+lNJFXpGvQYQRlAKGyxz765XtkDsWz2PthM1flBPAZybNHwD8YYTHUZLD
laE0vloA+7UL9kQ6wDtVhRqJblDofPT8QB3ctX7efoC6w4YrY5Mj5o/h+WBkxNuW
COU6By58VSyF15JPlVtX1MaLHXBNFUOlubEeElF7UDjDgXj7JPCYfa24mxUNoquB
oICfU6IUvvmuWvkWKvZ0AkezIltLiLJgu5S7y/sgDGH/Hh3y2J24ebx7cvTBixJC
zKGbGJDYA6NDZqtJz0ZgZvKUrJfHdn8U1nLWmpo4pnRfUnjcqKjoFZnIuVjEQas5
wpeypP8jcoRpxyNoF9LOmhHUZoxwaOkdt6jYIGYQ3dk+RriWVMGHVTU0o/BK4jvU
NhCMUCLLVdY78FNdKgP5
=wBMu
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
