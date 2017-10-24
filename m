From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 0/5] Userspace library matching for hip08
 RoCE
Date: Tue, 24 Oct 2017 07:37:42 +0300
Message-ID: <20171024043742.GF16127@mtr-leonro.local>
References: <1508812550-98920-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hK8Uo4Yp55NZU70L"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1508812550-98920-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--hK8Uo4Yp55NZU70L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 24, 2017 at 10:35:45AM +0800, Lijun Ou wrote:
> This patch series add userspace library for hip08 RoCE driver. It will
> work with the kernel driver of hip08 RoCE(hns-roce-hw-v2.ko).
>
> Change from V1:
> - Fix build warning due to the strange placement of fprintf
>

It still fails to build cleanly.
https://travis-ci.org/linux-rdma/rdma-core/builds/291891845?utm_source=github_status&utm_medium=notification

[74/190] Building C object providers/h...s/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o
FAILED: /usr/bin/clang-4.0 -Dhns_rdmav16_EXPORTS -Werror -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-prototypes -Wmissing-declarations -Wwrite-strings -Wformat=2 -Wshadow -Wstrict-prototypes -Wold-style-definition -Wredundant-decls -O2 -g -fPIC -Iinclude -I/usr/include/libnl3 -std=gnu11 -MMD -MT providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o -MF providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o.d -o providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o -c ../providers/hns/hns_roce_u_hw_v2.c
../providers/hns/hns_roce_u_hw_v2.c:40:20: error: unused function 'set_raddr_seg_v2' [-Werror,-Wunused-function]
static inline void set_raddr_seg_v2(struct hns_roce_v2_wqe_raddr_seg *rseg,
 ^
1 error generated.
[74/190] Building C object providers/h...s/hns-rdmav16.dir/hns_roce_u_hw_v1.c.o

Please use buildlib/cbuild script to test your patch series, the option "travis" will run the same checkers as I'm running.

Thanks

--hK8Uo4Yp55NZU70L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuw5YACgkQ5GN7iDZy
WKegfw/9Ei6U+Q/t9BVpwGp3YihqTjepsvS1HQnygFL7iBZV0htqy0uwRV5zEwKe
Vdeg1W0ttWDAIqf0IWrkComvNl1hptMe4O34P2IQXOKs3jIwDgxtgP9ppJLkHrEl
7i8KRN9nIUzztniwkTgD6seLk//rP8oK29txYIB1905sgJqOcRVrWm2jmCROKJJT
jnpva5jxrKiroRkkFlupAmLAMBIgsub7VZbg6uz37832o/vAwpvQpA3onnf4hRVK
cIh5N9AV3FVukDycNaJssCO8dJ8OTcxKnFER1mB2Py7j2/cjDd/pI0kF9C0R8PHo
Un7GzqQe3Rb66IcLQpzNkYs8gCqud9aXzy9amPpFahposLwDrqyOKwpbC1LsWD41
poIl4jZsSqQ6mauDyCMv76RCkxZFEaFecmDMPzd8nVZqvzt/HPFU1EwJoRe/d/08
f267dhpAaiXgvg4HKwUAroZdrJ6MKmpKiI9TM9KB963BG1qc3PkV2bjba74+Tm/8
h/UV3nYWi7jUzAEqHyKUgKiWpyknhA/nldUUMoLTwQ6syLvIPIw7JCcWZHHxUPJD
i7PFRS9iQI8GM/Fc7k6YGtZh3DjEB1JBPBmI4By7wDRDUPCU2x94Scd5FxHFk5Y5
J0CBh5VucxFt9z23VlfmlMRcS77ntUeDE7D/6pDe50K9d5NgQPI=
=MY00
-----END PGP SIGNATURE-----

--hK8Uo4Yp55NZU70L--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
