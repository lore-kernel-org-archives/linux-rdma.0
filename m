From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V5 00/12] Move RoCE GID management to IB/Core
Date: Wed, 10 Jun 2015 20:15:56 -0400
Message-ID: <1433981756.71666.60.camel@redhat.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FE5D17@ORSMSX109.amr.corp.intel.com>
	 <55769561.8000300@mellanox.com> <5577FAFB.8020205@mellanox.com>
	 <20150610150010.GA11243@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-yX2g+izD9W7DQiax6Bui"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150610150010.GA11243-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-yX2g+izD9W7DQiax6Bui
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-06-10 at 09:00 -0600, Jason Gunthorpe wrote:
> On Wed, Jun 10, 2015 at 11:53:15AM +0300, Or Gerlitz wrote:
>=20
> > Jason, can you ack that this post addressed your comments?
>=20
> Well, I asked for a cleanup series, multiple times, and this is the
> closest things have got.
>=20
> It isn't really a cleanup because the whole gid table is new code and
> has latent elements for rocev2 - this is why it is so much bigger than
> it should be.

I'm not sure the complexity here is "latent RoCEv2" stuff versus simple
over-design.  I didn't see anything in the RoCEv2 that warranted this
level of complexity either.

Just to be clear, I'm currently reviewing the RCU usage here.  Jason has
brought up specific issue, if I can't convince myself that his
objections to the RCU usage are wrong, then I'm going to second his
request that we go back to a more simplistic rwlock.

> The other core parts have been mostly trimmed, so that is the specific
> things discussed last round.
>=20
> Is it Ok to go ahead with the gid table as is? I don't know, I haven't
> studied the patch in any detail. Technically, that is not best
> practice for kernel development process.
>=20
> Jason


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-yX2g+izD9W7DQiax6Bui
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVeNM8AAoJELgmozMOVy/dFTYQALh5J/ZZzKaaN3stsjC1IO5u
BBjGHQv53+j+xsy82FydkvhaOX3DF+N+sjLGREU7kKLkMRhOtjocHQxtAKfynycT
1/8bOmUMlGQaUF/6Xx03Df+OveT/Z4hlkdUDej4+j0DPZTQ6BGZOmQ/Hr4WAyqTo
wu+yKJyzLo7QEirqHSxLibQA9terH0D0Are654aY+xOG86/ILTCXGV9mH0vqCHzg
qDBY7RIwok16aMW70dP0vJ2h3WoP0phwEwpeT/FnxAj7vlZWz5xs8r6u4sBoFHEc
VsrdTrW558N+huMqJR3g5CfmOTQy2fXdkJfIrMCb0zEk9U/Pkkh5ynrX0iAFQ+JQ
z6jB+LlBEZPzVnLqWfm1EgzI9TF+6ZjB9batOSV5dlltlgiC6b0IaJSqIKLEFbPG
1LbYrX6sKP6hG72Uuk5KTl2HaEdxwoef7E5afx5f3TFx1+i9J1WIR+qul1M/pbm/
wa2aB0otvz2Ly9FsgM/tPI9VaTI/OC3qKzLFG0TSyVnYt0VnaZWX+rrXnM/Vt/OT
HR6/hrrENfJzyIfhEAeyMKE/ibqqjx4breAfwsylZWGaylsl7erI4XRw2P5NKNpt
sEmU8HX+rqxG1zpKgz6SRGBLCgTCnIPwbNrTCitdJdJCWbF91vKybNT8DzY8E5zt
aZLS0smrS88WTIdHPdpz
=NQ7n
-----END PGP SIGNATURE-----

--=-yX2g+izD9W7DQiax6Bui--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
