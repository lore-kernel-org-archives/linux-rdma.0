From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH] IB/mlx5:: pr_err() and mlx5_ib_dbg() strings should end
 with newlines
Date: Tue, 26 Sep 2017 18:50:06 +0300
Message-ID: <20170926155006.GD6816@mtr-leonro.local>
References: <7a5a195cd37db476a2ca007eddc0f28f3ade265b.1506407876.git.arvind.yadav.cs@gmail.com>
 <20170926083843.GB6816@mtr-leonro.local>
 <1506438337.29089.8.camel@perches.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1506438337.29089.8.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>, matanb@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 08:05:37AM -0700, Joe Perches wrote:
> On Tue, 2017-09-26 at 11:38 +0300, Leon Romanovsky wrote:
> > On Tue, Sep 26, 2017 at 12:20:01PM +0530, Arvind Yadav wrote:
> > > pr_err() and mlx5_ib_dbg( messages should terminated with a new-line to
> > > avoid other messages being concatenated.
> []
> > Did you see it is happening?
> > It is not needed after 4bcc595ccd80 ("printk: reinstate KERN_CONT for printing continuation lines")
>
> Not completely true, and that commit message
> itself is incorrect about how KERN_CONT was
> ever required or not required.
>
> After that commit, the dmesg output will
> eventually be corrected with an appended newline
> for sine line format strings without them, but
> the printk subsystem has to wait for another
> printk to occur before inserting that newline.
>
> The commit message bit that says:
>
>     Things get much hairier when you have
>     multiple threads going on and user level
>     reading and writing logs too
>
> is correct.  That's the actual reason that
> the proposed newline additions are reasonable.
>

I asked that question after I tried locally various different options
with/without newline and didn't see any difference.

So how can I reproduce the different output before and after this change?

Thanks

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnKdy0ACgkQ5GN7iDZy
WKcDmRAAm7bmVxPsacyC7gDFhSVdb/M+Hg/OZFzY0MdTDpRmIeEuHhLvmKCyOHlO
vEZpLgzDJ+ZG83Njgyk+QkZUNQwu4g3dn0FaRmtZ2UjVI3A7OGyZx8dGGXIFXzjv
F/s63X2Nq3aX8HmQ7JHNGo4pVfVH0OhZ51uMOBXaF4CuJzHEZhWVmPpOvDD1ZGj4
4xzmwCjQxqWSB7sFOebbQtrUCAYcRVs4MkN1XArffr2XysITMnmTDyQxOZ2/hnS4
rFHLaV0ZzmP4T43icEnwmPQwfUMpVIddQDOw7KUHAXP1IVi0b1ry/ODCt0bCRxJV
NJnIxiAWyIOhZJivZ7pjB/SlphMR+S6lzrqFJRkMis81DpOiLdJNJ2sWMcG1DTQM
dasgNxnyAVKUIlpDlYPs8yEf2+Lahfo/henguqUgNkqISOjtaw9VyLpseRd1jhT4
1eWBd6ayHeIuos1NRu9svXZJ+nHWAzVcSUpThHXaW7UoOOBJTpv2hH4FDGMXig5I
6l8svIqKdICr1dzQrBViVb8tCGQT8ziyIhnOyA2I5uDk7og7B0aMTLFZeRcRjjCr
qhuRU7dsZfThCdSXZol8oX4PTNE9dqT2cIdZtZI7UKjtKMOU9O7Ibpwkm56NdnYs
lKVJftKMwbunJrr/xNmo1z3v+qQFO4Y2hXJ1A+ZJ8pc4x3gX48U=
=xoqW
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
