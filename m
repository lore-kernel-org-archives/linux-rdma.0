From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 03/22] IB/core: Add ib_find_exact_cached_pkey()
 to search for 16-bit pkey match
Date: Tue, 11 Sep 2012 18:51:46 -0400
Message-ID: <504FC082.30303@redhat.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-4-git-send-email-jackm@dev.mellanox.co.il> <504F70FB.6030806@redhat.com> <CAL1RGDW6D25s+R8HuxK-DMrsS_wvKDTL+LSp2X-TK8gB8Vm2Fg@mail.gmail.com> <504FA064.6040002@redhat.com> <CAL1RGDXpeK3KjrmzyivQs8FOs2dg5MqSmuVsdRE+bVD5OXe6BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE1665BA14C0617D2CB95828D"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXpeK3KjrmzyivQs8FOs2dg5MqSmuVsdRE+bVD5OXe6BA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Mascarenhas, Edward" <edward.mascarenhas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE1665BA14C0617D2CB95828D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/11/2012 4:43 PM, Roland Dreier wrote:
> On Tue, Sep 11, 2012 at 1:34 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> Well, at this point, the mlx4 driver uses them, the rdmacm kernel driv=
er
>> uses them, and both QLogic/Intel drivers have their own internal pkey
>> table implementation.  So, it isn't so much upper layer as it is drive=
rs.
>=20
> rdmacm is an upper-level protocol (it's above the midlayer / hardware
> abstraction).

Yeah, I know.  My point wasn't that it was a low level item, just that
it's the only upper layer consumer that I saw.

> mlx4 and mthca look up P_Keys because of internal details of how they
> send MADs, and really they should move to maintaining their own P_Key
> table too.

Why not make the routines useful for all users instead of multiple
implementations of the same thing?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigE1665BA14C0617D2CB95828D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQT8CIAAoJELgmozMOVy/d1pgP/1QVeMkraXqc9gAdeFnfQGM4
wJv9eLexKPgjv7SpRaBjJZC8iEDp1FNKwJYPovk6EcMCE9LnXWaL+AsdmGYdli4I
DM1GExKOT2BrpqL9gTWyxoKJdXj1qDKo1G0l3Oo+j21yVqRMyABf4qeaa2jQsV7x
3Z3mtPXCPxvjAB1ASgBlkV1DK4pUooVR1GfZdpx3xaCFqq86EpWTuiyuNq37nknN
Paa1KYRfog/QWJjh+pYfah5nJ0lDqOm3qUXUyuIeIQLnKXOH7k6Y6X68v7CW/KK7
UIiLO7P8r3+dssjUOcjuDt/V309GsBdLiBEHBhR/D3Ep4xgPHfg+8TMiYrNA22HW
haT574PF+kmw7SPyz/EwYVeoVHbwpD0+bKblgDUJrYPzDaoNd4GXC1Qxr/Yd+1+x
d5glfUTFbQKhzcdenrL+SqAeBjxBcUCJftdiPSElePCrcsdU5rNgvduiVjS728w4
1LS2E6HpBayA3f1A77/2UzKkPDld9QDjSneOWURAFLmqWyPkCpsLz5OSvtD7nr9l
rzXVQOUNskPv41GLNSzuOIf5d7e0w0XBDA0wNgc2OEkbIKDTBmE3mqJMqsDv/Cyg
4MBFXXrBgARuNbHF7Q5HnqG7VkGFTLYEKYDFmXCEbWcOYtO6mQ/cgzBRiwCUSEL+
HObIwKDtPKsdf5et4YlM
=qR1f
-----END PGP SIGNATURE-----

--------------enigE1665BA14C0617D2CB95828D--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
