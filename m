From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] rdma: Handle uninitialized data for
 ibv_cmd_modify_qp
Date: Tue, 10 Jan 2017 20:54:26 +0200
Message-ID: <20170110185426.GQ7218@mtr-leonro.local>
References: <1484060645-27997-1-git-send-email-yishaih@mellanox.com>
 <20170110160912.GA15493@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1y1tiN5hVw5cPBDe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170110160912.GA15493-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--1y1tiN5hVw5cPBDe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 10, 2017 at 09:09:12AM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 10, 2017 at 05:04:05PM +0200, Yishai Hadas wrote:
> > Instead of checking per field whether wasn't set then use explicit = 0,
> > go over the providers and initialize their input command by using = {}.
>
> NAK, you have to retain the compares that was the entire point. The
> issue is that the *user* input is uninitialized.
>
> All you can drop is the set to zero path because the caller inited the
> kernel struct.

I wondered why you didn't do it at the beginning.

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--1y1tiN5hVw5cPBDe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh1LeIACgkQ5GN7iDZy
WKcRlg//Qxn3Io+nJ0hUg/vY84PQJxUwT42wmWvXKP/T6d3yTAFK3hhFlvoxHuB6
XQUCHRURvpzi6iw4FetkZDUG2lYr2rna0BIZBwKU864oXm7xpaHIeO2ss/wUBFbP
w1LQj1yr8CMxblYWkSKT5fU0sYnJGBPXGEUYuBEhNnquzRxuyouIl1d879qu9G3A
ulqUZ1Q+NT/HAKg+lxB12CaCFVFS9qPQRQzTCzRXemdKm/x1Xa1c37ioCyJe6fJy
vU671sEtLavWU/Cfla3oXcPnlK+2x1tS+CcF8ndwcWcmvNOCMPJE6Q+k38oDcPcT
/zgvEfI3SY0lqtQSI4jHHp7GZ4eJ8I3cPSqFgDYazhg6ClJjIQcNUQaqmV91luso
czzkPv8J0W0f4pWR7cs3cnox6DPK7OnOHgEGAV75wGEgqLU4EtJbdbHxtb1sgfhz
oDmIawgUqeMnCR7/+GFLtUfH3AAdPaM3qVFbgWbdwWzcsAhth807qPmsa7WQcbU9
9EcSTzsA1k98LASyOQ835VjhQktMY+PayEzA9QuVIQeIVQaWB5cDAqmOXSWUQ3Na
wh7Sv8l8AcFVCrzc/I8Thacd3bhg7shBKoyKeU5wXo8n0mjs7nyUhO7fkNKwVL0S
NKa0djb1bzXjElf3QtCU/No5iJu/bK0dPHj0PRUJlrsvf6ghKP8=
=V6be
-----END PGP SIGNATURE-----

--1y1tiN5hVw5cPBDe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
