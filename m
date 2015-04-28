From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 01/26] IB/Verbs: Implement new callback
 query_transport()
Date: Tue, 28 Apr 2015 16:02:49 -0400
Message-ID: <1430251369.102408.7.camel@redhat.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
	 <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com>
	 <DB4PR05MB086367DF92CEE1977D8EB0AEB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
	 <553DE799.5050608@profitbricks.com>
	 <20150427215229.GD5347@phlsvsds.ph.intel.com> <553ED159.2090006@talpey.com>
	 <1430181360.44548.35.camel@redhat.com> <553EDA01.9040708@talpey.com>
	 <1430184275.44548.44.camel@redhat.com>
	 <20150428185612.GA15216@obsidianresearch.com>
	 <CAJ3xEMgHHr0ZkGcKQDcQoDymPDTnkhHmB1tCXwv=z6TjMw9N0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-eeBEXn7AoQQQIKPZmy5T"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgHHr0ZkGcKQDcQoDymPDTnkhHmB1tCXwv=z6TjMw9N0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-eeBEXn7AoQQQIKPZmy5T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-04-28 at 22:11 +0300, Or Gerlitz wrote:
> On Tue, Apr 28, 2015 at 9:56 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Mon, Apr 27, 2015 at 09:24:35PM -0400, Doug Ledford wrote:
> >> On Mon, 2015-04-27 at 17:53 -0700, Tom Talpey wrote:
> >
> >> Having some of it refer to things as IBOE and some as ROCE would be
> >> similarly confusing, and switching existing IBOE usage to ROCE would
> >> cause pain to people with out of tree drivers (Lustre is the main one =
I
> >> know of).  There's not a good answer here.  There's only less sucky
> >> ones.
> >
> > The tide has already turned, we should ditch iboe:
> >
> > $git grep -i roce_ drivers/infiniband/ | wc -l
> > 91
> > $git grep -i iboe_ drivers/infiniband/ | wc -l
> > 37
> >
> > It isn't really mainline's role to be too concerned about out of tree
> > things like Lustre.
>=20
> FWIW, note that Lustre is under staging for a while, not sure how
> close they are for actual acceptance.

I thought that was just the client and didn't include the server...


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-eeBEXn7AoQQQIKPZmy5T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVP+dpAAoJELgmozMOVy/dWPsP/1GbuAP4kN1xWFr+4B97luOE
CLrVkNpk0BgyhGc9W2yL+1Ddl2ebasIp3wNHJ5sLQ0vCFr2WH6Ju5fSWEm0bhd0f
UrIf07KdHaN/S11zV9lGMmZppXCxL3shVfNWiCgWccNB1RZZxMrcu1Ajc67NCx8V
ML5zrpG84E3FKMBtapo96qOVhH/jkQTovo8Sdsq38g1FVNZE7NxNLxkHjXCUfqvs
mlZbea7fQfojKaLYVZNAwm3685qBf02/uYEz4/RcFc7q384jMEMo3UpSAm8SPB+e
4tLg3S8sdVQ961EaJTUg0UuPlVMacsOoALD4HwGCm0GqjoKCQllrKWYnbwOSezFc
EMu+ZeVhhnraDRtg0IzxdO5/exfQnN/LjE5FPeY5NOJp8ZCSmRrlZ+zKFCRKZtmf
1qBjuKvN60M+D+CZfh4RvfH973dbeeIIyX24FM5ZuTT5OdMWqGBqekO4kDRndKIy
rsgVByFb2/lVg6GNiWO5NX4LV5SF5+q6eUPtgMHl44IN2zhbWJ1vQaTlG9aqcg36
V3BIvTsq2cX9JZU1xBg9FI7e3AZH0YnCIZqKQTj80RQ0s/l/EaylQZZH9RfwaBbP
VnyCA6mqB/j3mFrvJRUxZ42CJBNnwUGwEwdFtjGhbXMggkGZtbW2X0eYxnILQLIS
YfoJsSljHPeVQsmSZWz+
=5Les
-----END PGP SIGNATURE-----

--=-eeBEXn7AoQQQIKPZmy5T--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
