From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core v2] ibacm: Add systemd service file
Date: Tue, 18 Jul 2017 15:53:23 +0300
Message-ID: <20170718125323.GM3259@mtr-leonro.local>
References: <20170716152013.GC15371@mtr-leonro.local>
 <20170717094244.9253-1-benjamin.drung@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4VrXvz3cwkc87Wze"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170717094244.9253-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--4VrXvz3cwkc87Wze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 17, 2017 at 11:42:44AM +0200, Benjamin Drung wrote:
> ibacm ships only a sysvinit script but no corresponding systemd unit
> file. The RedHat package ships its own systemd unit file. Thus make it
> available to all.
>
> The ibacm service depends on sysinit.target (DefaultDependencies=yes)
> and the proposed rdma or rdma-load-modules services declare a dependency
> Before=sysinit.target. Thus the kernel modules will be loaded before the
> sysinit target and the ibacm service does not need to depend on (the not
> yet existing) rdma service.
>
> Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---

Thanks, applied.

--4VrXvz3cwkc87Wze
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlluBMMACgkQ5GN7iDZy
WKdSfBAAmTzT7CMJ1IdxcFAjJf964oX76wqTq6DRTevYBr867d9R2t4pkHmDcqni
HF3zBkgI6O+hHpXZFupU4zRXQEwj49PH49MY5LhBYh4XCXZR/+1ZGQ7U/Qloule8
rPEWPmw+sQjzqo64E0rPNvcRA1opHKVrNIuM/jwKHf2/v2hSZoYvbJ/l3e4dSoJE
yww/Dm1hoaQYMOVjvzWCaXX3lYUJ5jz+RG50xYQ3nnbPQviRrMeAQu09o/ALgTLJ
ZYdbPXxVw9zYKDBKtaEF5UJt2w7gSohqcwiGUawuF3OztV4dbBuJtwedH15TjYGs
YQblAukJmNRCJxgjm2e/vbM6PBb6Gisog2iyQK7fipo/YVhjW7cQv2sEDl5att8Y
dmawbjOaJObhHfYegYoNqGci8wxc4xYJVMQF0rPWNrfVMYmGlGjkZzDTwTqyVAw1
jjIc/eMNkc0Oin7hW2nruafvmsGxeE1G+NBxMkGWGF/jtr2X5C9ZzKv8+PF94d//
FIurUhyJ8tCanhqQzQA7UJFPatqcNp4UCWqJiKjMamxu1o0bObkuhI9ssKbIpq5N
yaGBQ5l7d+/meHqaA65xXKsRejst5+ReFJOS6Y3HLvAFv3V46DbebmhhEduOPZAw
QgEYTlRUvY3e8XAy8Db9jV5yr5gMA5mFPCJkN7pnktuszbcgk8o=
=94Ek
-----END PGP SIGNATURE-----

--4VrXvz3cwkc87Wze--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
