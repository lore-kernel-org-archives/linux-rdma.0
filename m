From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch 2/2 v2] IB/rxe: Fix mem_check_range integer overflow
Date: Tue, 7 Feb 2017 19:02:18 +0200
Message-ID: <20170207170218.GO6005@mtr-leonro.local>
References: <8892e1d1-84ba-489b-d118-3599b9b50b0f@redhat.com>
 <20170207134431.GK11103@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7JDdbSaSV851Oucw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207134431.GK11103@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--7JDdbSaSV851Oucw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2017 at 04:45:19PM +0300, Dan Carpenter wrote:
> From: Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Update the range check to avoid integer-overflow in edge case.
> Resolves CVE 2016-8636.
>
> Signed-off-by: Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v2: I completely misread Eyal's first patch.
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--7JDdbSaSV851Oucw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliZ/ZkACgkQ5GN7iDZy
WKfNCw/9FMr/b5TMP166mmYRNPIi2AEEs1vs8dJV7RgylPMIw3kRpsP2NlP9IAoy
VPq9wzNAeV2wiTAaSBpEDdZf6sUE4nZr5q9jqkzcci1qShk6TIrkNb6zEyD7Sk0v
UyUjpREibCCKyjGXyz8/xqhgNX5rWcIlJRv2QHlFnBomOsWseaY+2RLnJ+jtrjmz
d3wlkAWPMmHSgObksPFFjnIdUKxouar8qjyq0l34InvjqvHdImMShK1vq9vJXlBK
tC/9iyx1MKVTIwbvRNnAPNlvLghsPKt/BensU/cLRjPjvmhzjAFG9c1Bj3egXHsi
RtO2P5V0bFsCCh6eSP40UzHTVNbVm0nukN9iDuJ31sk+vI1N1yx/pYxmZhD8IbmN
Eu9+F1KLWliIztWSclTTLeB4svP7u+VJBkeDnPc1vVTRJ7eQSpx4u4P2sTKKsk48
C+lz00L1m/82wZmaGEm1xU8aOKwkTNN+d68AXwg35EjAh2uXwXuyTslwa50knonr
61y2T2Ox+n4IHX0yBY+94q0m7IugnWzfKJMZFlOT9mJx71wKQTI75oU9JyYsFU5D
sG9l+EywrxWuXdASNJO+TH0tBIOboOaF+gCVZrXeEW7etntTblKzN5Db3U2AcDyK
DvOn8OkcNInbT+mq6l1bbeF2IKquWiDfk7MBmFPUcEyWytqfDfk=
=iIyZ
-----END PGP SIGNATURE-----

--7JDdbSaSV851Oucw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
