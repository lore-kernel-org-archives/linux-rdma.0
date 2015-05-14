From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma kernel tree
Date: Thu, 14 May 2015 11:07:53 -0400
Message-ID: <1431616073.3276.17.camel@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5@ORSMSX109.amr.corp.intel.com>
	 <1431485563.43876.93.camel@redhat.com>
	 <CAJ3xEMhRY6nLPFR8qT8S7KJvxRDmw6JwhsSKw7pTvFc5PpnrhQ@mail.gmail.com>
	 <1431530845.2377.30.camel@redhat.com> <55549D33.1000208@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-d05z5Ys6vDbd92KTUYCI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55549D33.1000208-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-d05z5Ys6vDbd92KTUYCI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-14 at 16:03 +0300, Or Gerlitz wrote:
> On 5/13/2015 6:27 PM, Doug Ledford wrote:
> > They will land at kernel.org when I know they won't change again (which
> > really means when I have the final kdoc patch and Ira's dependent
> > patches and everything there is merged properly).  For now, they are
> > present at the github repo as:
> >
> > mwang-v8
> > ira-cleanups
> > to-be-rebased/for-4.2 (which is nothing but a merge of the two above
> > branches)
>=20
> Doug,
>=20
> Developers whose work depends on other people can't chase multiple=20
> branches.

Fair enough.  I'll still keep my various topic branches, but I'll also
keep a for-next tag that you can easily pull to always get the right
stuff.

>  And they need not wait for the maintainer to be 110% sure that=20
> something is final. Our community is small enough to swallow rebases you=
=20
> would do if at some point a patch for the next kernel is replaced, etc.

My reason for not rebasing anything that touches kernel.org is because
that was a specific request from Linus.  Other people might do it, but
I'm going to respect his wishes.  I agree with you that we have a small
enough community and the people are generally able to deal with rebases.
That's why I have my github repo too.  To further keep with Linus'
wishes, my branches on github that might rebase are clearly labeled as
such (although that won't be obvious pulling a tag, but that's the best
I can do).

> As others companies we have here internal review (Gerrit), build and=20
> regression systems which are dependent on the open-source maintainers=20
> trees/branches (for example, Dave Miller's net and net-next trees and=20
> used to be also on Roland infiniband.git / for-next branch).  These=20
> branches must be well known in location and name.
>=20
> Lets find a way to get things in that direction, for everyone's benefit.

I'm fine with that.  What I'll propose is the following:

Kernel.org tree: never rebases, will use a topic branch per release, I
will coordinate tags on the different branches because Linus prefers to
pull from signed tags anyway.  So, for-linus tag will always be the
current code I wish Linus to pull, for-next will be the official next
tag and it won't rebase, it will only move forward.

github.com tree: will have my various topic branches (these will come
and go as code is taken, merged into mainline, and then branch deleted),
will have copies of the official k.o/ branches (which won't rebase), and
will have to-be-rebase/* branches where I pull things together until I
am happy with the overall branch and then I will move it over to k.o/*
and it will no longer rebase.  It will also contain the most recent
for-linus tag, and it will contain a for-next that.  The only special
thing about the tags is if the for-next tag on k.o and here don't match,
it means that this tag points to a branch that might be rebased and has
not been blessed as official yet.  Once the tags between the two repos
are identical again, you will know I've made the last rebase and moved
the branch to the official status.

So, under that scheme, your automated stuff can be pointed at k.o
for-next, or if it is able to deal with rebases (meaning that your
automated system blows away the last kernel and performs the merges all
over again each time it runs) then you could point it at github
for-next.  Is that acceptable?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-d05z5Ys6vDbd92KTUYCI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVVLpJAAoJELgmozMOVy/dVnMP/RM2PVQ4QCHRXdDlXl5mKjSD
yMDoNzEcbdsGf0eWmid6+6J4oJMNnZbFtnRYRmpO1BjPmcUa7QUuygnxh66P5F4G
SMZK/bfgKIq+8o0A3c5WmRZ0YY8/k+VehYF8ytq2IidwcuqSjSwl1F1hM/+Zxlj+
1CiKikcyRNwj8M4NKT45cRXqFLs2wpw/S9KT/jtSyAy7xwuWKJZzm1muNt5DY8iX
JYp/ASsOmjpQYTTRfZoEqy1bLZiZLOoA4CvsrQ4GbBPY/dzO7vpmhElNjlCKjDGX
SYFomiiJdWfOslKHbMR68EzsqtEMDEVhuujSMhI66c9Mj+wnkGY3o+0ePzXndgOA
cMpup0AraE5kmMTaLyA4M7frZvQ3vhZllbOdkRyp9K+OaBTTgp4gkMSYh9YBdxBC
g7Ceo6b2sPqqdLK+fHxV+gpq4HKQg0A0QnAuBQPmqDoN+9WPAsXLcfkpzj38FQeL
UnQi6XkOEkXs1wUdBOxN6NGsjZ8UGTcMPwby4xClXp5TKnON+gLKQzSefjHLgprL
Ll7usKuXcG3jL20LvPH3JOezixrEGT+L1TZFbWHRhVZfhzMKFHtP1huOhT/mR4zY
GLt59zzg7xCQLNP4sx4JBPJBNMVsH6FSE6dlvogxA5XYBOkcwPNorfWJXOWjw7RJ
1VPgHzudx6Wdq5IJmfwS
=e+5I
-----END PGP SIGNATURE-----

--=-d05z5Ys6vDbd92KTUYCI--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
