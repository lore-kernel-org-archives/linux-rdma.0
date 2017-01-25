From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/cxgb3: header should be defining CXGB3_ABI_USER_H
Date: Wed, 25 Jan 2017 18:42:40 +0200
Message-ID: <20170125164240.GP6005@mtr-leonro.local>
References: <20170125144849.10894-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Vy1A5eXR7jld12ZH"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170125144849.10894-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Vy1A5eXR7jld12ZH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 25, 2017 at 02:48:49PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Fix typo in header guard macro, is currently CXBG3_ABI_USER_H and
> should be CXGB3_ABI_USER_H (B and G are swapped).
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Doug had similar fix already in his tree queued for 4.10.
https://git.kernel.org/cgit/linux/kernel/git/dledford/rdma.git/commit/?h=k.o/for-4.10-rc&id=b1a27eac7fefff33ccf6acc919fc0725bf9815fb

> ---
>  include/uapi/rdma/cxgb3-abi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/uapi/rdma/cxgb3-abi.h b/include/uapi/rdma/cxgb3-abi.h
> index 48a19bd..d24eee1 100644
> --- a/include/uapi/rdma/cxgb3-abi.h
> +++ b/include/uapi/rdma/cxgb3-abi.h
> @@ -30,7 +30,7 @@
>   * SOFTWARE.
>   */
>  #ifndef CXGB3_ABI_USER_H
> -#define CXBG3_ABI_USER_H
> +#define CXGB3_ABI_USER_H
>
>  #include <linux/types.h>
>
> --
> 2.10.2
>

--Vy1A5eXR7jld12ZH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliI1YAACgkQ5GN7iDZy
WKeKIA/6Auc9anGVbskn5A7n8vWLnm5fPB3j6bcoDqcC85fFiyRL1m7sNn1+0+aa
0Aun/SmeM+W+1RvfeOi1fit512guRJv1nep5OcqRVJOBUhiQGVnTywBuH6XdZjOy
4gcstwukTo1u3MXOEMQOdB62PqAN19/InPJvft+pFpnPblrpLGmQI19CreBcAoJ9
cVo6M9+GAczK9Z1/gUZBSAYnl/BSIAXZJYIWsJXGlabrmmIIcnvfGs0ZdjS01We/
jHvgRT8CmHEJUfudLX8JantA9FEnWT8FKHF2tZkveVI8qAaCyURX6eL0JIY3N+7Q
OgfLhyBmLrxe8MPoZE14R3ixX1zQfpMXBf8HcnizAckBAZ68WtBY4TvHAVrbxCpx
FSGxD3nN3LUbIUY5n5iCcaexzMECj+uPpH7mgMTtnqmcZDx33B7Q4bd7OCmw4Yf8
Go1qwf9pm4kEhGvigqAowEdHpy30QvCktj6EWr/4od6jYCwpHZWPu//uzYMt1gNp
GCbyvnCMbgTydFspTkQod3Asq0UJRxIYeoDFkd3yv8TC4PFGaZZU3EJQCXODBQtv
phlfiNshzOpMLJT75NAti25Q8RHbaY0/BjJEEZXo46+zOR++mE4qifSu1XtzEqPp
IJOzyy+UpUpCmpSXoc0abiEb8HMmdiCe6o4Dy7DzIfcROZdu+l8=
=tq1a
-----END PGP SIGNATURE-----

--Vy1A5eXR7jld12ZH--
