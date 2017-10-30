From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
Date: Mon, 30 Oct 2017 07:32:47 +0200
Message-ID: <20171030053247.GR16127@mtr-leonro.local>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
 <20170130195412.GE24466@obsidianresearch.com>
 <VI1PR0502MB30086B735FD4B5948B521673D14D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <CANjDDBhJK=s28zrdCASUVSSeem=NVRWwsHT=jWS2N4jGh2Uvfw@mail.gmail.com>
 <VI1PR0502MB300803053059AA7CC0E6DA7DD1420@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <VI1PR0502MB30087224F41436F787C4997FD1460@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171023173946.GP2106@mtr-leonro.local>
 <CANjDDBiuFYo_3Y=0oGMza1N5SGcNcgKE8y1LscYK6bc44-YxGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MgcI0aUO3vrRQI/Z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBiuFYo_3Y=0oGMza1N5SGcNcgKE8y1LscYK6bc44-YxGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--MgcI0aUO3vrRQI/Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 30, 2017 at 09:29:01AM +0530, Devesh Sharma wrote:
> Hi Leon/Parav,
>
> I have a working patch under QA to support this change. I should be
> able to push in a day or two.

Thanks

By the way, can you please do not reply in top-posting format?

--MgcI0aUO3vrRQI/Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln2uX8ACgkQ5GN7iDZy
WKcDKA/7BNAUAwgUBfQ808KG5pqb17u6U6UnGOAt8IBgCccd6B/cwtl58GxFcMGE
/pTXYUlVW6/PktAiU1thPDFy8154eapsYO5nz+iWY0LmBtS98eK4E9UWiHVBsL1L
imNblO05N0lVoYIVl+f62iXruODNWn9mSxY8jGu7SrfqP+k6KlUbcuFVYDpftDdF
maZXyPmJ8dDsmB06mxUH1t1J9KtC3T03nOWGQoLpAnKxyPbn7SunxI7lFcT0CYvu
qzelvhuYiR9uEyl0t5g0AMF8Awybn2sBdhkUwQ0mf5z+DImT4ZikZ0oI34SRXdmF
c2NizoGcATQMLaR1zqgffQ5jn9w/etAeG9x8mL8L7RN90jx15GM3LaeTk74dHaI6
+Cn+taeXWrs/Afpx6MIhOK6B+l2XQmT+1olUILuLgyYpsB5oeoXflvwPAW1SUiuf
aePX13Ie/OT6MosH0NdZ65kHcsyLoZBo6njdhV2KiQtGwMkF366etWprGL00omaO
RZgZlxrVPk5Cv0Wx7L7oMGGx0qhQqYKW+ydVAzxQlfEEonYsSJCJaR/CJ59QAWNT
jFfw0op2/BF5dz41wjzypUjY8FE5myvWeQjWFELwxM5prt+xX5dfRFD+VcKeA0mg
oMNLdKFqkcSxkKIKN7WYq5oULlaqn0bCO1K3PECXMEEr3Hw3K1I=
=IKlC
-----END PGP SIGNATURE-----

--MgcI0aUO3vrRQI/Z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
