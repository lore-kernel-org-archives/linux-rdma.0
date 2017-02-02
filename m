From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: qedr and vmw_pvrdma are not packaged in rdma-core
Date: Thu, 2 Feb 2017 08:26:28 +0200
Message-ID: <20170202062628.GZ6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jiz6jV+gGMQoj4lW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jiz6jV+gGMQoj4lW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ram and Adit,

I want to bring to your attention that qedr and vmw_pvrdma drivers are
missing from various package files available in rdma-core.

Can you please send the patches which add your drivers to rdma-core
packages (Redhat and Debian)?

Thanks

--jiz6jV+gGMQoj4lW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliS0RQACgkQ5GN7iDZy
WKcJ8A/9EGGmgQ15iLJNnwVbdg/wnceQybjTR3uzg/ToXajGtvyYDPfF8ilrC0Es
T2hsxfgGMn1j0LfxmRW5Cw6Z9u3ntVR6MEdgviVokBGK8HIAbdvSYASXC2qoBtMQ
s4MUKF5O87sxME8kvmCkGpLEt2psThEKOx1PfwALRWJSkPfr2/ku+lAW7x+JJwNQ
BRUT4Y5j1vNjzDTbInHomKkwTvsAGJ4mq3U9FRJ/J8XJj6xW+YYZXZDmw3S2QB7C
umlAq+rxmJ6gyaZ4Rx+olXMsB4Sqx+sYKw/tAEAqLrBGB1KKxW42cNLKGmr/D/K+
rBny9mFpq85CPodcFZm/JkZCifo00qgotJ+kggtFLDWpuryZ7cZPMA6Nrup0X52b
w1xoPInBqTbfD6Tm5zIFUAQaYDVTCRjv7A9xLcs8SwmxvaFSG4kezeybd/L3STSv
qx6CG9tV/Mpj3RQyX7PeRZmhmc3ypVPM0VqP6zuqZ1RC0hkoI8DBNfBsVufnKUSK
/hiW6DptlL8RAohqC/HuH1rq/J1YaV66jiv948KcYGPMbvA4dDAqRnTBxPiHfAeZ
9awCwQ410FtIMD7Qack4BGEQNJ7mGv0Gyxa9uHIXwi+NgsCYN/Zpu8RN7GoPF96O
ZEyqcz0Yk1CEG4iaRyhvFFTLTPHW3DPRe74haFJoXqW/HYWTDns=
=kiYi
-----END PGP SIGNATURE-----

--jiz6jV+gGMQoj4lW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
