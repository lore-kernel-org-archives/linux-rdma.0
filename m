From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core stable-v15] verbs: Do not block QP attr_masks
 used by older kernels
Date: Tue, 14 Nov 2017 20:04:51 +0200
Message-ID: <20171114180451.GB18825@mtr-leonro.local>
References: <636b5412-e41e-40ed-46da-a0e83bd5b049@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8QcVNcX0nzIHQJyO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <636b5412-e41e-40ed-46da-a0e83bd5b049-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--8QcVNcX0nzIHQJyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 03:40:25PM +0100, Nicolas Morey-Chaisemartin wrote:
> At least the RDMA CM in 4.3 will give user space structs with these bits
> set. Those kernels require user space to pass those set bits back to the
> kernel. Blocking them causes RDMA CM to be unusable on older kernels.
>
> Stable-fix: Drop changes to verbs.h of the original fix,
>  that are not needed for the fix itself.
>
> Fixes: 3ca7a1031486 ("ibverbs: Add support for packet pacing")
> Commit-id: ce88cef301b ("verbs: Do not block QP attr_masks used by older kernels")
> Reported-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-uk2M96/98Pc@public.gmane.org>
> ---
>

You need to add your Signed-off-by.

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--8QcVNcX0nzIHQJyO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloLMEIACgkQ5GN7iDZy
WKekWRAAkUu0s/qehTUr6Dm4q2KREUKzDjBVYvlHqC8hyGeoMhYMFb+sUF2S5DRA
rEjm9ZrHl3YO1LkZDnvBGlqIkzRP/9moSm6NC9FRebqvvN3w0QxiBWaUxxJ1qaBa
WC9+DKKsgpycwqe72SYFNG2yUt8iuz2cuT/IJyIHY2dEuIilVUB79oJDLy6JyYic
vnvgQqxL+UuzmEJkYfFxJIA8F+KA/NeRQvGZjNIuDX71WhwHyfy3BuMgqQDxHIRB
0UhXxLXnnJeSAJptLw4xfcxq0mN68LX1RLIwSOjMaxCHhAGB8GWy9FBYiPXZI5RU
kZ7gNu0APtgqrYzpzD1KWtJYimWADwksQHV+0uEA4I0kdg+XqTffYqSF12/LUnIC
8qgS7I1s4JYgRyRUV6VjKZPD7kVUblwOn08bXUnxgoVhGCcGNC4FPanrSaqh+x6d
ra4DYB+fIWzPTNsFXI8RLmjJIhD5NXP7lXw8Q8T8+wzDVip8oXo4zzTZwsa19TOT
mDTiP+g6AVdHklFSn7syrMHysOknnThlWjKkhoZA96EymOj3mhlvD7g2T0n+6Vqf
dEb/yZ52m9EQao0gXRzFZs8ODEtLACiuJd5y0oIvqColw3b0K2n/CpjDZc5e1SWF
ElSDplexqLzEMrREbL5tWd2yTsadvehO1pPJ0uAjGWq9DNBGfKY=
=QRdK
-----END PGP SIGNATURE-----

--8QcVNcX0nzIHQJyO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
