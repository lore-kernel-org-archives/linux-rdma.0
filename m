From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V4 rdma-core 0/5] Userspace library matching for hip08
 RoCE
Date: Wed, 25 Oct 2017 15:13:58 +0300
Message-ID: <20171025121358.GS16127@mtr-leonro.local>
References: <1508926140-146813-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r7tUYVWcdYzDJoZW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1508926140-146813-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--r7tUYVWcdYzDJoZW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 25, 2017 at 06:08:55PM +0800, Lijun Ou wrote:
> This patch series add userspace library for hip08 RoCE driver. It will
> work with the kernel driver of hip08 RoCE(hns-roce-hw-v2.ko).
>
> Change from V3:
> - Remove some unnecessary cast according to cbuild check result
>
> Change from V2:
> - Fix the spelling with referred
> - Eliminate the warning by travis-CI
>
> Change from V1:
> - Fix build warning due to the strange placement of fprintf
>
> Lijun Ou (5):
>   libhns: Add new PCI device matching for hip08
>   libhns: Introduce QP operations referred to hip08 RoCE device
>   libhns: Introduce CQ operations referred to hip08 device
>   libhns: Reimplement verbs of post_send and post_recv for hip08 RoCE
>   libhns: Update consolidate repo for userspace library of hip08 RoCE
>
>  providers/hns/CMakeLists.txt     |   1 +

Thanks, applied.

--r7tUYVWcdYzDJoZW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnwgAUACgkQ5GN7iDZy
WKcOXBAAtAc0ShGDi84lg6p1HGtn/QeyVaEtBjAY2jSxkTzIbDqxfrZ9W+50V2ed
a6c+CrAUnZJTW8//Ts/5R19hEhMgHnJuuxg1UCTxnK7qcjGH5tdjJnWKqZNOrui4
E4QkuwcdBAZdZybrxWbDWrhtxDIegCtXtWG6rHgy3mhkValbdRpc6WqZ0477+2dJ
B8m7WUVi+KRot3Xh9F9WyYDvCNKL4OVFF0EBpf105yWkGEDTQmRBWyE6DQwdBg3V
X1Svk4BGx9C1EuAH1w5xkJV6yFCwv8V/vnUV4W4tnMsMkZLL6e4zkRN4rn5I4NnB
ZRYUHxMJ5Mh4TIg0sdODgJ8Aj4nD2BySirPRS28UI1OS/gSj9SyHvTF2oyCpM+9r
HuQCwyiH5mpltRZBdlcrOpLM5N5NJdGGXpyb8gEJNL7IIW+OCoK4uNDtwkmJm+NF
FDO+fPiFM5M6ZKbsrTty8J+wHhuXFRvTNmRkNhbFfSuw5iyPTYRED73yelCm5ml6
U+AmY6Hr/HLdKNHDPtjA/zyZSL7jJTuklZODhbnoLKeNVKmtMEE18DYw+WAyPnAQ
/78CPTt7zfWtvmIK7KyCX8U71sFIqwjJ9nmLIYvWaRDtWAEb8BJ0FCt1gkb5/jNB
NceEUumTqlVyDFqgPIMz/OVPuTtakq/vTt6YEgOUm7sd/ELrLZk=
=ufGg
-----END PGP SIGNATURE-----

--r7tUYVWcdYzDJoZW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
