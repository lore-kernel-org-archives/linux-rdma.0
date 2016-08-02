From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [IPoIB] Missing join mcast events causing full machine lockup
Date: Tue, 02 Aug 2016 16:29:30 -0400
Message-ID: <1470169770.18081.44.camel@redhat.com>
References: <57907A37.3000902@kyup.com>
	 <1470165672.18081.37.camel@redhat.com>
	 <CAJFSNy6USnLqcBiPEOcFOG8MrGq8gXwvakG48jHHi_-YgVaQ3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-lwaJqjgJQPiSK8GhA9pN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJFSNy6USnLqcBiPEOcFOG8MrGq8gXwvakG48jHHi_-YgVaQ3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-lwaJqjgJQPiSK8GhA9pN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-08-02 at 23:18 +0300, Nikolay Borisov wrote:
> On Tue, Aug 2, 2016 at 10:21 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> >=20
> > On Thu, 2016-07-21 at 10:31 +0300, Nikolay Borisov wrote:
> > >=20
> > > Hello,
> > >=20
> > > With running the risk of sounding like a broken record, I came
> > > across
> > > another case where ipoib can cause the machine to go haywire due
> > > to
> > > missed join requests. This is on 4.4.14 kernel. Here is what I
> > > believe
> > > happens:
> >=20
> > [ snip long traces ]
> >=20
> > >=20
> > > This makes me wonder if using timeouts is actually better than
> > > blindly relying on completing the join.
> >=20
> > Blindly relying on the join completions is not what we do.=C2=A0=C2=A0W=
e are
> > very
> > careful to make sure we always have the right locking so that we
> > never
> > leave a join request in the BUSY state without running the
> > completion
> > at some time.=C2=A0=C2=A0If you are seeing us do that, then it means we=
 have
> > a
> > bug in our locking or state processing.=C2=A0=C2=A0The answer then is t=
o find
> > that bug and not to paper over it with a timeout.=C2=A0=C2=A0Can you fi=
nd
> > some
> > way to reproduce this with a 4.7 kernel?
>=20
> Unfortunately my environment is constrained to 4.4 kernel. I will,
> however,
> try and check if I can get a couple of IB-enabled nodes on 4.7 and
> see
> if something
> shows up. And while I don't have a 100% reproducer for it I see those
> symptoms rather regularly
> on production nodes. I'm able and happy to extract any runtime state
> that might be useful in debugging this i.e I can obtain crashdumps
> and
> reverse the state of the ipoib stacks. I've seen this issue on 3.12
> and on 4.4.
> Some of my previous emails also show this manifesting in hangs in
> cm_destroy_id
> as well. So clearly there is a problem there but it proves very
> elusive.

Can you give any clues as to what's causing it? =C2=A0Do you have link flap=
?
SM bounces? =C2=A0Lots of multicast joins/leaves?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-lwaJqjgJQPiSK8GhA9pN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoQKqAAoJELgmozMOVy/dviEP/2GG8rMcqW4YQZmf9YcquSVD
/kNEMtPW9nhkZZrDpd7SZ7LC/MZqAEGrI6aEYhHsHiJl5bzXjavqH3E9Ej8M2IqC
kKYwOadETTSSzLh2i5uyepsXBFBWkMly07ttMmpcGx7zHB02H6cMahATpQonLcc2
xmGXuHBat1OLSpBSj9OjgXjNHlx8eaB4Ms9Y7W1zWSUO0EOLxXO2BqSHxQwQMlXt
wGfXktcyk6DUu3FvAKCyWlmShdv5Q/if2JOsfC8TzIk3bZfMQA9oQd26gvRGDYbP
O15iZJySnw8iNRJKAHi+7GMb5XbadkfRq2Lz42TR1FKt1R2SSiimEi4joI4YMN5F
XtjDUEo/fjNzpEiQFzMRLr+gVh2vX2aDoh4ZfycKD8ezpbF5KY4cXqfsrpXGPBJG
ar87OuAq0ov540MxkcAw3sDbupvkNUu7N0GLiYuvL705MHVbjcQOBeYujUG293BL
dI7/uvPhynwzrXa4FusHXkshs/VhzYZh41JPop9gjv91RIm96tiJvtd6pPjagPoR
c7mIZI4JYIev47x9IKRWnyJ7rupjLv9XGDXKCgs4aE5ShNEFPzowIQT0JgV856XE
B/n688z0npT6L+oeyrJ/uF1OMNhLpmSralggcrJgP0juxAPKy3/xBKkRWp49PacG
WFAAtueB5tUVN/6mwEi5
=AXXU
-----END PGP SIGNATURE-----

--=-lwaJqjgJQPiSK8GhA9pN--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
