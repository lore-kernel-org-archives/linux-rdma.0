From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 for-next 1/3] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Wed, 27 May 2015 20:51:07 -0400
Message-ID: <1432774267.114391.7.camel@redhat.com>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
	 <1431515438-24042-2-git-send-email-yishaih@mellanox.com>
	 <20150525165449.GA4379@obsidianresearch.com>
	 <1432742669.28905.228.camel@redhat.com>
	 <20150527174332.GC9909@obsidianresearch.com>
	 <CAJ3xEMiYbrr2mkXuywNcyYu1v0dqeM+6Lks-CL0U6fSnx=DQ+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-aTKXBQHWSsVTUTyimrHP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiYbrr2mkXuywNcyYu1v0dqeM+6Lks-CL0U6fSnx=DQ+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-aTKXBQHWSsVTUTyimrHP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-28 at 00:36 +0300, Or Gerlitz wrote:
> On Wed, May 27, 2015 at 8:43 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Wed, May 27, 2015 at 12:04:29PM -0400, Doug Ledford wrote:
> >> On Mon, 2015-05-25 at 10:54 -0600, Jason Gunthorpe wrote:
> >> > On Wed, May 13, 2015 at 02:10:36PM +0300, Yishai Hadas wrote:
> >> >
> >> > > + struct srcu_struct                      disassociate_srcu;
> >> >
> >> > There is no need for rcu for this, use a rw sem.
> >>
> >> The rcu was used becuase it's on the hot path I assume.
> >
> > Perhaps, I looked at that a bit, it was used on syscall paths, but
> > that wasn't even the big reason I made the comment..
>=20
> Doug, what hot path we have in uverbs?! IB's stack hot path goes from
> user-space to the HW, right?
>=20
> Or.

For lots of stuff, yes.  However, the function that they picked this for
is ib_uverbs_write() and for certain things, that is a hot path.
Examples would be things like the cmtime test program in librdmacm, and
let's not forget that the whole reason that program was written was
because we were chasing an issue that caused real world applications to
fall over when they couldn't handle roughly 900 reverse route
resolutions per second, so I consider the cmtime utility, and the
stack's responsiveness to it, a valid item to optimize for.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-aTKXBQHWSsVTUTyimrHP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZmZ7AAoJELgmozMOVy/dhpcQAJqTGSYEvDN3gS9Y3NS3eNny
6mQOmfNy2RJF3Uz8DdQQ7rNV5fjuoVEF92+IYndWQ4oTIPlYrQW+g5Yw4fuArMU2
s18IlCl7EFkGKBb/sTzT5auC5sP74Jiq6iyo6SapKfXYUaHGaw5N2T2U+sS/vNpe
ZXfmZiyQc3MA8nReFn8PkWe+jL7HbdQwJTyyvCp5xwOYsF64C4fUgUTrkMGBLPjK
wbXCJZcj2/fxupHAV2YpEi0ImXW/vwb3hogM1J9e6UuO2p4Ltm5nJdi+09aCSuMa
E6iFeD6sQvHj2L/LUh4PM7Mj2Blr89ni5A2L08KBnkXlD6ZBYlW9FYfWWiKYF8CA
ylbU1WUul+fCJ5NoqFFPLb73yRvcH4vATlb0afTpHxYqJjcd2HfhxrhYD9a+PyIK
Ffl1huW7x0S8XHaFplp9WJiN+ZdMrGUssCqYLwBIbNIdS6LOzPN11uqSsqMdMT8a
JeiaDevuPEzdtcoZCkK9IBzNgW3UGUwJW95sqrSSlHw10teD8wIapxDZK9jlSPK9
NIugcnAgl/vMZZxQSe9cg7pmK226Xk7xbYaswQ+wiKcNdVJAQTkSBw4Tkhpef3Ml
nzuH3gUow2AljbmVU9qsscA1ctPILB5IpOpt7PE1bYKakba69yiGnlQKptJffzxR
ORriXB17RYscLosWTgTi
=s4ev
-----END PGP SIGNATURE-----

--=-aTKXBQHWSsVTUTyimrHP--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
