From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [for-next 0/3] Add congestion control capability
Date: Tue, 22 Aug 2017 15:32:46 +0300
Message-ID: <20170822123246.GX1724@mtr-leonro.local>
References: <1503402587-24669-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WcQ7DTTOeW3GIUV5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503402587-24669-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--WcQ7DTTOeW3GIUV5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 22, 2017 at 07:49:44AM -0400, Devesh Sharma wrote:
> This patch series is to support congestion control capability
> on Broadcom NetXtreme-E 10/25/40/50 RDMA Ethernet Controllers.
>
> The implementation exposes congestion control related parameters
> to administrator using configfs.
>

We have RDMAtool and netlink for configurations now, please use it.

Thanks,

--WcQ7DTTOeW3GIUV5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmcJG4ACgkQ5GN7iDZy
WKe2lxAAxy+bzY57/L5irPymHFqqIN+WD56Ce7g4EwLRlmrUtlv0iUVtKg7A/9Ed
75GC9UEvpF8DdUIMgOELtEL7o5oQOShaOxHrmR9G92hOD56u5WTWgeEV//e7+fmq
YnsfR4cosb6FDCCN+rz1aly5L7Zs7NSZfe8xjmwTIAcehgxHhl0TFZyf9eZKKlba
nTBY777l/CbM9KWGwcXo8izehutXbKx9tzspPKAUk8QCVdHlHTdNE74c9OP9+Wu/
5BMQwk1UwHXVW2yYzBdKWJdl3YwaZ/kwBrbP6KRu/jQvDM5f/FBW5/30rIKmpzOz
rBA7AQKMyoBHMhgBg92d1XqcRPW/CTsYAtssZPIa2VbRrFy5jUILbt+eo3VPAaVU
dNnqMQUJfwj0c07gUdK9WxF0SlqQ8U8JXroPGOsnCe4nZyC3T+RxzGlOdNQ9R5Ts
HZvOgQhFh8p/Hvs3K9nHFRYGFTPC0ECxuHabmayepVE4VIbXL/uUBxKC57SVQvST
S03dBUhV6L01fKQ0wAye6p5qMupEs5lGRk4bkGfsz9G8DAauea+EpMgxokabP/Xq
sPEA7sXPhFYB3hDuc5Yghld6NPYrbGef74L8OtjdXNUj5tineYdJIiXJbnwOkpdh
PvAVVizQNfWZHWHt9bLnPNjcGU+npgQQ8xQqj5eSeRqebD2rHM0=
=3xkS
-----END PGP SIGNATURE-----

--WcQ7DTTOeW3GIUV5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
