From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2 8/8] IB/mlx5: Add helper mlx5_ib_post_send_wait
Date: Thu, 27 Oct 2016 09:05:46 +0300
Message-ID: <20161027060546.GA3617@leon.nu>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org>
 <1477396919-27669-9-git-send-email-binoy.jayan@linaro.org>
 <20161025122609.GQ25013@leon.nu>
 <CAHv-k__yPiQOeZxDjvaSzG6A8Qs32to9MnKiPpHAvbXMxqE5EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHv-k__yPiQOeZxDjvaSzG6A8Qs32to9MnKiPpHAvbXMxqE5EA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, Linux kernel mailing list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 25, 2016 at 06:46:58PM +0530, Binoy Jayan wrote:
> On 25 October 2016 at 17:56, Leon Romanovsky <leon@kernel.org> wrote:
> > On Tue, Oct 25, 2016 at 05:31:59PM +0530, Binoy Jayan wrote:
>
> > In case of success (err == 0), you will call to unmap_dma instead of
> > normal flow.
> >
> > NAK,
> > Leon Romanovsky <leonro@mellanox.com>
>
> Hi Loen,
>
> Even in the original code, the regular flow seems to reach 'unmap_dma' after
> returning from 'wait_for_completion'().

In original flow, the code executed assignments to mr->mmkey. In you
code, it is skipped.

http://lxr.free-electrons.com/source/drivers/infiniband/hw/mlx5/mr.c#L900

>
> -Binoy

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYEZk6AAoJEORje4g2clinqigQAKsPr6ke1qKF6UGrDLtD3KuY
3CZLNZvggd6MudpMpQVFCRpvURBCADalIBvFdhqJ+QB6s4tjecx7z2rh0vcZyYP/
5h0C+UOaJwkzrOpLbQSHGtot6EvwqKbWTTbnpHqo8gOS/UEWbCj9rFUiset7a6ah
qhkmJcAy8y/mqjEuy3LOhVDHsB8yeWzkecI74+6rr2Lf7sBevgVsfjepd+8BO0IB
GVDRZjI75xjMPL+N3+Ozt3ShMU/cGQoTL+TOjYIa5eYK6VYxd9PGgirhvI9w9Tcp
OWBewsiMX84l4Fj07GwDTsZUS0emTJRHwxClHNrYLdZAGlFyzg51PQKgrP4GKFUg
L+tQUgWok9uT/ItZ9plS51U1hAHbWBb0I44QT3+NeXffHYv7jHe+3LLNR/f19aO7
yoGImaxgLfZT6C5E/NzPxhxgqxtAGKKi05V/XMSUfPkpP+BaPo9SAY5V2qnLBYKl
KH+NrQTRy7mPuTsE2W2L4ldUOC98ZeY1fV4KNnPpMSgIhIzN77sYTa90Mkxi5k2M
Ecw7Vs4zGF4XTAQ5YWp38m/tug+/m2qUH7SUoCIbg+5mvwvl5sHi4TK54ZIavbsK
NLSOhbe0l5vTlQ7LsHkXLrg8tMel2cFASABAxgv0JBPoz0mlk8P+02pT7Gw7L9lD
zcXAXCNgESyAOEiNvCdw
=Ecik
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
