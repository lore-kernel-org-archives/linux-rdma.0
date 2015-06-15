From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Mon, 15 Jun 2015 01:39:32 -0400
Message-ID: <557E6514.1060600@redhat.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>	 <1433615915-24591-15-git-send-email-ira.weiny@intel.com>	 <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0@HE1PR05MB1418.eurprd05.prod.outlook.com>	 <1433961446.71666.26.camel@redhat.com>	 <20150610185653.GA28153@obsidianresearch.com> <1433966378.71666.44.camel@redhat.com> <HE1PR05MB141885494D6967919DAE135EB1BC0@HE1PR05MB1418.eurprd05.prod.outlook.com> <557AEB5D.1040003@redhat.com> <HE1PR05MB14182DCD7003B52A28BB62A5B1B90@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NgJf46hciMrH5tMv3euGvwaTsBEWtvTDi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB14182DCD7003B52A28BB62A5B1B90-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NgJf46hciMrH5tMv3euGvwaTsBEWtvTDi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06/14/2015 03:16 PM, Liran Liss wrote:
>> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
>=20
>>> But the node_type stands for more than just an abstract RDMA device:
>>> In IB, it designates an instance of an industry-standard, well-define=
d,
>> device type: it's possible link types, transport, semantics, managemen=
t,
>> everything.
>>> It *should* be exposed to user-space so apps that know and care what
>> they are running on could continue to work.
>>
>> I'm sorry, but your argument here is not very convincing at all.  And
>> it's somewhat hypocritical.  When RoCE was first introduced, the *exac=
t*
>> same argument could be used to argue for why RoCE should require a new=

>> node_type.  Except then, because RoCE was your own, you argued for, an=
d
>> got, an expansion of the IB node_type definition that now included a
>> relevant link_layer attribute that apps never needed to care about
>> before.  However, now you are a victim of your own success.  You set t=
he
>> standard then that if the new device can properly emulate an IB Verbs/=
IB
>> Link Layer device in terms of A) supported primitives (iWARP and usNIC=

>> both fail here, and hence why they have their own node_types) and B)
>> queue pair creation process modulo link layer specific addressing
>> attributes, then that device qualifies to use the IB_CA node_type and
>> merely needs only a link_layer attribute to differentiate it.
>>
>=20
> No. RoCE is as an open standard from the IBTA with the exact same RDMA =
protocol semantics as InfiniBand and a clear set of compliancy rules with=
out which an implementation can't claim to be such. A RoCE device *is* an=
 IB CA with an Ethernet link.
> In contrast, OPA is a proprietary protocol. We don't know what primitiv=
es are supported, and whether the semantics of supported primitives are t=
he same as in InfiniBand.

Intel has stated on this list that they intend for RDMA apps to run on
OPA transparently.  That pretty much implies the list of primitives and
everything else that they must support.  However, time will tell if they
succeeded or not.

>> The new OPA stuff appears to be following *exactly* the same developme=
nt
>> model/path that RoCE did.  When RoCE was introduced, all the apps that=

>> really cared about low level addressing on the link layer had to be
>> modified to encompass the new link type.  This is simply link_layer
>> number three for apps to care about.
>>
>=20
> You are missing my point. API transparency is not a synonym for full se=
mantic equivalence.  The Node Type doesn=E2=80=99t indicate level of adhe=
rence to an API. Node Type indicates compliancy to a  specification (e.g.=
 wire protocol, remote order of execution, error semantics, architectural=
 limitations, etc). The IBTA CA and Switch Node Types belong to devices t=
hat are compliant to the corresponding specifications from the InfiniBand=
 Trade Association.  And that doesn=E2=80=99t prevent applications to cho=
ose to be coded to run over nodes of different Node Type as it happens to=
day with IB/RoCE and iWARP.
>=20
> This has nothing to do with addressing.

