From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Expire sendonly joins (was Re: [PATCH rdma-rc 0/2] Add
 mechanism for ipoib neigh state change notifications)
Date: Tue, 29 Sep 2015 13:47:44 -0400
Message-ID: <560ACEC0.4050207@redhat.com>
References: <alpine.DEB.2.11.1509170940270.2052@east.gentwo.org>
 <CAJ3xEMg-h+J=cr2ddWvYUGU=MOBk4Aw-KtkeJutATH0Y17dnjg@mail.gmail.com>
 <alpine.DEB.2.20.1509241158420.21198@east.gentwo.org>
 <CAJ3xEMg2qQ3CXrfTrg=gUX2tQRuPnpxA-8PC98GzoF5iz=j5PQ@mail.gmail.com>
 <alpine.DEB.2.20.1509251140200.31792@east.gentwo.org>
 <CAJ3xEMj9kGaM6s+AqBQ_-ZTB_+cgDk3kefhq_O0V3PM120O9yQ@mail.gmail.com>
 <alpine.DEB.2.20.1509271136570.14486@east.gentwo.org>
 <5608282F.1020507@redhat.com>
 <alpine.DEB.2.20.1509272120090.18678@east.gentwo.org>
 <56095E6B.60509@redhat.com> <20150928171007.GE12415@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mSt5GOgSOsqe8BlaAowo9ALlP16r5nfMD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928171007.GE12415-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mSt5GOgSOsqe8BlaAowo9ALlP16r5nfMD
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/28/2015 01:10 PM, Jason Gunthorpe wrote:
> On Mon, Sep 28, 2015 at 11:36:11AM -0400, Doug Ledford wrote:
>=20
>>> Also broadcast could cause a unecessary reception event on the NICs o=
f
>>> machines that have no interest in this traffic.
>>
>> This is true.  However, I'm trying to balance between several competin=
g
>> issues.  You also stated the revamped multicast code was adding latenc=
y
>> and dropped packets into the problem space.  Sending over the broadcas=
t
>> would help with latency.  However, I have an alternative idea for that=
=2E..
>=20
> I think your original idea of broadcast immediately and deferred
> optimal mlid lookup is the best *functionally* for every case - only
> when you enter the very edge world of caring about timing does it make
> any difference.
>=20
> Christoph's needs would probably be better served by giving some API
> to control the mlid cache (ie the neightbour table is already 99% of
> the way there). This would let some userspace component pre-load and
> fix all relevant data and undesired cache activity simply can't add
> jitter.

So, I've taken Christoph's patch, added two of my own (just changed the
comment and the #if statement so that we create groups on send-only
joins, and upped the max send-only backlog queue).  We'll leave it at
that for 4.3 and try to address it more fully in 4.4.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--mSt5GOgSOsqe8BlaAowo9ALlP16r5nfMD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWCs7AAAoJELgmozMOVy/dzMwP/RIkmYkL1D/NhIydEVvMPAks
8fSMVTtw5biMVZv1UtuL49wC5zZ8PwMOrjHodd+U0NAmhxhmZ8cax+xMwDnVA2LQ
zNJPrdC0HaoiXyZp7y6QeecAFT6cmJdX8IsVjVYqRu6ezL0zVM9cabWKf/qh0ON5
6vzlYliQagBmi4YvsfMSNDdUaU/FugKbaUuCL8852/g4HU4pMHCPmT+CKvkENx7H
5GqUS2FMoUiIKMH1aLo2I21mpmKIUtqhySaDreNvvXbIz1Wy4VK5eVddbJl0od2l
5P5PpZQOtpK0w/ig1aVixR80DOt663kmJlEAo2AYz8PRmx8kBKGvKJ80qIKziLze
FNeGR0Dbf82YORU6cyalAdP81wT0C443UnDOuGGzy6Zak6m+av0kFfoovPeNaf4G
X88Z/t6KYW8uH3wl3y1y2IuA1Zt2wT3uqF6is/0brRVPPOyALNi6nviM60OWZ3tT
8dYRXT4hF6P7k5cFPKAaITKmbFt2XCxihSty7fUAo+eZ8KbkosPCM2TBUm+nDBy2
QmbrQK9wVAd+Q3t2MfoJwfc0r3tlDs2KL6Ef15TmyrA8+gURgZRm5WRh0IgPbAcE
GCObTiX12APgx7GSq0PZnTVfETrc2Y+uJscdzO2KpYPgeW/+wukZsLoYJ9Zf40Hb
9S3PcAXIeDiV65SCdeo4
=Wp9v
-----END PGP SIGNATURE-----

--mSt5GOgSOsqe8BlaAowo9ALlP16r5nfMD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
