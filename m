From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Wed, 30 Nov 2016 11:18:20 -0500
Message-ID: <405d9368-e6db-4871-a5ff-b20b0c7da308@redhat.com>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
 <1480258296-27032-2-git-send-email-leon@kernel.org>
 <20161128170056.GC28381@obsidianresearch.com>
 <05bd01d2499a$1c75f750$5561e5f0$@opengridcomputing.com>
 <cfdf28c6-4715-28d4-7da6-453fb6794c29@redhat.com>
 <5927e04b-42ec-52c1-88a3-456cc4409334@talpey.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="i56KEw17lp8KV4rxeuF8F4Klvv7NHAulh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5927e04b-42ec-52c1-88a3-456cc4409334-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Dennis Dalessandro' <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "'Wei Hu(Xavier)'" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Selvin Xavier' <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Devesh Sharma' <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Mitesh Ahuja' <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Christian Benvenuti' <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Dave Goodell' <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i56KEw17lp8KV4rxeuF8F4Klvv7NHAulh
Content-Type: multipart/mixed; boundary="nQ0LKRkSTc11Exkpumo02kkbtqujMssvD";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>,
 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>,
 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 'Dennis Dalessandro' <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "'Wei Hu(Xavier)'"
 <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 'Selvin Xavier' <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>,
 'Devesh Sharma' <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>,
 'Mitesh Ahuja' <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>,
 'Christian Benvenuti' <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Dave Goodell'
 <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <405d9368-e6db-4871-a5ff-b20b0c7da308-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
References: <1480258296-27032-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1480258296-27032-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20161128170056.GC28381-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <05bd01d2499a$1c75f750$5561e5f0$@opengridcomputing.com>
 <cfdf28c6-4715-28d4-7da6-453fb6794c29-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <5927e04b-42ec-52c1-88a3-456cc4409334-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <5927e04b-42ec-52c1-88a3-456cc4409334-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>

--nQ0LKRkSTc11Exkpumo02kkbtqujMssvD
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/29/2016 9:33 PM, Tom Talpey wrote:
> On 11/29/2016 9:07 PM, Doug Ledford wrote:
>> On 11/28/2016 12:08 PM, Steve Wise wrote:
>>>>
>>>> On Sun, Nov 27, 2016 at 04:51:27PM +0200, Leon Romanovsky wrote:
>>>>
>>>>> +static inline bool rdma_protocol_raw_packet(const struct ib_device=

>>>>> *device,
>>> u8
>>>> port_num)
>>>>> +{
>>>>> +    return device->port_immutable[port_num].core_cap_flags &
>>>> RDMA_CORE_CAP_PROT_RAW_PACKET;
>>>>> +}
>>>>
>>>> Does the mlx drivers really register ports with different capabiliti=
es
>>>> as the same ib_device? I'm not sure that should be allowed.
>>>>
>>>> I keep talking about how we need to get rid of the port_num in these=

>>>> sorts of places because it makes no sense...
>>>>
>>>
>>> I agree.   Requiring the port number has implications that ripple up
>>> into the
>>> rdma-rw api as well...
>>>
>>>
>>
>> In all fairness, there is no requirement that any two ports on the sam=
e
>> device be the same link layer, or if the link layer is Ethernet, there=

>> is no requirement that they can't support both iWARP and RoCE.  The id=
ea
>> that the parent device defined the supported protocols for all ports o=
f
>> a device became wrong with the first mlx4 device that could do both IB=

>> and Ethernet.  And I think I've heard rumblings of a combined RoCE/iWA=
RP
>> device possibly in the future from someone else.
>=20
> This one for instance?
>=20
> http://www.qlogic.com/Resources/Documents/DataSheets/Adapters/DataSheet=
_QLE45211HL_QLE45212HL.pdf
>=20
>=20
> I'd love to see any such device support protocol choice per
> connection, not just per port. That of course would have
> implications on the rdma commection manager api.
>=20

That's certainly a prime example, thanks Tom ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--nQ0LKRkSTc11Exkpumo02kkbtqujMssvD--

--i56KEw17lp8KV4rxeuF8F4Klvv7NHAulh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYPvvMAAoJELgmozMOVy/dLTIP/0ZsiYHYe5vvx92obirKCdky
oM8/3NW+8koQpXArKq/UVz8HRngU65s/UIzBJhl4xm9yxqFEQQS3yXCBlhGjcrDp
vvzb4cBrJA2nqfLJ/8uw7wZPNm7gpli7Ux87Z6PVAxMggXONZ6efM++rtA5ztlyu
SKuzNGtZfjye7s8yURuPG0FzQUh1dTVqxRXHVGGZyhBNzQ3vK5nMSrhImt3w/aWi
vasBSbDIu4a2pJ9GsfCHWS4QxgQ4YtE3tvlSuWLYp1A9v2eXUyDy1hIrQbO5waXT
Ze/3lQmimHbaaD5cxkPtBRmYKIcR/qoctaPTP8DBg7GMC9H5GUyNET/Tw95RvneF
JPKA7ziQ3ZMp4fD+mf06cQf2rk8eM0ncB1PXGQPUpdNlYMlkIh7h1UamZGjcPECZ
O57ASHsfcXyirGASEmmZ4UIblLcMFUU/67QXZnUCEo9UqRWU403yLZiolObe1fvB
yTtr/Zz+CyzIuMg5WIAtKMPoFc8n7U+VDmc7nEGIHkjlHnC0WIGqJgv1xVeGJH9Q
4hJhJeNagAsaDekABBhARIsRX3yNGkDCek89LhHdEzilRoaWhJtEyCNq3X2zZZlv
CB0tNaSoUeMm1EECV9jmFc4qvm8NwbZI2c8IzzNuA/5KnJmroznW92CikPMIw1oh
mk+YF89JNSlKHvas8/kk
=MYS8
-----END PGP SIGNATURE-----

--i56KEw17lp8KV4rxeuF8F4Klvv7NHAulh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
