From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.1 2/2] iw_cxgb4: support for bar2 qid densities
 exceeding the page size
Date: Tue, 09 Jun 2015 10:25:18 -0400
Message-ID: <1433859918.90034.25.camel@redhat.com>
References: <1433854392-6531-1-git-send-email-hariprasad@chelsio.com>
			 <1433854392-6531-3-git-send-email-hariprasad@chelsio.com>
		 <1433858594.90034.14.camel@redhat.com>
		 <002301d0a2bd$9aef5840$d0ce08c0$@opengridcomputing.com>
	 <1433859363.90034.19.camel@redhat.com>
	 <003f01d0a2bf$377ac3b0$a6704b10$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-KzdlkriBvOLQlubFTvhY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <003f01d0a2bf$377ac3b0$a6704b10$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-KzdlkriBvOLQlubFTvhY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-06-09 at 09:18 -0500, Steve Wise wrote:
>=20

> > > > Why are you using a cast here at all?  bar2_pa is already u64...
> > > >
> > >
> > > So it should just have the (uintptr_t) cast?
> >=20
> > No, it should be no cast at all.  The uintptr_t cast is only for castin=
g
> > an int->ptr or ptr->int.  In those cases, if the size of an int !=3D si=
ze
> > of ptr, you can loose data, and uintptr_t tells the compiler "I know I'=
m
> > casting between possibly lossy data sizes and either A) I've checked an=
d
> > it's OK or B) I'm ok with ptr truncation and the loss won't hurt us".
> > It basically turns off size checks when sticking a ptr into an int.  Yo=
u
> > should therefore use it only in those circumstances.  For example, when
> > storing a cookie that doesn't have a strict uniqueness requirement, the
> > loss due to truncation is probably OK.  Or if you know you are only
> > doing something like initially storing an int into a pointer, and then
> > later storing that pointer back into an int, so there can never be any
> > truncation because the source of the ptr was always int sized.  Those
> > are the times to use uintptr.  In this case, you have a real u64 going
> > into a real u64, there should be no casts.
> >
>=20
> My bad.  I thought bar2_pa was a ptr...

I didn't look up the actual structure definition, but:

+       cq->bar2_va =3D c4iw_bar2_addrs(rdev, cq->cqid, T4_BAR2_QTYPE_INGRE=
SS,
+                                     &cq->bar2_qid,
+                                     user ? &cq->bar2_pa : NULL);

+void __iomem *c4iw_bar2_addrs(struct c4iw_rdev *rdev, unsigned int qid,
+                             enum cxgb4_bar2_qtype qtype,
+                             unsigned int *pbar2_qid, u64 *pbar2_pa)

Looks like either it's a u64 or else there should be compiler warnings
about passing &cq->bar2_pa to c4iw_bar2_addrs.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-KzdlkriBvOLQlubFTvhY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAABCAAGBQJVdvdOAAoJELgmozMOVy/d9i4P92epvpaOqeUZifgNMLZPftC7
OZOKnIV5PAvPf47TcGh0696JwDFkGejL06uJ2P3W/lqL2rlj3MOUMVCHTR7viMrv
YnIXifo56tcpuG8mPzlegE51dpY4dAsxSXYT8Dy85ll+RBnD+J8G3RFYIncF7byU
3dxa+ahEp799Tjw1GFnhdE4pL41bXK5/Hq7j8E384bgg2ggwdeQtBN978WFN8QRt
TgIYO0mnhooLNCrbtjOvhD7SxUga8piNiT3Vy/+8mSn2jAGUEnJBY1RjCkjgTW2B
8LM0z8JAHaCMOGHxp+AttJTDX9TN68RuuVEywJfFBpkfPq0iq5dUtZvuuaqnc8Nn
cVcAG1m7Nt4gY7n6bIcnkS+7GCWqNB12822FMO25/cajx1Xd9i6BNnZWL0nbHCZK
pzfZxpq5C9iSjPQdmcrz29EQrfwA/qAkzE8IkLMIENeRpcuyJ3noAwS/N6rZM78s
97wFxOWiBdN15XecLmecwl/a/6L/R5m36GaGwytCvsZA4IHDQoq83bG5e3be3A7C
LeHHtzYP2a79IlJ2LeF79xNmxJGQjO77ecL1/34VmOgSQsJDYxPMXCH1Tl4fPDxa
mx3kNocOPYOsFpKj0YIhSsQSfHCFsqcliV8b6O5VQvTj90wMlsS43vlQMsyYLW9+
TQwz5wkE2vEZnPQ4i5k=
=pE/a
-----END PGP SIGNATURE-----

--=-KzdlkriBvOLQlubFTvhY--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
