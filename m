From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [pull request][rdma-rc 00/14] RDMA fixes for-4.13
Date: Mon, 31 Jul 2017 20:15:37 +0300
Message-ID: <20170731171537.GG13672@mtr-leonro.local>
References: <20170731070924.7193-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DRp5/Sds4nAqvQzf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170731070924.7193-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--DRp5/Sds4nAqvQzf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 10:09:10AM +0300, Leon Romanovsky wrote:
> The following changes since commit 5dc78ad1904db597bdb4427f3ead437aae86f54c:
>
>   IB/ipoib: Notify on modify QP failure only when relevant (2017-07-23 10:52:00 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-rc-2017-07-31
>
> for you to fetch changes up to 38a974d578451dbbde0c40fc2d81fba44027a338:
>
>   IB/uverbs: Fix device cleanup (2017-07-30 10:43:15 +0300)
>
> ----------------------------------------------------------------
> RDMA fixes for 4.13
>
> This is cleanup series to various static checkers errors along with two
> major kernel panics fixes from from Parav and Yishai.
>
> ----------------------------------------------------------------
> Leon Romanovsky (12):
>       RDMA/(core,ulp): Convert register/unregister event handler to be void
>       RDMA/core: Cleanup device capability enum
>       RDMA/core: Remove unimplemented node_types and node transport
>       RDMA/core: Delete BUG() from unreachable flow
>       RDMA/core: Refactor get link layer wrapper
>       RDMA/uverbs: Prevent leak of reserved field
>       RDMA/mlx4: Avoid potential derefence warning
>       RDMA/mlx4: Remove gfp_mask argument from acquire_group call
>       RDMA/mlx5: Fix existence check for extended address vector
>       RDMA/bnxt_re: Delete unsupported modify_port function
>       RDMA/usnic: Fix remove address space warning
>       RDMA/mthca: Make explicit conversion to 64bit value
>
> Parav Pandit (1):
>       IB/core: Fix race condition in resolving IP to MAC
>
> Yishai Hadas (1):
>       IB/uverbs: Fix device cleanup

I'll resubmit as a fixes for -rc the following patches:
RDMA/uverbs: Prevent leak of reserved field
RDMA/mlx5: Fix existence check for extended address vector
IB/core: Fix race condition in resolving IP to MAC
IB/uverbs: Fix device cleanup

And I will move other patches to -next.

Thanks

--DRp5/Sds4nAqvQzf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll/ZbkACgkQ5GN7iDZy
WKdAehAAthCAOGcWMafpV3gHgIzsqjN5BEjICBDemrqVdUZ6LpTb7vlRMkWQ5iZv
zbD4aqL3FNrI0zZbKjN4LwgskZGyLqyXNMXJvuASaM/OG5WN/eeiv5dkRzlYiWz8
HE8gdfZnRQmQYXvhYYf8LMEcKsavKv5soDvueLIfs5/rjWgk6zSmJcgHBH5giUhR
Cd0moDmRr/trM0GPRfFMgvPxwWvBrLwOGKzokcK5vAfJJBiFb8D2495jKoXjWdu3
eM+0I0EwUJ6by6JgJ2XEIHOoTLkOCUN5MaXm1ffBR1xfKW+9xOGIVyb3u+DDR31b
Iunh17Goyd21baWg1hvO+miuE/dbJe7yz5kuulXtieA2rE+9a3LtwjXPDlPhhDQD
rSh3mq7xfysf7kLZxyuF5jItMKXN+eVd/79A6Rao+AbOUrcGQM5uiK+XUz6Y0WYd
vCzUUpu6ZCagQErITe5cf1eG8vs6jWxH3tUoMgOBNPIs+/EoKzf/cmebIRYCmWuh
ogou5CK1/MkyQN0WjjM2gv97ryXn/Kr9OYt1NLyuoRVrMlRVclTvpWye23tXOPBs
SpnDKXOnq9ljgaYlqs9c4TFet3KhRYHlqZEsRibeyhaDgu+fZXtui4QbQ+FgF727
8jpSNZJJL+eOg102KBAIo7n8HLFlm58Ls33+JSB5EU4JtnPPt5A=
=ZiqG
-----END PGP SIGNATURE-----

--DRp5/Sds4nAqvQzf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
