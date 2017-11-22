From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Wed, 22 Nov 2017 18:49:07 +0200
Message-ID: <20171122164907.GD29104@mtr-leonro.local>
References: <20171121102618.31216-1-leon@kernel.org>
 <20171121102618.31216-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171121102618.31216-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 21, 2017 at 12:26:17PM +0200, Leon Romanovsky wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> For now the only LSM security enforcement mechanism available is
> specific to InfiniBand. Bypass enforcement for non-IB link types.
> This fixes a regression where modify_qp fails for iWARP because
> querying the PKEY returns -EINVAL.
>
> Cc: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
> Cc: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Reported-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Fixes: d291f1a65232("IB/core: Enforce PKey security on QPs")
> Fixes: 47a2b338fe63("IB/core: Enforce security on management datagrams")
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Tested-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/security.c | 9 +++++++++
>  1 file changed, 9 insertions(+)

Please drop this patch, I mistakenly cut it.
It doesn't contain the whole fix now, I'll respin.

Thanks

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloVqoMACgkQ5GN7iDZy
WKd04g//TnLUYXzmhKMHdvAwMPy0yXN8/M0zErdFSSHIOlo3/0z5tn12uoXmu9ze
jwG1NJrQU87x/uCP+pJvXcpwce2OI6YyFuzXHxz6yyI+BHRP2T+RQLE7uhBvLeuD
uIHRM+J4IWAbs59ox8D9KYniZ4tAkieVs/zZuZd6A/NEwJOozNKKjTO4SfREOy57
vpn1ydvG1lDnI60x0+vWxKtrvgi9ikcb7jhxQTA+E4JlIeVGoau7IuzCBUjTJGN2
gcCD5cjiU9kgDNJUXIriAsEwtF8ITR1uj5XAdD7zRTSzpl6kOX9DUvFLUUkVIAKb
oedkowv2WIA4nGwg5dwqTjXKLw2MwrcpwrzUdvcSoEl6LTvVVsLW8SVtWaU6D7r7
6f5alwd8W4rHoeISxcaDVuIBTnOvfUo7i6tA+03LTNL99wFiP1akFUsmnChm7ge1
x9YUmxcZnpfoFebkbk645NgDxnI2QZYRYtXujpnxmswXF0myVJS+/Y7X1hjmGrEI
TjaCvyBk2rjM8Nzc1ibmctsD18L6alhW2YJNfPXmkJdypoaNcbO5Ipr7LnCeky3X
GZQ8Bfa44aw0za+dQOFHJHTKYs5IskNr2bA44XchreWBsw7jHv/vvIaV5G9t/MR0
AZr678Mjv8q3S2KJiXONdW+MWzuEENNVn5sgFJu3EIgfM3PhN4c=
=Yi5e
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
