From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/5 for rdma-core] Five rxe_cfg patches
Date: Mon, 10 Oct 2016 07:02:05 +0300
Message-ID: <20161010040205.GE9282@leon.nu>
References: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="p//XFgTqeVWI1epd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--p//XFgTqeVWI1epd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 07, 2016 at 11:37:43AM -0700, Bart Van Assche wrote:
> Hello Doug, Jason and Moni,
>
> These five patches is what I came up with after having had a look at the
> rxe_cfg source code. It would be appreciated if these patches would be
> considered for inclusion in the rdma-core repository. The filenames of these
> patches are:
>
> 0001-rxe_cfg-Use-Perl-functions-instead-of-parsing-the-ou.patch
> 0002-rxe_cfg-Initialize-rxe_mtu-even-if-ibv_definfo-fails.patch
> 0003-rxe_cfg-Do-not-suppress-stderr.patch
> 0004-rxe_cfg-Remove-dead-code-from-show_module_status.patch
> 0005-rxe_cfg-Use-printf-instead-of-using-a-loop.patch

Hi Bart,

Thank you for investing time, Moni started to look/test them and update
us on the result.

Thanks.

>
> Thanks,
>
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--p//XFgTqeVWI1epd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX+xK9AAoJEORje4g2clinvxMP/09WLWf1KpqeBqCY30qOpU1E
X7Quec/Nzhcv+2dnZ2ZVBU/fNdmhTB+IY7wxLpdWTY9W7q9u4AG1j1JVDv6Fzo0g
mjhww4o6dsUhsSCGiTrPFX9wHekRo1Aq+ojusjYLvxDKbgoOoccOpJ7eEEU4Ej6p
oAVc7nmnniJHF9GfbW6kqMrHpX3w0p4eUUZ3bO3GvIvyjaKltT7fYGI6bEY8Gk+R
MGa1GGMKrgANtGZEjvR35sJmUtpOms3sbMQSlibxtrVBBOxd3ImmfM1SJ3/2jOZg
a1xYh8bSRvgL5qOcwQ1eBlyGdPCbRFaFxtedwKZ7nNGPUq3dh13cllX/6CGpW6UP
Jk9AAactf6TW2iso5lg5jJZNamnh80TzALZdUUeOeZTd34yNiNmJ43D762YlMiU4
eSVYnqozY0QnJ50itQFDkEpDJQpYWY2psmC/YCcUP9oxKX4aNTOVCOJzIkKi/OYg
BaUNEvzmTdAnJiszzZS3rlFO5CaoObXlJMe7E3GWpgeAAfwDE0W1XkV1Rxqwi9Yq
3c1oOFFhmBxUhnXQrHA89oTtCkqqs5vr6wxDOU+LocgTh+8idUOczHrKihwoOURF
E/YQEDSWhhuIHuSvic1+h80qJPkzzS5o3o8NvSF+2cMNonP7sWvwNOLK2GYrObAd
meFASmgfAmtrfs0tL/DD
=fn7Y
-----END PGP SIGNATURE-----

--p//XFgTqeVWI1epd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
