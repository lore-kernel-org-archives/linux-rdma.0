From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/4] ibacm: acmp retry issues
Date: Tue, 14 Nov 2017 20:46:03 +0200
Message-ID: <20171114184603.GG18825@mtr-leonro.local>
References: <20171114164006.24557.72093.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rKA5vZE+r0k9Fj4x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114164006.24557.72093.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--rKA5vZE+r0k9Fj4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 11:43:00AM -0500, Michael J. Ruhl wrote:
> While testing the retry mechanism for the acmp provider, I observed
> that the retry event_wait() did not appear to be working correctly.
> After studying the issue a bit more, I discovered that there were a
> couple of issues.
>
> This patch set addresses those issues.
>
> v2 - added patch for MONOTONIC time base
> v3 - Updated and cleaned various type cast issues
>
> ---
>
> Michael J. Ruhl (4):
>       ibacm: Fix an incorrect expiration check for the retry timer
>       ibacm: Calculate correct tv_nsec value in event_wait()
>       ibacm: Fix a retry loop calculation race condition
>       ibacm: Use MONOTONIC time base to avoid timer expiration issues
>
>
>  ibacm/linux/osd.h          |   25 ++++++++++++++++---------
>  ibacm/prov/acmp/src/acmp.c |   12 +++++++-----
>  2 files changed, 23 insertions(+), 14 deletions(-)
>

Can you please use [PATCH rdma-core ..] format for rdma-core patches?

We are using patchworks to handle queue and it is so handy to filter
patches in such way:
https://patchwork.kernel.org/project/linux-rdma/list/?q=rdma-core

Thanks

> --
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--rKA5vZE+r0k9Fj4x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloLOesACgkQ5GN7iDZy
WKfoDxAAr5mPKmKQ0KnuNPzpMuXVRImPHLO4ZKgaXuejPb971Uv1GwwacnW9W7I1
4wy+lwUSLeMaheSGx//ZbZiLK0y8Fk34LSp1TjTYp5FnLmt3/177XK8uB+Vajf88
+OzFjneTUSEtXjyYfne/TUR4grSSOcbVCBaUN3bpOWfvIxmTRjDMNjw05IDySIAj
/N7dvFeyJa64loZKGWVvH259pj2f/Ec+319Q7ZVji9G796WmiNFIRwPSI8Z5qWgV
5435E+OVBUQ2ngEKXSgqhj3Lw3wzKIV6rDPgipmUpRwWTXdBmAx5RRfuzV4x79lI
mcaj4zM77mCC6HyVVLBVogcl1G9DX0YydXZWxjCn24M3hIR90wSXNOknaNMgVhBF
sNH7gABN0XywjGnv8sZ53s7AKwRls5LVbsDnTaXfF2IlEHTgHDuECWv8k7PC4BFN
qFnc8GqvkJYPM5YvS0DkVJq2EAMYCqTNzstKF9vzeCLy1zyg/visacJsdR/Ya13t
1QFsLH20vvGwUpv8F0rHdQ+oCaGV09R2NVVU7k9WIKqpV7jS3JmDMkgIngDJXT+2
p55S5IZhPOcoXgMlpavvHayhdQKWKkNqWrv+9I/LiNKG2mDfkeG1EEeSPZPjzy73
bG+FnEV79xa5rkMeH84BgwhEFSvORpSBPWZASoeIuK3q/SlCnvo=
=W9Hj
-----END PGP SIGNATURE-----

--rKA5vZE+r0k9Fj4x--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
