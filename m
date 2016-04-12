From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH v1 09/18] xprtrdma: Use core ib_drain_qp() API
Date: Tue, 12 Apr 2016 07:49:10 +0300
Message-ID: <20160412044910.GC25242@leon.nu>
References: <20160411200323.20531.8893.stgit@manet.1015granger.net>
 <20160411201123.20531.75329.stgit@manet.1015granger.net>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160411201123.20531.75329.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 11, 2016 at 04:11:23PM -0400, Chuck Lever wrote:
> Clean up: Replace rpcrdma_flush_cqs() and rpcrdma_clean_cqs() with
> the new ib_drain_qp() API.
>=20
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks
Reviewed-By: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXDH5GAAoJEORje4g2clinGKAQANNNwo89c77i1+wXWIggJbmL
baij5yDQsq7dKbTjw0HYRSbyx0tQHnnkSkR92Rhr6OJC252UDHsP5DGhEskCHipV
PMY5Y3CRknz0Fuu3qXu/CYRigSAseaBz9mkdDmtUqvDG+5Rcx6+IGcDxZwdRvVUv
eLQhoemTo07+RblJZXbXMh0QTiOhDTuAAlLKqFuydkP3ZDPmUQfYD6rrw5n+Uxk6
Yv99zvdkNB/57L9qHqNq6IxALUwveKFOlAc8fiVRJS9d6RM7znGdGKbkkmjilq7R
2D2ftRhCLpjvzHeDjYUCUAuTQNLGDel/eCsiHYr5PC+nYHQVRUehaUg5Z2E+Qd19
7IVaHJ6c2atZkXibjrt+gx1s+FkHV8++/46G2e9Q85+UfnAfybab+PtW6RvrjA8U
O+J1DPo3yet9mR0XmnGoq7o8g+sMPluy5nQqridPXhepeyroNWPkDvqmDHygZzVC
TQgfmV9l4Rf/UHILJ2EbRxSA/tB5M8bp4g49i+4WXNeoFFSwuOG9n26awidnLhP4
vTAwz+IHRt5gpG4YLQo5ikHnY05Yf5fFH8DIFSDGXnVAXDuqJqrrZZvFSJ1lVPIY
JpfbaqWt8iwK6oP4B6yKU1q5LKevQdgEuIcJRtInNAf0CiueLteEAi4CDfziBjSa
tWyXkM+X7dOOFlfrG42I
=f0le
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
