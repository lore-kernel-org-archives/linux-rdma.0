From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 4/5] RDMA/iwcm: Remove useless check of
 nelink client validity
Date: Tue, 13 Jun 2017 10:28:53 +0300
Message-ID: <20170613072853.GN2576@mtr-leonro.local>
References: <20170611083931.13686-1-leon@kernel.org>
 <20170611083931.13686-5-leon@kernel.org>
 <20170612183726.GB12152@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FnOKg9Ah4tDwTfQS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170612183726.GB12152-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--FnOKg9Ah4tDwTfQS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 12, 2017 at 01:37:26PM -0500, Chien Tin Tung wrote:
> On Sun, Jun 11, 2017 at 11:39:30AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > RDMA netlink implementation guarantees that supplied
> > client number is in allowed range.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> With your change to use an array for clients, it made the
> check obsolete.
>
> Reviewed-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--FnOKg9Ah4tDwTfQS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk/lDUACgkQ5GN7iDZy
WKfFGQ//c098UWA33qkTBIT3xYKvg/bs/XQH2ycf2OsEU5FTY8e+phK+CSp2bme5
ezD//4LPcqa74YVUWkTUJkGnTsAEc0LOJofA8czvDL7O+hEvdTD+wt3h2KgHWPX3
bUV/9F1m1Z4Z7Vh4yAOzjc/okXsnZUBRwOlVlPXpEr3r2J8sFbfd6pSiNYO9C1Tz
aQsoNPXz9GPZ1AJ7/G8EHQU37F2l1lzX5Pj59J5sIwUXs/HdvluRa1r+dD568VE0
SCKNlAw68yrHINkw0ro6YGkglwWCSWS03JcEAg5EjmCV1nhmmJT2DLhsHhdFOjnJ
zNJeDRAUF4CrdjKUdQStu7nCBXdTnehaCQjW3AlkdLkaPN9UywymE/ard0Web+cJ
CBQifYTNXzmaAnbkc3UESq/9+X/iD/pk3X363YF88rNO4Djfvtwtr3fxqyGI21aT
HabdWUZazUTnPHjVCvrBhlGlrBPfhsaieHLBQq0l20/WUjbufK1k+3ojKDDcMLyo
hZo0fc0oVBjVnhF1wFMCUAPire+3nDIqeLNpGPmbet0hGgVlw9XXbkf72enZLxoO
wTei5JRLo+XcQ+rHN4H+mp4YDqBYMiE8j0qiPcZ7zixZtXbcUDVguhFIQ94d4oQs
Bq1T5HhLahNGwBxRr3HWR24IZ8jWjZQ50mC60So/erWs1W3QAzM=
=KcHx
-----END PGP SIGNATURE-----

--FnOKg9Ah4tDwTfQS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
