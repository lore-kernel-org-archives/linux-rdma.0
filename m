From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] lockdep warning fixes
Date: Thu, 09 Jul 2015 09:17:23 -0400
Message-ID: <559E7463.6070709@redhat.com>
References: <1436280313-21451-1-git-send-email-haggaie@mellanox.com>	<559DA5E9.5050500@redhat.com> <CAJ3xEMiydOEN_baOJcdcH0=LL+6Qv2HM5XJGirjqFHfz4zif5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qxbhFEe5I4qofV4fKXUl4qclgQqDHuqBj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiydOEN_baOJcdcH0=LL+6Qv2HM5XJGirjqFHfz4zif5g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qxbhFEe5I4qofV4fKXUl4qclgQqDHuqBj
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/09/2015 06:49 AM, Or Gerlitz wrote:
> On Thu, Jul 9, 2015 at 1:36 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>> Thanks, both applied.
>=20
> to where?!

To my tree.  The fact that I've taken it in does not mean I have pushed
the tree out yet.  The set of rc fixes has not yet passed my build/run
tests.  I'll push the tree out when it has.

> Doug, I didn't see any update on your gitbub nor your
> kernel.org tree,

Because it hasn't been pushed yet.

> and again, it's a bit annoying to chase two trees w.o
> clear branching policy...

The trees already have a clear branching policy.

> can you use something with clear name (say)
> 4.2-fixes on your github and it would be clear that 4.2 rc fixes go
> there?

When I push it, it will be obvious.

> Also, I didn't see a note from you on picking the fixes from Ira and
> myself to address the comments from Linus..

I haven't worked through all of the patches yet.  Nor have I notified
everyone about every patch.  However, a few of the patches I lost the
original email to and so they won't get a response.  When I push the
tree though, you can check that the patches you care about are present.

> Ira's https://patchwork.kernel.org/patch/6675271/ -- this still has
> blank line that I asked Ira to remove, so if you can either ask him to
> do so, or clean this up yourself...
>=20
> mine https://patchwork.kernel.org/patch/6675921/
>=20
> and the mlx4 fix Matan's code plus the ipoib fix
>=20
> https://patchwork.kernel.org/patch/6702851/
> https://patchwork.kernel.org/patch/6702841/
>=20
>=20
> Or.
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--qxbhFEe5I4qofV4fKXUl4qclgQqDHuqBj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVnnRjAAoJELgmozMOVy/dTeYP/AvBzRZiqy71Fg/Lr8SqPaci
PmyKPzgKW1/A3cr+9WrZUHC1s8CQAzSuaaIR0I4hz3+MfbD4wCMJCtf+rmhXYxh+
BHk55tgi8ytLBB6R/udEjaS0hKYCGROxrR0yBGMlSZcyyBVlOeFPn9DKB0g5ME1R
AieQpe88DWanJW44h8v13tHF7hBMXzZshrVpdYG3/1xSCwyY730zIVb9bxbafc8F
4SHNc9xct/K/9ICikE9HRcVJeCGBOcfT8RCyJKzYfnbIIqHbodcOhXF+ZNyGDB2j
0lpHL0OWJkjD3XybkFoBLmKO5gcZq/S5pkLhGN4HFmaFC4wmCbvCyDkeSdE95S3j
VQ3n7a61lwrzeXG7hRn649pC5oPOmhlUr9hq5kJ3qN5YGcolHvCuYnFc0g4SvGNs
IObQyfB/fA95npkPcJ1rYEMd4ovobEbcAYtiCrvB5Le4OXyZc2H+/KiQ41joEkqv
niB+XYFhQVznD1nvxpzCJsbc39YfDUKUyl30Mg3KuCieEx1GCHDW3h+Wb1tZfXkV
6mXE9ZndWXudWlrY1qVpCUeG2k7xFNe0vPHxx76Tk9BSrk2aX3U/e93Jf/+xe9Q1
90xqUoFAvgZIPsmTMo0Wo7UIfvT6f4VvmlX0SWOagejqqXNrQ1WaOSaN9eDOBj7I
lYjxbnayVX8qQpJdJeU/
=oGSe
-----END PGP SIGNATURE-----

--qxbhFEe5I4qofV4fKXUl4qclgQqDHuqBj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
