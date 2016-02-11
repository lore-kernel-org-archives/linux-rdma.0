From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] new ib_drain_qp() API
Date: Thu, 11 Feb 2016 10:22:41 -0500
Message-ID: <56BCA741.6020800@redhat.com>
References: <cover.1454969695.git.swise@chelsio.com>
 <010901d16375$1a023210$4e069630$@opengridcomputing.com>
 <011601d1637b$8c01a3e0$a404eba0$@opengridcomputing.com>
 <56BA540B.4040405@sandisk.com>
 <011901d1637d$b5286400$1f792c00$@opengridcomputing.com>
 <012801d16384$f68884f0$e3998ed0$@opengridcomputing.com>
 <56BB11F0.9090203@dev.mellanox.co.il>
 <00ca01d16417$9e9fc030$dbdf4090$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6WSvBTWtJSAwaqHAL2A5Q4eWEQFBCt8CK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00ca01d16417$9e9fc030$dbdf4090$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6WSvBTWtJSAwaqHAL2A5Q4eWEQFBCt8CK
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/10/2016 10:27 AM, Steve Wise wrote:
>>>>> Hello Steve,
>>>>>
>>>>> How about creating three functions - one that drains the receive qu=
eue,
>>>>> one that drains the send queue and a third function that drains bot=
h ?
>>>>> The latter function then can call the two former functions. And sin=
ce
>>>>> only one of these three functions will have a user in your patch se=
ries
>>>>> (the function that drains the RQ), how about only introducing only =
that
>>>>> function now and to wait with introducing the two other functions u=
ntil
>>>>> these have a user ?
>>>>
>>>> That sounds reasonable.  Simpler too perhaps.  We'll see if anyone e=
lse
>>>> has an opinion.
>>>
>>> Another option is for ib_drain_qp() to just skip queues with IB_POLL_=
DIRECT CQ processing.
>>
>> I'd rather not skip silently anything. ib_drain_qp() semantics is that=

>> it drains all the pending posts on the queue-pair (i.e. both send and
>> receive queues).
>>
>> We can split to send and receive, but the fact that srp uses direct
>> polling CQ is not sufficient for that, most if not all will benefit fr=
om
>> both.
>>
>=20
> If we split it into ib_drain_rq(), ib_drain_sq(), and ib_drain_qp(), th=
en srp would only call ib_drain_rq().  Others can call
> ib_drain_qp() if they want both SQ and RQ drained.

I'm in favor of this kind of flexibility at the API level.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--6WSvBTWtJSAwaqHAL2A5Q4eWEQFBCt8CK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWvKdBAAoJELgmozMOVy/dBHUP/2DUleENpBMnnWJVD7MRDLKf
RIX9RUj13e4xUhyXopIlcPbhRONQ36QHC8PRzL+ONtVXSQrfsHIV4QIpGC0asrZQ
usBoAntU6IAVV/exreVlQoTdIBvfHBsiwTffLXmJ0kkXNdaZI6Ovk/Wk91kTAGsc
e9SurAxwcl/xUqEDWmRvNLQyRhIoTksTiIDKaa2FupLpDUCXz0ZkTPW+JukcJK5w
QMrPvlVV9NIXeBg9IOFp53D/AEUls7fWbtkR0WkKkKX870wqqxFwGs9EMYm00FdG
GndYjuvOAMXVUB0sA3K2v1vCMXhXtTNGD+pwWK0PAHqEXsjBXqHbkNOeANqfY1TQ
YHwORd3DG9gBRVqgOIJ1RE/YtthkmWuuTC248QG2J8hW+YEmdGBIjVYrywhd2yWW
gyR5DJ73YuO7QDFxY7EjM2aaTVHowge1QOFHvvnV9Idu0DW0d8MWslSVfXW2qGVy
FWVwB1i9PNQLizP+ll4aPMvbjClMyGAx/ZJO6kybrbBrgQHW7GRfwmx2lVAsnLLT
wuBKqSVwCLHgecimrgndpTk5H2swUS/owOojKHb1wrjkr6vIKMd+6nKNYhZFDfJp
cpvdjoqqV+oulb5ZkdJZPYXPRzrPRHyxDAPXY16KQgxan+rejnpuKlHPR6S2M40z
9A0yq/YBPL6EdcgObuF5
=pfqv
-----END PGP SIGNATURE-----

--6WSvBTWtJSAwaqHAL2A5Q4eWEQFBCt8CK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
