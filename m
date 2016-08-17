From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] RDMA/core: Unify style of IOCTL commands
Date: Wed, 17 Aug 2016 08:19:52 +0300
Message-ID: <20160817051952.GC5489@leon.nu>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
 <1471355123-6227-7-git-send-email-leon@kernel.org>
 <1471357887.2661.28.camel@intel.com>
 <20160816165041.GA5489@leon.nu>
 <1471367364.2661.45.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E13BgyNx05feLLmH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471367364.2661.45.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--E13BgyNx05feLLmH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 16, 2016 at 05:09:27PM +0000, Dalessandro, Dennis wrote:
> On Tue, 2016-08-16 at 19:50 +0300, Leon Romanovsky wrote:
> > On Tue, Aug 16, 2016 at 02:31:32PM +0000, Dalessandro, Dennis wrote:
> > > On Tue, 2016-08-16 at 16:45 +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >=20
> > > > MAD and HFI1 have different naming convention, this patch
> > > > simplifies and unifies their defines and names.
> > >=20
> > > I don't know that I agree that it simplifies things. It changes a
> > > lot
> > > of code for not much real value in my opinion.=A0
> > >=20
> > > Was this something that was discussed in the verbs call? I have not
> > > been able to attend that the last few weeks.
> >=20
> > It was discussed over mails, for example Jason's opinion [1],
> > Christopher Lameter's opinion [2], Christoph Hellwig's opinion [3].
>=20
> I'm not opposed to trying to unify things, however this seems to be
> more than plop down the hfi1 stuff from here and put it over there. It
> is certainly not simplifying anything.

It is "dark side" of UAPI - inability to change legacy declarations.
This is why I didn't remove anything except _NUM() macro.

The simplification comes from definition of one place for
declaration of IOCTLs numbers and exporting it to users. It gives
visibility for user space authors too.

>=20
> > > > As part of cleanup, the HFI1 _NUM() macro was removed and MAD
> > > > indexes were renamed. It has a potential to break application
> > > > which use these defines directly.
> > >=20
> > > Why do you want to remove the _NUM() macro that Doug just put in?
> >=20
> > It is not used after refactoring and IMHO this macro doesn't
> > belong to UAPI, since it wouldn't in use by any users, but I'll be
> > glad to
> > get an examples of its usage in real user space applications
> > (libfabric???), if any.
> >=20
>=20
> That's a fair point. I can see getting rid of it now.
>=20
> -Denny

--E13BgyNx05feLLmH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXs/P4AAoJEORje4g2clinW80P/1fGUuI/t7D/xP/cZUtcTHeH
pFSUqmDqZJKYDy2J7dsv45Sg0/HpfS/IFISjLuKmkM1CqsMlYds8kJVvbRkzufZv
JeThax1PlBvb9YkeI6t2X1Qxm0zdoXzx5kPAuwiTCXAFW/1AGNqxktGWMyp+c9i4
gm7ERax7lfroEt2+YCcs+QNBSWSDyto08h8D4DotiS2dyZDkwI8f7ozpuPJwT7yn
ByJhU1tDlx+nqG7J5EKZfeJ3OWsQgY4+uFyboNrhFPXHg9Rw6RIXISSJoe0W2fIF
5IQoHceH2FA0uJbP8JCGaiKgYk137fHJZVWAKuZeX5dOG0tm84lUpQsB/993j5zq
eHDT6kkDtZrawxd8nsW118qMPWQ9JDDNn7n95Kazi2AnRdNf3FFZbBq04DCPBbVA
y53NAf80hHf/Wbe9OTCHHEwsTyrViUwbId2WgVGqAyTw/ncZENLSlv55y3F253r/
YWjaKQz5UOZ1ehiz22Ka71l5CxfxkkSGQydq2fhjihpkftvlCoEbhAMZWmVdM3H3
tzWsiuOKyIjejP8Jbmxg6HEPdg888s1iaZcQtVhe1pAZ1+AU97vHyVNTaxWJ1Rs4
q/qWo1WhlbmljJyBgYRLYyZOHiPDXUEUSi9bjIXBxzOcykIM0AyzLPcCuTY0hAO5
QDkhFO2W8H5mVSIby9nX
=UIn7
-----END PGP SIGNATURE-----

--E13BgyNx05feLLmH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