And whether you like it or not, Intel is intentionally creating a
device/fabric with the specific intention of mimicking the IB_CA device
type (with stated exceptions for MAD packets and addresses).  They
obviously won't have certification as an IB_CA, but that's not their
aim.  Their aim is to be a functional drop in replacement that apps
don't need to know about except for the stated exceptions.

And I'm not missing your point.  Your point is inappropriate.  You're
trying to conflate certification with a functional API.  The IB_CA node
type is not an official certification of anything, and the linux kernel
is not an official certifying body for anything.  If you want
certification, you go to the OFA and the UNH-IOL testing program.
There, you have the rights to the certification branding logo and you
have the right to deny access to that logo to anyone that doesn't meet
the branding requirements.

You're right that apps can be coded to other CA types, like RNICs and
USNICs.  However, those are all very different from an IB_CA due to
limited queue pair types or limited primitives.  If OPA had that same
limitation then I would agree it needs a different node type.

So this will be my litmus test.  Currently, an app that supports all of
the RDMA types looks like this:

if (node_type =3D=3D RNIC)
	do iwarpy stuff
else if (node_type =3D=3D USNIC)
	do USNIC stuff
else if (node_type =3D=3D IB_CA)
	do IB verbs stuff
	if (link_layer =3D=3D Ethernet)
		do RoCE addressing/management
	else
		do IB addressing/management



If, in the end, apps that are modified to support OPA end up looking
like this:

if (node_type =3D=3D RNIC)
	do iwarpy stuff
else if (node_type =3D=3D USNIC)
	do USNIC stuff
else if (node_type =3D=3D IB_CA || node_type =3D=3D OPA_CA)
	do IB verbs stuff
	if (node_type =3D=3D OPA_CA)
		do OPA addressing/management
	else if (link_layer =3D=3D Ethernet)
		do RoCE addressing/management
	else
		do IB addressing/management

where you can plainly see that the exact same goal can be accomplished
whether you have an OPA node_type or an IB_CA node_type + OPA
link_layer, then I will be fine with either a new node_type or a new
link_layer.  They will be functionally equivalent as far as I'm concerned=
=2E

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--NgJf46hciMrH5tMv3euGvwaTsBEWtvTDi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVfmUbAAoJELgmozMOVy/d5ToP/3daJ3uYWXMsOWl8gUcHZRtB
NAfY60wXK85CbXZ0+vesD+WLQvcxJIstNTXE2l7BSTmEtWLT72WGRiuICvM8+JDm
0TYcsMM5aNT9Kw1hambeVGdEtBI4cMoOhBzzDbXoSjys3KxRtDZ0OZePdSAZTpQQ
A/6ZA4dzi0VjT6eXcyivLosPyfv507BhogHOg+Kcnw3cd5vuYtnaqp6Bs+dAsn6E
TNNjKw+C4aZzeDnQhLLXvbNJ05CGePNaKrEOO/hztUMB8+6NRO4dMJHnHHx/UqsN
puxAZAFgJcEmoBxdZhH74kce2mg0jJgQNXScspudJWuDJ6Yq84ILcEK9yGK+Hoqj
336LeEW9chwfuPYuLzFh2NXJFgLCobfaY1p5Cri+qsU1yaUhjZbZK0DUO9HajFwq
ubP74mqAQISaoh0zzVwNM5LVBAhJFkfRfGTp+ZSvO34zF0e9t0n0Nl+Tg0PuUID3
A4vTHaoy1nh51vLJX7X0b2HVFvGDtzllFv3zXKrraLPRBqWwhc+c+IQ1KHMViIa3
tYL3frGj6W3IWkOqIsH5s7/PGtRSM4Aje3OhxQMfRLPWKtWJJY+MGFzflSkCO4B4
JoMR5JIDq+rjgbnUIpVr/eB6WLm3/AQhvoOgZEtK3DY/nRsmFoImJckML2qR7gRY
Jh0jGRbhukf0z0BUFCQS
=C7TL
-----END PGP SIGNATURE-----

--NgJf46hciMrH5tMv3euGvwaTsBEWtvTDi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
