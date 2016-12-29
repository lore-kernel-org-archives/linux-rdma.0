From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2] ib umem: bugfix: mixed put_pid()s in ib_umem_get()
Date: Thu, 29 Dec 2016 10:17:56 +0200
Message-ID: <20161229081756.GI26885@mtr-leonro.local>
References: <1483000048-183875-1-git-send-email-liguozhu@hisilicon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZOudaV4lSIjFTlHv"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1483000048-183875-1-git-send-email-liguozhu@hisilicon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kenneth Lee <liguozhu@hisilicon.com>
Cc: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, robin.murphy@arm.com, jroedel@suse.de, egtvedt@samfundet.no, vgupta@synopsys.com, dave.hansen@linux.intel.com, lstoakes@gmail.com, krzk@kernel.org, sebott@linux.vnet.ibm.com, markb@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--ZOudaV4lSIjFTlHv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 29, 2016 at 04:27:28PM +0800, Kenneth Lee wrote:
> There are two bugfixes in this patch:
>
> 1. When the execution go to the ib_umem_odp_get() path, pid should be put
>    back.
> 2. When the memory allocation fail, the pid also should be put back before
>    exit.
>
> Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
> Reviewed-by: Haggai Eran <haggaie@mellanox.com>
> ---
> Change from v1 to v2:
>   Correcting the patch title and description

I don't see any changes except version in the title.
What about anything like this?
[PATCH v3] IB/umem: Release pid in error and ODP flows

And Fixes line please, it will help to forward it to stable trees.

Thanks

--ZOudaV4lSIjFTlHv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhkxrQACgkQ5GN7iDZy
WKevrA/7B6kg0taTjvtuLfwUG0CuQFrRESY4Rwh9XwSsbOtXkRG7nacHwyiNAAJY
5gejfWAS0bUIqnnCuU0/sz3KbmeDocAOephzYvXxFlYpqciRA63lGh8roNeiyZGT
bc6sO2l2zT21y0oHgfwU5Y/E8wwVsPyidZ2OJYexvGkl57msP0yHcuxAayl73vQ3
l9aMpiLnwzpmK3YZNrV5imfsmZPYXk0OpucB/vPs3AdCn2eXf7XtrlvUBqDwb67i
MbM/wZiqTy9BG2EftZkG+rDLsd1et1dbOcCJF+l7M7kyLSeqxdcWjpnLRiN75MA+
WZKDxAYR0fM/5ZFi/YuQtafXu8FcoWsgWcrJ45VeBiH9lO5iQq/qWbOgm2H2HC3r
KH4sRiDt4V7UffodDoOJI1hr62cIZliNXlta8IHjEm/jvPJkIn3EGtO0dgf5f4AQ
mIjtq3wOny9z9sCSN610a0Pr+WdVQze6upKqdOLBKtGkSnylli08UNPh6mCF+/F6
hpoZiM5cbBHvyhKOOa+j7Y5IwWZcMRguYnvbsBGTJVffeYsegZB5t6ITH6Vs0++p
FfanV96ix6ZvXZxxnC5yg308KikSxXC1UIWbTLrsleBED549uS5RRIhgMxSps/nv
Tx5YKwp7Y8QXeKITAMHGOxDLeWk7zU10zd7Yg/OayORUsapOj50=
=FIaU
-----END PGP SIGNATURE-----

--ZOudaV4lSIjFTlHv--
