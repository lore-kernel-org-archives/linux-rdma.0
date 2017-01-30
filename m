From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 04/11] libbnxtre: Add support for posting and
 polling
Date: Mon, 30 Jan 2017 08:43:28 +0200
Message-ID: <20170130064328.GH6005@mtr-leonro.local>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
 <1485641622-30015-5-git-send-email-devesh.sharma@broadcom.com>
 <20170129234338.GG24051@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xd7ZVmXU2EjaW0+X"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170129234338.GG24051-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--xd7ZVmXU2EjaW0+X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 29, 2017 at 04:43:38PM -0700, Jason Gunthorpe wrote:
> On Sat, Jan 28, 2017 at 05:13:35PM -0500, Devesh Sharma wrote:
>
> > +#define true           1
> > +#define false          0
>
> Nope, delete.

Yeah, It made me puzzled for a long time. Why on the earth do they need to
reinvent standard declaration available in C99?

--xd7ZVmXU2EjaW0+X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliO4JAACgkQ5GN7iDZy
WKdY9RAAxFLl+cXkii0CsxY8h81JPnMj0Ty0RLrWqXwpY9szoV1vRsbaJpoosK9c
/Godaa7gcW5qUBbAW7cqsUHjytnzI/KzvOT57k7tVGOiHp2mnV9AZxIgJYkS3CCd
b99LKgfKxH0+Tj6Mojwr/HMn6t9xW0yTbiDIZ8mnkPVujo97MeFz4E2qf2UlASkX
800iij0LUZw7Dl9sPcTXJvh2qV7J5h2uJbuZDALI0TYlatB7SYVqTH6rlfgMxnbb
AdGbTXqZ25RGGUGzQLcIIm1gZjkf8GlI1ueHy+s0sQidRx5GRA7RmnFjxnfjvjGn
QyHmjxCo9kq6WfBX5BpG57xWpcSdQYuDcNKO5Upm8SaR+Pi/yJcXaZGfGoIktngo
3H4Fjpg2HTc2zvKa1W+XaHIQ5r7tnDFlUdkHgjud6hnFlJRCE48wgg5K/dDqcAIY
TUqRvN9RCwdNCsxKdFLNjWlZHjH+aSkxbRaCo8R+iN81aMgwJK3umCTdhEw7WOde
a24iwCsRHGkxG19wRQ18RLY5nPi1+8JJMOEUbPtktreoXEepuDXGiIw+fgZ7o92J
5lxvygk4KHdOPqr10TvB9DhI6MHOomhiBzjY2OQ1Vtf+pecNNtYMC/VHCizZ4jw3
AonaWnlGnaBOmKmqTKp+DkhcSF0yxX6EiP2TMyN56h7KLC8Y98k=
=Meqk
-----END PGP SIGNATURE-----

--xd7ZVmXU2EjaW0+X--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
