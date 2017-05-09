From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: rdma-core in Dabian
Date: Tue, 09 May 2017 19:43:09 +0200
Message-ID: <1494351789.3752.5.camel@profitbricks.com>
References: <20170507064349.GM22833@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-RePLPpeEAKFiFP1Mw9Za"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170507064349.GM22833-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Spanier <noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-RePLPpeEAKFiFP1Mw9Za
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Leon,

Am Sonntag, den 07.05.2017, 09:43 +0300 schrieb Leon Romanovsky:
> Hi Benjamin,
>=20
> It looks like, we fixed all outstanding reviews comments
> for inclusion of rdma-core into Debian.
>=20
> How can we move forward and see rdma-core part of Debian?

I found some time to continue the review of the source package merge. I
finally reviewed all changes from the 11 source packages to rdma-core.
The review is done except for the debian/copyright file regarding the
upstream part (i.e. the copyright for all files outside of debian/).
The resulting changes from the review can be found in the pull request=20
https://github.com/linux-rdma/rdma-core/pull/128

Remaining topics to address:

* review copyright (by me)

* ibacm: Required-Start on openibd (see separate post)

* rdma-ndd shipped by infiniband-diags and rdma-core (see separate
post)

* srp_daemon: Disallow all targets if not explicitly allowed by
default (see separate post)

* Can we upstream some redhat files, i.e. move them out of the redhat
directory and maintain them in their corresponding code? Following
files fall in this category:
** ibacm.service
** srp_daemon.service
** rdma service (see next point)

* Can we provide an upstream rdma-core "package" that contains the rdma
service and the following files from the redhat directory?
** rdma.conf
** rdma.kernel-init
** rdma.service
** rdma.udev-rules

* Fix lintian issues:

  I: rdma-core: extended-description-is-probably-too-short
  I: iwpmd: extended-description-is-probably-too-short

Patches for improved descriptions are welcome.

  W: iwpmd: init.d-script-missing-start etc/init.d/iwpmd 2 4

Any objections to add 2 and 4?

  I: srptools: init.d-script-does-not-implement-optional-
     option=C2=A0etc/init.d/srptools status

I can write that if you decide not to consolidate the srp daemon (see
bonus point below)

  W: ibverbs-providers: package-name-doesnt-match-sonames libmlx5-1

I think we should just ignore this warning since using libmlx5-1 is
just one part of ibverbs-providers that shouldn't be use alone, should
it?

  W: ibverbs-providers: non-dev-pkg-with-shlib-symlink usr/lib/x86_64-
     linux-gnu/libmlx5.so.1.1.14 usr/lib/x86_64-linux-gnu/libmlx5.so

This libmlx5.so symlink should be part of a development package. Should
I add a new binary libmlx5-dev package or should it be moved to
libibverbs-dev (where already the header files are)?

*=C2=A0Bonus points: consolidate the srp daemon. Debian ships a different
service file than upstream, but I am against an additional layer
introduced by srp_daemon.sh. It would also be nice to have a systemd
service shipped by upstream (and not just in the redhat directory)


Once these points are addressed (and in case I found no new stuff), I
will upload the package to Debian experimental since Debian is in
freeze. And no, we are months too late for Debian 9 (stretch). The
packaging doesn't use the latest stuff to allow a no-change backport to
Debian 8 and 9.

--=20
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web:=C2=A0https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss.

--=-RePLPpeEAKFiFP1Mw9Za
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJZEf+tAAoJEN2M1aXejH562UQP/0v88QJ7rfwihVa+6VNupBtA
RLcoRZxVfFL9KnEZy3lOgBBtWbi14I3DgdaQdI3LAovivbThIxhfwG8V8x4wHB6m
MdWhrBMFImPgMjXQfFFw+3gHPT33vVrtYbqZXsLIGg/VvNLcWeQLcRf2HJZzJ8Rk
HyV72YBOZDCAD9JXnw+LMaGmqu+Svk6NSlLzjLFKK5CaHL1gjKDqyRGBPaIl0ovS
W0ksPsuiMhi210/p0lX6mJouxPgclHE99FNrTfLBMZxY2mgWF5YL+kx+LUVlS3Zq
zs8ImpwOjUqrJFaJ3CXdlmFBKH5toBKZCA15DOPqAhYoDoF6zy6a1NVBqU+nQxr7
YT0ijLtJN+rfWSzhs6Tr9yGHNPl3HZifES5iDcZzSPQb22mqhD/K+/oUdDh219dr
AQwBVIWa4NKBZizPqRicYAvkdeoFfupSFxgnu2G1wtusLPGYRidW7MskxOGq9Sxm
Nel04RTnKELTmcxiZuchGkIQz7iFeL14Ee10vbUugsO6SpEmW7VcuGEKrT18/p0b
6w91t7zIRJEBKfAF1Am9ncNYYqs/yenIYWBitJixZnSOtjc1Deu3ZgNiiBciAqlo
yIj8HlYEo4VuuU6wtKsgkOs8E4Bbkqd61fweycJK+KAhX73Xiir94tkvchaslN70
97QdOgsgOdeWyuH3ur2a
=8mL+
-----END PGP SIGNATURE-----

--=-RePLPpeEAKFiFP1Mw9Za--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
