From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Wed, 16 Sep 2015 12:26:07 -0400
Message-ID: <55F9981F.5010605@redhat.com>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
 <alpine.DEB.2.11.1509110920540.16357@east.gentwo.org>
 <20150911182115.GA546@obsidianresearch.com> <55F32E7A.3020105@redhat.com>
 <alpine.DEB.2.11.1509141200020.4192@east.gentwo.org>
 <55F86255.9080508@redhat.com> <20150915191159.GB24173@obsidianresearch.com>
 <55F988F1.8000508@redhat.com>
 <alpine.DEB.2.11.1509161058540.22035@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JF5xngKsujOmFUMfksFEO3j6iHGnSmHH9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1509161058540.22035-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JF5xngKsujOmFUMfksFEO3j6iHGnSmHH9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/16/2015 11:59 AM, Christoph Lameter wrote:
> On Wed, 16 Sep 2015, Doug Ledford wrote:
>=20
>>> Abusing it for send-side is probably the wrong
>>> direction overall.
>>
>> I wouldn't "abuse" it for such, I would suggest adding a proper notion=

>> of send-only registrations.
>=20
> That is really not necessary for IP traffic. There is no need to track
> these since multicast can be send without subscriptions. So I guess tha=
t
> there will not be much support on netdev for such an approach.

I agree with you that it's not necessary for Ethernet/IP traffic.  The
point is that this isn't really Ethernet/IP traffic, it's InfiniBand/IP
traffic.  And there it *is* necessary.  An argument can be made that the
core code shouldn't assume Ethernet/IP and should support either
Ethernet/IP or InfiniBand/IP.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--JF5xngKsujOmFUMfksFEO3j6iHGnSmHH9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV+ZgfAAoJELgmozMOVy/djmIQAJZiyGySyu9fkt5xxymWKemA
1J/wS4rVUBTOgji1QAv9Vwnniz6yUBYkvql0Ut/JUOYDKMh+CWUI71hQblvRAYGe
3psJNiuanWNhvXWN78/fy6MFecYNDp+Usd4oIr40KplhNvcYAC3XD6FnUie3slX7
9mCYSUf8NA5bc9u6Sziycuf5+RCBn1Q9S5vgUTZWuq13g26y9CUzLKP+J/hCUGV5
E3fD8Csf5nGV91rGDutOqQaCuOGsehhm2mdpIoXk4cJLKAHmlJUDS6+86qkgD/0j
n1Da/Nw7aM5gofMoNRIXqhVE5xPsf2Y6yo7Tn0ABl8xZkS+zj4GOPrMD98t3uhKM
hpawuSpyKt40nCmJ+MFV1vheUadGCCI5x3VXRJP/nyVitLllL8DhCkqk/GpCqpRf
azozCbAC3fDuJ4erjwcXU+YjOuCxYP9cg4VVnljo8UkjyNN7zQyy45U51N8rdjGM
o/blOa2/vP4cdlL+0MCd7Cwyuf6YlwqryC1+xGe/v28M22gSw3gO7Hg+Bt5VX43u
VoAmeN/v6GoOLlAia9OixJYK4LmQCJcUW2OtoMoKLYVoLlQZe3v3awH+OitD9rqh
VOJYmqmslaipRl8t/K/8I2R1vt35o93zZRZSW/LHl68RUBBxU6XI/hCNbADjUZpS
DpqwcZeJNbolOmmIvVfB
=xP9I
-----END PGP SIGNATURE-----

--JF5xngKsujOmFUMfksFEO3j6iHGnSmHH9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
