From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/isert: Properly release resources on
 RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Mon, 29 Aug 2016 16:05:18 +0300
Message-ID: <20160829130518.GE594@leon.nu>
References: <20160829114549.6635-1-rajur@chelsio.com>
 <ae587bf0-3dd0-6e38-c589-565c6dcbcf2b@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="p1zxN+PsucbyOM2v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ae587bf0-3dd0-6e38-c589-565c6dcbcf2b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--p1zxN+PsucbyOM2v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 29, 2016 at 03:58:54PM +0300, Sagi Grimberg wrote:
> Thanks,
>
> Doug, can you queue this for 4.9 please?

Sagi,
Why 4.9? It looks like a good candidate (fix) to be in 4.8.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--p1zxN+PsucbyOM2v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXxDMOAAoJEORje4g2clinvjwP/0eWEx8D8piYya/cr7pG9yAq
zZchnk/m+xCjaQHote0JUZYpsYEWpK2vcYxml1fSG44Otcve+wZ9uISCvfJqJkMt
J1gbNsSyelsiPl3JxtgzQwNJ9oHVGSGBNymye1WnlMOD0DQmqWN6HM/f6cfMq6QA
5cygTgKDCzeaUTxVdeF9ZIfsHhkJYA9v+sg3n2afPs9Hcub0DP4pUm1ua3c15MeK
9MaVDrYuS/7kaPUUyDvja2psGIHzyvQQwuur1LSjL3YaT7+4AF9LmPhEKVsIl2a4
XiJ8FBb/Kw8+ilFKyI+A7PTlBOHf8vHj8vvBeuEpuGWNohhsYgZ34wWuZOdfkLYT
DMWdTnwa54/qLQt8Ygc6IAN8DIznLRaBn+9OnMkNP5Jnj1NNp3s3kJOZiW8UVwJ/
4OeHEbpbQhJtn0mQ+UVeSPkerlywnPbQ3nEtigc2A1UOCH9EIXR5Le/i29kWXS5g
ssPaeLl2s6CSqurPrmRS9Z4WtnBCpYwHLsrf7xJixVIJBpNwtogBDcyr+ab27e4+
o+/+OemyAsEmq3z2SKe/50cEysoVFV6HNfWWBx2jjhqHCuXgO8fPkGZKV2D8ey5g
nvk/nHPm4Nq67d3djYQB/BCz8BQHsDcpmgRTefTWZ0CD59EyweKoOinqDAGwnwgs
wsOFwUaeRP1vEosyTLB6
=WrIN
-----END PGP SIGNATURE-----

--p1zxN+PsucbyOM2v--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
