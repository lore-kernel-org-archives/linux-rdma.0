From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH 05/13] IB/umem: update to new mmu_notifier semantic
Date: Wed, 30 Aug 2017 09:13:45 +0300
Message-ID: <20170830061345.GA26572@mtr-leonro.local>
References: <20170829235447.10050-1-jglisse@redhat.com>
 <20170829235447.10050-6-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170829235447.10050-6-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-rdma@vger.kernel.org, Artemy Kovalyov <artemyko@mellanox.com>, Doug Ledford <dledford@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>
List-Id: linux-rdma@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 29, 2017 at 07:54:39PM -0400, J=E9r=F4me Glisse wrote:
> Call to mmu_notifier_invalidate_page() are replaced by call to
> mmu_notifier_invalidate_range() and thus call are bracketed by
> call to mmu_notifier_invalidate_range_start()/end()
>
> Remove now useless invalidate_page callback.
>
> Signed-off-by: J=E9r=F4me Glisse <jglisse@redhat.com>
> Cc: Leon Romanovsky <leonro@mellanox.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: Artemy Kovalyov <artemyko@mellanox.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  drivers/infiniband/core/umem_odp.c | 19 -------------------
>  1 file changed, 19 deletions(-)
>

Hi Jerome,

I took this series for the tests on Mellanox ConnectX-4/5 cards which
are devices beneath of this UMEM ODP code.

As a reference, I took latest Doug's for-next + Linus's master
(36fde05f3fb5) + whole series.

Thanks

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmmV5kACgkQ5GN7iDZy
WKe2YQ/9EF+XXUYz7ntKUCKJISQ1Ys7lDOcg6ejNNRKL/8BSTvy+TZnHpJAwohpx
wh2yQ19Sb1v5WSOqm8XgYfYDp5tnultmLFgZnV4XgPuJ62D4RovI5lULKDOqXkXJ
DNqSPIP6VS0dZfO4T5IdaXAOyZ5pCxgM4fhAFH2nrfft/PoIxRcB0NKSwxcviC/s
C6vs3GJGvFfJ++HsuUo6Rfil8/RDfU12aoLAVccSOuIPMIvm4XlzpZOoNeOOLymL
Uh8mYog8m4L0t8OpD2XABqhYgHLPQZMdyES3Bp6lW7iaiXJ88GsgJz7UW1X1j1l2
eCdqzA0QkPwuh9MURZ8KH8vwyEm+W5aOLmjy+GnVURrwK7gZ+ewHzGQlgcx/ZEfE
T4j1aTHjLU67eHAhZ+886Y9qEuem4DyIOswqADg96LSq42Y1XtO23FAcSMTk1MEO
CJN8FeA1mqRKn7A7K59PDS7SU+1NDejVX1pUJQGLqzrMKcLwjezNC0nCXrjUezCC
Pi2TMcn65H2Fs057jPKIT1xqBzRa+DJ++HV0smnoWANwa8jVv19GcUQS4PzmTFcJ
a0NWwofSLr199e/Z87o6yI1vVNtK07DFEJlUQr3zAIYkVATe99q7hCnWPKActHW0
onOhsJR8dpjm0pE31oJyQt2hXGVjdECRN4g+c9P6r1Pm67/fXMA=
=pTRo
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
