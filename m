From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/cma: use strlcpy() instead of strncpy()
Date: Fri, 12 Jan 2018 13:43:17 +0200
Message-ID: <20180112114317.GL15760@mtr-leonro.local>
References: <1515743765-116090-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7AwgMNpd3VkAVXjS"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515743765-116090-1-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
List-Id: linux-rdma@vger.kernel.org


--7AwgMNpd3VkAVXjS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 12, 2018 at 03:56:05PM +0800, Xiongfeng Wang wrote:
> From: Xiongfeng Wang <xiongfeng.wang@linaro.org>
>
> gcc-8 reports
>
> drivers/infiniband/core/cma_configfs.c: In function 'make_cma_dev':
> ./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
> bound 64 equals destination size [-Wstringop-truncation]
>
> We need to use strlcpy() to make sure the string is nul-terminated.
>
> Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
> ---
>  drivers/infiniband/core/cma_configfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>


Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--7AwgMNpd3VkAVXjS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpYn1UACgkQ5GN7iDZy
WKfDuQ/7BFrfC3FVM53JVGsNt+qZ0/sABxoZvGuxQSpT99k0j6coDasL+EErNzZw
69+6whGbFhtgygH2aFR5Ouc9+JXwiF9NrxqaHrQScgGjUOGvuBp3BNNkAVqRA3Oe
7wru3ZqxjkHhpQSKH+XuedVFv0v0Mg0xkgB/mlbEor2NY5ZeR/FF805p+jT9nrjR
ApbJu7idny+ptZFKPovO0MUojjvtGG9DUr7SlWjg5b/06DGx8jTbzVzIL6dLjqs4
Imo50ASOvz9U3tCR911s/WYMfBCligeo6kWG76uCAoesYfkXCGf16PYvb1W3KPoC
oY3yhsfyn9u51QazCMbTL5mxHFCxxHhjziEchDqPpXaLwLhA9I6YCc7hlI8Hb382
be57FjC5UQWPGO0YbCgey6be5/N+YR0SMPUh3kIfQrKqE8F2x+RBATwnxV6tMAEV
uM8MG2nruBpW7qQNRXwg3IwnWT67gbjYwsUWXNs/Irimde9/gF/nj/1uXUyqK8hl
SNsL20YIx/3ogSoYSHtjQCQi8GjKGDj983TRpI3LsRjFouNwLpbN5FtaG6PB4fVS
dZb3jgMoliZUmYTJeCyQLY2uN2xA/Qk1L7lZOpYg65QM3CqGlsppaYG86u7OH9bo
Za+l/ltqU3PpysHETJQ3qbhLLDi7lK1Q3CjetgBRsneUSZi4P2o=
=o5lE
-----END PGP SIGNATURE-----

--7AwgMNpd3VkAVXjS--
