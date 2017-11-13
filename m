From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 0/2] Bugfixes for hip08 libhns
Date: Mon, 13 Nov 2017 08:54:08 +0200
Message-ID: <20171113065408.GY18825@mtr-leonro.local>
References: <1510309253-229097-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nWqF9Q8pq9VTXuIf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510309253-229097-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--nWqF9Q8pq9VTXuIf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 10, 2017 at 06:20:51PM +0800, Lijun Ou wrote:
> This path series update the usage of two fields in cq doorbell and
> sqwqe.
>
> Change from V1:
> 1. Update commit log
> 2. Remove the third patch, name is
>    libhns: Fix endian format of payload and immediate
>
> Lijun Ou (2):
>   libhns: Set owner bit of SQWQE in user mode
>   libhns: Modify the usage of cmd_sn in hip08 RoCE userspace
>
>  providers/hns/hns_roce_u_hw_v2.c | 10 +++++++++-
>  providers/hns/hns_roce_u_hw_v2.h |  2 ++
>  2 files changed, 11 insertions(+), 1 deletion(-)
>

Thanks, applied.

--nWqF9Q8pq9VTXuIf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloJQZAACgkQ5GN7iDZy
WKcaQxAAogJn/DDe5nQBKkBX2AHVBUWLCkXkKrnoYyE/3LKXjeL9vXQug/wg4qoq
Nte4yZGgnrx6oU5wmbezhYwX2LyMXVdFAPK+aC+YyGaqU/R8YaarBpPC64ll/eSA
NimrvBOPyBTXvw0G2TVv2BjIK7ht+1oHH2C0oDetXyFN6i3dQtOXar+5YUDA+vz8
43LcFYXkzfg/31j2Uqe9pTm61qQuAeGE7pxBCYWEVhnBTBzEdxXU+GAxUiZI0zAN
R1wIH7iIBU4Wgx8zZ8voU5cnf+UZRfb9Tu7Q8dYS4u7Sv15Kir99ZaO/5QE4roiT
RCrfVFM9iHuOkecHkZr6jLmSbISKUBQeUIAXP7Q6UUcBAJvL3hnOfkWiaLcDk9Oi
dwi+J/CpsyBrMKZp0ONC09AK76PUYNwqu6tXVar0QIWuwJvQZmDlep1M/X5EkJvm
zuEutZUx56+5eOV1kM4BU8ri77GahW8wPyDF8FPjM22051VkU2IfaRbSJaWTS2He
Y+bwQVxCvvRacMZb57XvXCtCRK55LBEqGDrxPcL15uMNBTGcIfZhTseOMQkH/ghU
5JD2J+Q2BlNiitUEh4JK3MpDqRixi5bj3vqvNAypgoYsWMwyyMeTdcFDz/ijrPFu
E8gU8x/LLndX7GOhBcGlTB6SMU5MoYe+krW+6wcnyXPRQtDd9rY=
=RYL6
-----END PGP SIGNATURE-----

--nWqF9Q8pq9VTXuIf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
