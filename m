From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/uverbs: Check port number supplied by user verbs
 cmds
Date: Sat, 8 Jul 2017 17:04:39 +0300
Message-ID: <20170708140439.GI1528@mtr-leonro.local>
References: <23a56bbd03a2b5b585e2de35b1fc6f8bac53aa9a.1499441641.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="js+/jT5SQQin5+Fm"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <23a56bbd03a2b5b585e2de35b1fc6f8bac53aa9a.1499441641.git.dledford@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org, security@kernel.org, Yevgeny Kliteynik <kliteyn@mellanox.com>, Tziporet Koren <tziporet@mellanox.com>, Alex Polak <alexpo@mellanox.com>, Boris Pismenny <borisp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--js+/jT5SQQin5+Fm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 07, 2017 at 11:36:59AM -0400, Doug Ledford wrote:
> Upstream commit id in the rdma.git tree: 5ecce4c9b17b
>
> The ib_uverbs_create_ah() ind ib_uverbs_modify_qp() calls receive
> the port number from user input as part of its attributes and assumes
> it is valid. Down on the stack, that parameter is used to access kernel
> data structures.  If the value is invalid, the kernel accesses memory
> it should not.  To prevent this, verify the port number before using it.
>
> BUG: KASAN: use-after-free in ib_uverbs_create_ah+0x6d5/0x7b0
> Read of size 4 at addr ffff880018d67ab8 by task syz-executor/313
>
> BUG: KASAN: slab-out-of-bounds in modify_qp.isra.4+0x19d0/0x1ef0
> Read of size 4 at addr ffff88006c40ec58 by task syz-executor/819
>
> Fixes: 67cdb40ca444 ("[IB] uverbs: Implement more commands")
> Cc: <stable@vger.kernel.org> # v4.2-v4.9
> Cc: <security@kernel.org>
> Cc: Yevgeny Kliteynik <kliteyn@mellanox.com>
> Cc: Tziporet Koren <tziporet@mellanox.com>
> Cc: Alex Polak <alexpo@mellanox.com>
> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Doug Ledford <dledford@redhat.com>
> ---
>
> Modified from upstream commit: helper function rdma_is_port_valid does not
> exist in these kernel versions, so use manual comparisons instead.
>

Thanks for taking care of it.

--js+/jT5SQQin5+Fm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllg5ncACgkQ5GN7iDZy
WKfjBhAAocCtuvWPzzkeyz7B5lWy6Es7uvoigUUuBFy8RhAzIw5BTc9YdugaGBPg
wri2UvY7qOjXHQV2yYyYCDVLCwhUtyEhehuYU2X+B2mkTekqpZoLRV6mDW2n6KPW
pDQA+jLs7mf7owg3B/Qg7oAZRxW4b+qKANBRtdwlZOyL4o1Ya1qTwWR107jp+Mt1
I79+jzuGunY3kXa+JHZ29IZ+AcO80+8RnSU9ifuARX4mptlA7v3gtTyjm/F92+K6
mXE36lpTLBcyQlWtWfyhdoM+QICkMzNwf1tZxah81gYeSuvYOhK/3bHunfdOxCqv
zCg9ZxLJPwQatIrRIEqyIeyZuc8ePi3E1rJCyDncEVmBsEPj9StOqU1KBFlh3Jn/
UJmpj2ynEhlXD8N49rrZIXpi//9trs6ifcXI5j4lo/hRL5N1b6QPPbGTqsD5b1FS
7RFAyL/eBlqDecf1HGlP/W0oOIixo3AzYvVdpTUj9z2AnJQUA0ukcgRvfNTt9ezg
qQmeAXhYa5KMuaumbcU6ClKJNOsDM7GrPQyB4LMNcHrnoGm/6GY8L20LAxbuEf75
sotLgwVJTyUzl8AfAmBBu4JwoYEc6ghgwyhsogoa7YZUW2J/JtukeWs4kilanXsk
aDRRD5DmZWkDYVZRINxXfZ5i+2FfsafXiBsnMdaT7kTHxXX5MrE=
=gqS4
-----END PGP SIGNATURE-----

--js+/jT5SQQin5+Fm--
