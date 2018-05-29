From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/mad: Use ID allocator routines to allocate agent
 number
Date: Tue, 29 May 2018 11:54:59 +0300
Message-ID: <20180529085459.GF3697@mtr-leonro.mtl.com>
References: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4jXrM3lyYWu4nBt5"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Hakon Bugge <haakon.bugge@oracle.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Daniel Jurgens <danielj@mellanox.com>, Parav Pandit <parav@mellanox.com>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--4jXrM3lyYWu4nBt5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 29, 2018 at 09:38:08AM +0200, Hans Westgaard Ry wrote:
> The agent TID is a 64 bit value split in two dwords.  The least
> significant dword is the TID running counter. The most significant
> dword is the agent number. In the CX-3 shared port model, the mlx4
> driver uses the most significant byte of the agent number to store the
> slave number, making agent numbers greater and equal to 2^24 (3 bytes)
> unusable.  The current codebase uses a variable which is incremented
> atomically for each new agent number giving too large agent numbers
> over time.  The IDA set of functions are used instead of the simple
> counter approach. This allows re-use of agent numbers. A sysctl
> variable is also introduced, to control the max agent number.

Why don't you simply limit this number per-driver? By default, any
variable is allowed and mlx4_ib will set something else.

What is the advantage of having sysctl?

Thanks

--4jXrM3lyYWu4nBt5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbDRVjAAoJEORje4g2clinN0AP/idsbMxwIzDg+gKlb2EZQsNc
B0j6QICUQKz4wqHuqghozSA2hjyTwcWRzmjFkf5VNaI0T6g93pOf3FcdFGFHlz+/
dhwDZsHa/EwJqFIbGDc/ch7XNMwAsLBXvllU3eq+dno5jdkjVJ9Vsvuc11pX6ttI
N0sxuYhe4gaNE5OnBpASXmk58D+P4uAqlFdbcjTYyYlG3B0W3aapVk15Dii83dSa
Ny8XPBMY1RgjI2txEVMwDjTLXNfvkSg7w+FfgkZA4m5VwyEK4BnQJSmoFidxEWjv
20OkzehDteZDI21BBNtQQxj0a5zdzGPSTnv/8RxkLOr7q6k8bYHXswcag99LjciD
pcG59IVIJR9//tNw48Ey0uRdJwWfAiiBw6uA1fTOWWQjyg/5QwkVjlh2y/TT2Tfv
4AcDOjhDjhUrCSgEwYtetzXYUQRg6/z2GWps9oCVvHOXE/tC4EvXUGBwYRp62yIv
rcN+FDhYcRjowLnIGuWOQUuOWucg7DDVC4T0gh05Tax3rvtw1wqz6plO+i5Shlag
nQQj7VNElA1tcoIFJkWvRK+qLoaUkJLiuW0vRTMyqm7LeN1WdC2GvPCKTv5STeMC
Ik2iSeoIm5WzYOUGdFoetdvBVL9sLZXXIy6bwtp84+ultwwWbVfSNn2gtkgPthR3
ZrnBiholSjKN79fe9s54
=4dh0
-----END PGP SIGNATURE-----

--4jXrM3lyYWu4nBt5--
