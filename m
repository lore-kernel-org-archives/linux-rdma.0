From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] verbs: Change the provider library file name suffix
Date: Thu, 10 Aug 2017 09:47:36 +0300
Message-ID: <20170810064736.GQ1423@mtr-leonro.local>
References: <20170809215400.GA6921@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WU3I8Do+sziGY3UL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170809215400.GA6921-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WU3I8Do+sziGY3UL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 09, 2017 at 03:54:00PM -0600, Jason Gunthorpe wrote:
> This should have been changed when the private provider API was
> introduced..
>
> The intent of the 'rdmav2' suffix was to indicate the provider is ABI
> compatible with the libibverbs loading it, with the new scheme the only
> providers which are compatible have the same ABI private version.
>
> Change the suffix to be rdmav15 to match the current private version,
> and set things up to be able to track the map file/etc.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  CMakeLists.txt                   |  5 +++++
>  buildlib/check-build             | 36 +++++++++++++++++++++++++++++++---=
--
>  buildlib/config.h.in             |  1 +
>  buildlib/rdma_functions.cmake    | 10 +++++-----
>  debian/ibverbs-providers.install |  2 +-
>  libibverbs/driver.h              |  7 -------
>  libibverbs/ibverbs.h             |  2 --
>  libibverbs/init.c                | 13 +++++--------
>  8 files changed, 48 insertions(+), 28 deletions(-)
>
> This will help Steve Wise out in his goal to make out of tree provider
> modules..
>
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index 617b3f5b01b077..2324cf49aff5a8 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -45,6 +45,11 @@ set(PACKAGE_NAME "RDMA")
>
>  # See Documentation/versioning.md
>  set(PACKAGE_VERSION "15")
> +# When this is changed the values in these files need changing too:
> +#   debian/libibverbs1.symbols
> +#   libibverbs/libibverbs.map
> +set(IBVERBS_PABI_VERSION "15")

The overall change looks fine to me, but the lines above worry me - Additio=
n of new "set" instruction
can be prone for errors, because it is not clear when it should be updated.

What do you think if we update it automatically?

Something like that:
=E2=9E=9C  rdma-core git:(master) =E2=9C=97 grep -e "^IBVERBS_PRIVATE_" lib=
ibverbs/libibverbs.map | cut -d'_' -f3 |  awk '{ print $1}' | sort | tail -=
n 1

Thanks

--WU3I8Do+sziGY3UL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmMAYgACgkQ5GN7iDZy
WKf9ABAAxY12LQF0lHFjlVPHLLip+MIR+8tIKex6WqlXxOilxpScpB8i5USxJhN5
sWqXtmRjcOfjnOOYerwK39vPoIKRGJjqpJm0GYfC1eELKTD9dQ1iRqc+eVOYkSBP
jEqOyoVDRORfGnSlhchoCX0VZk2b9R21amUpZtKQwiTmnJdg3qmQEM50a6zy6Toh
vG6JZElN7dVoHhHXEZBqG7iDsSxxp0rj6svexs3cUopamw6Z/AUhgSidaEd/lDMP
bF71SPujDkSNvg60nV4snkidjrL9TpuEkaEN+4RiiYhcblnnUo2isNFEK7/r7qbV
e56V0cBQGryHURyDG3AeIkV8CiwVn2zjXTtsHRSnpdTpfGbDPcYVI1u7VlrI3Uxz
ZwuYBB3bxJv3ltLhfCeDmhPoavlBb3QPZcVcoNP7KBFFUpc4Y1eBuPkgy9NsyEIo
T+qISSFzyrqcOwMWlSTw6nzqDs7Fr96ndFg3HsY5AlJGGsszMjtV1Myn6eFCU3A/
8NaOUu5aQEY/gc7NKkv7CFJW7lqX8z3bzgd2cf9uQEtPJHvfl8h/ilfXjtUyyW8W
VpJL1K8kTdM3nDiapqeuGboD8M40eA0FMEw8QY80RBfjswgsBBrnYSCatJAdf0gR
jSFvSjmWMJw3vlz2/qXO4Glb0hJm93OHaZuRrPjabetk0TKd8zo=
=ThdC
-----END PGP SIGNATURE-----

--WU3I8Do+sziGY3UL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
