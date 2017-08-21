From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Possible rdma-core header conflict
Date: Mon, 21 Aug 2017 15:03:10 +0300
Message-ID: <20170821120310.GL1724@mtr-leonro.local>
References: <CACTTzNa3EzABie9=h2X-ONBefyaoWE1+RAT-T+uxJVvVij15Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f54savKjS/tSNRaU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACTTzNa3EzABie9=h2X-ONBefyaoWE1+RAT-T+uxJVvVij15Rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--f54savKjS/tSNRaU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 21, 2017 at 12:24:14PM +0300, Yigal Korman wrote:
> Hi,
> Has anyone noticed that installing rdma-core (or older
> librdmacm-devel) package and then installing kernel headers manually
> (make headers_install) removes the librdmacm headers?
> I actually see it in the make output:
>
> make INSTALL_HDR_PATH=3D/usr headers_install
>   CHK     include/generated/uapi/linux/version.h
>   REMOVE  rdma_cma_abi.h rdma_verbs.h rdma_cma.h rsocket.h
>
> Am I doing something wrong?
> Sounds like the kernel rdma headers and librdmacm headers shouldn't
> sit in the same directory...

It looks like this behavior (removal of header files) was from the beginnin=
g of git era.
=E2=9E=9C  linux-rdma git:(rdma-next) =E2=9C=97 git co -b tmp v2.6.34.8
=E2=9E=9C  linux-rdma git:(tmp) =E2=9C=97 cp ~/src/rdma-core/librdmacm/rdma=
_verbs.h /tmp/h/include/rdma/ && make INSTALL_HDR_PATH=3D/tmp/h headers_ins=
tall | grep REMOVE
  REMOVE  rdma_verbs.h

Thanks

>
>
> Thanks,
> Yigal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--f54savKjS/tSNRaU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmay/4ACgkQ5GN7iDZy
WKeH4RAAjk3EvwRZAubV4aeHX+rcyl1Dp5bPqnf2AFqpsJtHHHfxAz7kXBf72GZ1
OEyeIn18wzIfi1HLHLeB/KOqxmIJ13zRCSC6MX2EBohINa95PgXdQYcXRimMdbI2
HUBovdIBmicKAus+x19v3wMCWL7b3xp0qZh1LvX+FOLmu2f5GgTUV6ak9m82TvAW
TRveduMv+ZzgEQFqkUPlEyCa+oOy0bwAlsORe2Vg05bWbqJ5yda6079HONMQWWCv
muj3OnDc7jr9OYScu7WpMQX3pEbtyCLucdqpBJIgtlRFxQ+ybdPShZJ7EMcKFZHj
GT43sN76TpaVE6o3GmCmBuBLSHMTPCKpv5kkwZrl57Zt7g+1+RrgVIz6kZ9vpHb4
ifA28b7AZVANljG6cjglKp8eCOENBDhguBj9dFmDIdHP2Hb6pnMLuC0N1k9fYia0
HBk/sIWEO7783i4nfgkxgqdCowGT5dMkL1QwrHSfRkEJ8g3FdhCylTM+e4+kDVV8
MO+7tlucTvDxJOCbo9e+bCi4WZ9t+lg7j2u2PGE2rFLzLqz0DFJjWgBNWI6IMDhh
fOZ9Efm+c1pg6Q4yH3RlK3suqVX0D6DCjtMpZx0e0qxOES5YFfN5WUVLDMP4LVS7
NA0sh39K13irujXfpiyIrqC1HGs3DnVmIw552PU1UWgL13/HK+8=
=PTFK
-----END PGP SIGNATURE-----

--f54savKjS/tSNRaU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
