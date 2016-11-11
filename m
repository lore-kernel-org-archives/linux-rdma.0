From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 rdma-core 0/7] libhns: userspace library for hns
Date: Fri, 11 Nov 2016 15:03:50 +0200
Message-ID: <20161111130350.GI28957@leon.nu>
References: <1478840250-92558-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JIpyCmsTxyPLrmrM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1478840250-92558-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--JIpyCmsTxyPLrmrM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 11, 2016 at 12:57:23PM +0800, Lijun Ou wrote:
> This patch series introduces userspace library for hns RoCE driver.
>
> changes v3 -> v4:
> 1. eliminate the warning by Travis CI testing

It still fails.
https://travis-ci.org/linux-rdma/rdma-core/builds/175060470

Please test it locally.

Thanks.

--JIpyCmsTxyPLrmrM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYJcG1AAoJEORje4g2clinyLEQALcb38Zz/TjWz4zxpUDCscpb
55sHQu4Z3Dmuaipn6AwXGjkOnMbESfsQF91Pdn+2uk3U5CLSXwz0S65rfapdppXy
8xneqBww4WCc4OVw+mRLOLVgGWQcw81xnv77Bsshfy1BKpFhKfT1dez5Xwn0xGdo
WkIgRy1pcKtsvqlgtWR29WhLxL82rmv1hdQeMLbBsgnxLPvevOxkLSAm2AouY9VD
/a1E41/D/DgDXPeDXjf6bDQmBjDsJXLgSUTEtV8HZfxV3S0CY+9QfRPAyTIiGKpX
TRQXoNZS0beOwHhTg7fEfEiDEqsvNzypBK2icFm1GFCj4f8X7ADlrmDt79RDONEC
L5kut8hS0nxFk2PuVgdyvBVnMpkQXIyvbhh34io1dKM5K90WkfKd2UDH56mLxL4J
lpZg0F5oxnZkErcMXZrNIDbrIzSu1GL7XbscnIYlXvpyYANN2qSkESCs1EPTh3Xk
ZAkCTSR9dzRyta5cL8rE7hdAj92FUArVV2ZDfl+72cmOcXqQBysQTqQow++KbrCb
JeLeIRcK+7H+UFNEw3Q2G9MAch8ETIez8TyD4Plq5MWCuB/ov95Ev6oeuioV13YT
vBx2HZXaK8l25G6KKeqMwLpqvzfcYoT3jHUZMWKFFIWg6l5x68llEHLVxa46Rq/N
QXi9smpBKow726DRiVkH
=egJg
-----END PGP SIGNATURE-----

--JIpyCmsTxyPLrmrM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
