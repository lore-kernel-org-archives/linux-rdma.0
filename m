From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH] IB/mlx5:: pr_err() and mlx5_ib_dbg() strings should end
 with newlines
Date: Wed, 27 Sep 2017 17:46:44 +0300
Message-ID: <20170927144644.GE2297@mtr-leonro.local>
References: <7a5a195cd37db476a2ca007eddc0f28f3ade265b.1506407876.git.arvind.yadav.cs@gmail.com>
 <20170926083843.GB6816@mtr-leonro.local>
 <1506438337.29089.8.camel@perches.com>
 <20170926155006.GD6816@mtr-leonro.local>
 <1506453105.29089.14.camel@perches.com>
 <1506522039.82712.26.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EXKGNeO8l0xGFBjy"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1506522039.82712.26.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Joe Perches <joe@perches.com>, Arvind Yadav <arvind.yadav.cs@gmail.com>, matanb@mellanox.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--EXKGNeO8l0xGFBjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 27, 2017 at 10:20:39AM -0400, Doug Ledford wrote:
> On Tue, 2017-09-26 at 12:11 -0700, Joe Perches wrote:
> > On Tue, 2017-09-26 at 18:50 +0300, Leon Romanovsky wrote:
> > > So how can I reproduce the different output before and after this
> > > change?
> >
> > Try lib/test_module.c with and without the newline
> > on "Hello, World" on a quiescent system.
>
> I agree here.  The newlines are still worthwhile as they remove any
> unnecessary stalls in the printk output while the printk engine decides
> whether or not you are going to do a KERN_CONT print next.
>
> Thanks, applied.

Thanks

>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--EXKGNeO8l0xGFBjy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnLudQACgkQ5GN7iDZy
WKduPhAAkb5pJ/gthVz2sR15LpgC5FuSnXhCSmVFiabcWlvGsVfS2XOh84bqvhhK
6QDQrmNUeM2FbqALmu2bBfMylbW1zs2DHV34tYv1nWlWkH9LSopEWUcpUzc0UNgl
pyokxlPlciNXFmFxnqtx91maTIgwpRBl9a59H76Qy9hKs60Ui5CdIqdMjjhI8WHe
gmziPXgYWoJc2JpOJgwg1hHYzDMF3PzAVmIThpZXN1/79brMSFZwUDHDCTGesG+s
pjEwXYXyAlN8/KcnvbU/HUzC8uWqXD//krjHO9XOJTfbMVV9q8VJSxaD+h6ZogQ+
I7hAan6RvWIgTslqFEnDMkWMwdpY0VCguwNufIGsH+ySLlaizk0MYqlMV4JXcEdz
Ws3phEOJJ5LmhX7bTasCr89pvWx3aw8BoxiPq1eS16ynzWt3wTXFXkbtfgwDckIE
fMDnS8k0xiNFMOP5aGECUSLIhU4F7+8AMdMdTTZ9RhwJw0mwl4nq/mCWHw0h8m/H
ZT+48TmsOKca9ds5791rSpGZXkb4d/KEu6L6npMo4LFb2bPTgsDMqf5M9Yu8igHv
XRE7qZwnYO+yMTF37LlY6T9VYTxuEJPXELP9w52hp7XkgMSiWY7zDEIn+XbbrUDF
8o583omGxhq+PcMJCpZUU35NJHXAKH1FECCMjjlYORKm5n9ZvwU=
=dJNh
-----END PGP SIGNATURE-----

--EXKGNeO8l0xGFBjy--
