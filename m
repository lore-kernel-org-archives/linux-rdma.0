From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Expire sendonly joins (was Re: [PATCH rdma-rc 0/2] Add
 mechanism for ipoib neigh state change notifications)
Date: Mon, 28 Sep 2015 12:59:08 -0400
Message-ID: <560971DC.500@redhat.com>
References: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com>
 <alpine.DEB.2.11.1509170940270.2052@east.gentwo.org>
 <CAJ3xEMg-h+J=cr2ddWvYUGU=MOBk4Aw-KtkeJutATH0Y17dnjg@mail.gmail.com>
 <alpine.DEB.2.20.1509241158420.21198@east.gentwo.org>
 <CAJ3xEMg2qQ3CXrfTrg=gUX2tQRuPnpxA-8PC98GzoF5iz=j5PQ@mail.gmail.com>
 <alpine.DEB.2.20.1509251140200.31792@east.gentwo.org>
 <CAJ3xEMj9kGaM6s+AqBQ_-ZTB_+cgDk3kefhq_O0V3PM120O9yQ@mail.gmail.com>
 <alpine.DEB.2.20.1509271136570.14486@east.gentwo.org>
 <5608282F.1020507@redhat.com>
 <alpine.DEB.2.20.1509272120090.18678@east.gentwo.org>
 <56095E6B.60509@redhat.com>
 <alpine.DEB.2.20.1509281046440.30710@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GClGKEU7Cj0DGhn1wlpURgjHRjx6F5hQH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1509281046440.30710-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GClGKEU7Cj0DGhn1wlpURgjHRjx6F5hQH
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/28/2015 11:51 AM, Christoph Lameter wrote:
> On Mon, 28 Sep 2015, Doug Ledford wrote:
>=20
>>> We would like to keep
>>> irrelevant traffic off the fabric as much as possible. An a reception=

>>> event that requires traffic to be thrown out will cause jitter in the=

>>> processing of inbound traffic that we also would like to avoid.
>>
>> That may not be optimal for your app, but we also need to try and
>> maintain proper emulation of typical IP/Ethernet behavior since this i=
s
>> IPoIB after all.  That's why the app isn't required to join the group
>> before sending, and also why it should be able to expect that we will
>> fall back to sending via broadcast if needed.
>=20
> Ok this needs to work with the existing ethernet gateways and verified =
to
> work with them.
>=20
>> However, the following algorithm might be suitable here:
>>
>> On first packet:
>>   create mcast group
>>   queue packet to group
>>   schedule join
>>
>> On subsequent packets:
>>   find mcast group
>>   check mcast state
>>     if already joined, send immediately
>>     if joining, queue packet to mcast queue
>>     if join is deferred, send via bcast
>=20
> Hmmm... If the multicast group does not exist in the SM then we could o=
nly
> bcast to all routers instead?=20

No, I was referring to using this on top of your patch and my other two
patches, which change the ipoib driver to create sendonly groups and
then expire them when the neighbor expires.

> No host in the fabric could then be
> listening the only listeners possible are outside the fabric.
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--GClGKEU7Cj0DGhn1wlpURgjHRjx6F5hQH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWCXHcAAoJELgmozMOVy/difwP/1aFgi3yJOFBaPRZUK4Ln/rH
/eWo6SKzsASB11QMOx9RWYDSL1/9f/OE4Ej/lYNFluwUokxOwkaHqe/0m54WbFla
kYAVDIsZwSSQE3QaF0V+dklil3akt8EpFZH7rrr9th07UzKYUd+Q+1T3ediefst5
YLZxg1y8FMcqKuYZWYBaV5AL03W001FiJ00VMd6xJzLZhpixzap3stxBkcgRCQ10
K0qAdGgZ+BsoPkl63/Mt9cC2HzFsD50xtSQygh2tLxr3uiymV0Me3KiuUPCaC/n4
yQa3TpWdF2eA783SbYgY5UzLCpDIQNv02XqRbEVTj2rbt+8BaulbMRipb70MYRtA
fFhWUFy8P80CkMIcft3ujA5+gWO2AQ21KaLURWBQehAFhviKnwsG76I2nQ2ZchTM
uiZcbXbEfWP9PSZjYJOJo9pj7FBY6IPmwCidEuwEtB41EFlwuFUtYKsSmnpBbH7a
9/BzIrKXyHcbUMSykkL8SuZhD1z6LVkVxWorWH85eQKNnZ/GzL9q0ycTDcR3A1Iv
gHK2LtAy5ueGNPeybYtziwJSYk20Ng4SE0T7c4tKub//J4WXU1hARNMkMY4sP31a
2mALniEwCCO1WosFQcAuIuje/QLV+I3gLn/Zrei79PXbi26ZeZdzF2Bq86QPE3RG
USdnp6YvI0KIwxZzdYzZ
=B53G
-----END PGP SIGNATURE-----

--GClGKEU7Cj0DGhn1wlpURgjHRjx6F5hQH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
