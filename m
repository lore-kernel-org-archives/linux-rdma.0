From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v4 iproute2-next 1/7] rdma: update rdma_netlink.h
Date: Sun, 1 Apr 2018 13:47:55 +0300
Message-ID: <20180401104755.GG22232@mtr-leonro.local>
References: <cover.1522359537.git.swise@opengridcomputing.com>
 <8b0ef68809c44e8d92d47a7bf95a69f2d9743407.1522359537.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8b0ef68809c44e8d92d47a7bf95a69f2d9743407.1522359537.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 29, 2018 at 09:10:30AM -0700, Steve Wise wrote:
> From: Steve Wise <swise@opengridcomputing.com>
>
> Pull in the latest rdma_netlink.h which has support for
> the rdma nldev resource tracking objects being added
> with this patch series.
>
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  rdma/include/uapi/rdma/rdma_netlink.h | 38 +++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlrAuNoACgkQ5GN7iDZy
WKehkw//RXCSiiP2Fjpdg+8e3tsI7SrRxzcdK3P0vpqktbEFhZ7QIFLNGwU1ylZA
TcMdZtKiJZRVJrgL76K2ubvqUCJ8P5uvjUPVj3UIUI2lANi8m5dhbY2swrLad9y+
i3F64VpPqS+K3VnGTA4oU/u9lvIi1nNhKBcBYoYnlLItCqF9HoO8GX+6kaL+hrKK
r2d1rFbVSkqOXIGzl0vVX/Kp0ikyTZdZ03hiRLWUg1Za3cqL72V4UHn/OIxG/rGD
zg6ke7uLvTPPx8eP1KTlHKqOwo9VQnp5pkMKyfK4iby/k+MIyMccvFUp68/PYp6d
mrZY18Ucpvt3CGsJwm/Tf4xOyuioBWslMS5MBlZwaaKHebAA6fIZkRc+KOGQEvlm
3OH496yXTV23l1jzJd6zs77Jqx9FAzUEOOVRkEEhtC5p05HKL4x48BB6fkcNFtSu
TdrPNog/y9kbL0AHgvMYrwG5J8edfVavJSHvYXV2ovEuRvQ3GAqtX3S5Z60tgW2U
sCKWysAZyVnZsZ78d9XGkr9tcjQHAzhGaOKpPw3FeL5OM8StvFR2xkFj5ci716QY
t7V77zTo9Vb860eviF2jsMlJIvmOt0TedyDXvwahYNcs8Z7NV7CiU+UUu25mUCc2
kSgzMcNsJde37cF3PR/+A8TI2Z57khqs6VfWcSUqJpvcEAJ2HYg=
=EOnr
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
