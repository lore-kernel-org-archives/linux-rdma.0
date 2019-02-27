From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [RFC v1 13/19] RDMA/irdma: Add RoCEv2 UD OP support
Date: Wed, 27 Feb 2019 08:50:56 +0200
Message-ID: <20190227065056.GC11231@mtr-leonro.mtl.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-14-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="96dIhm/ZjrNld+BP"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190215171107.6464-14-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org


--96dIhm/ZjrNld+BP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 15, 2019 at 11:11:00AM -0600, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
>
> Add the header, data structures and functions
> to populate the WQE descriptors and issue the
> Control QP commands that support RoCEv2 UD operations.
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---

<...>

> +#define IRDMA_UDA_QPSQ_IMMDATA_M \
> +	((u64)0xffffffffffffffffULL << IRDMA_UDA_QPSQ_IMMDATA_S)

Both u64 and ULL?

Thanks

--96dIhm/ZjrNld+BP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcdjNQAAoJEORje4g2clinWswP/2QNWjZLDmkDvVpZbm8jDyPS
sO5bKtlb/wQ1kQkmB20pNNzWf5XCW87rF9KmfqZxllwRmMsLzTuNPLv4ely0Z/o3
Y6XEC4plpvw6W7FbUShrkQqXbL0EznVs9PiXarqnqjui+baN1KOWGK/ICod0odnk
B4ysjfE9gZY1lIcboTyBgj6UgV6ucsR9vz9fuL2c05AYJtanvF0GT1xGfIMfJ3iZ
XDIT5frhyCokET5nyTSQmj6T6qpbBpmYsoFujcFBCJYWADxGnpsgdB0J4opbX+8l
5T8iipA0dZBMjsL+j7nW5lnOlYZlam629bcIEeWy2ssoIfG4Qny3OEo87BqDHVTV
C8ksREPk9p189B0LslGunJBscwmdTXRQzx1vqfGh/khwZzYhDyNXcMppEeH1UqhT
TpwL4/qXkew200W1jHi+z3YL+ww4VJb/z+E9UTJ3WmM31DUyy77MTHvHneVnUvQy
w7YTunH7ULeJYUaHGIgOhAZHlAu/5/HC5E2JVxYMGrXL3qStPNzvna1/FKrzKJhL
VdzpmfY6NnHteAkSp0JbmIypAJxuo4RDyVcqhc4GsSm9Bmuyuqry0fxeDsPa/hW9
VoBS4G2OfNPUUDySowr75Db9WMqMN5kj5sZSPhP4dmNoz4CLbcTBYD9Vioq1pVp0
r1acJsEz00pAxUxo2a4R
=wiU5
-----END PGP SIGNATURE-----

--96dIhm/ZjrNld+BP--
