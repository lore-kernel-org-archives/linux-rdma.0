From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Thu, 18 Jun 2015 17:00:04 -0400
Message-ID: <953CDD5A-2738-4427-B763-EBFB4BBB2E03@redhat.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com> <1433615915-24591-15-git-send-email-ira.weiny@intel.com> <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0@HE1PR05MB1418.eurprd05.prod.outlook.com> <1433961446.71666.26.camel@redhat.com> <20150610185653.GA28153@obsidianresearch.com> <1433966378.71666.44.camel@redhat.com> <HE1PR05MB141885494D6967919DAE135EB1BC0@HE1PR05MB1418.eurprd05.prod.outlook.com> <557AEB5D.1040003@redhat.com> <HE1PR05MB14182DCD7003B52A28BB62A5B1B90@HE1PR05MB1418.eurprd05.prod.outlook.com> <557E6514.1060600@redhat.com> <HE1PR05MB1418C8F8E54FCC790B0CCAE3B1A70@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: multipart/signed; boundary="Apple-Mail=_AF439F8A-CB9F-4BDF-AB41-8317E86D2E68"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB1418C8F8E54FCC790B0CCAE3B1A70-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_AF439F8A-CB9F-4BDF-AB41-8317E86D2E68
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Jun 16, 2015, at 5:05 PM, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>=20
>> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
>=20
>>> No. RoCE is as an open standard from the IBTA with the exact same =
RDMA
>> protocol semantics as InfiniBand and a clear set of compliancy rules =
without
>> which an implementation can't claim to be such. A RoCE device *is* an =
IB CA
>> with an Ethernet link.
>>> In contrast, OPA is a proprietary protocol. We don't know what =
primitives
>> are supported, and whether the semantics of supported primitives are =
the
>> same as in InfiniBand.
>>=20
>> Intel has stated on this list that they intend for RDMA apps to run =
on
>> OPA transparently.  That pretty much implies the list of primitives =
and
>> everything else that they must support.  However, time will tell if =
they
>> succeeded or not.
>>=20
>=20
> I am sorry, but that's not good enough.
> When I see an IB device, I know exactly what to expect. I can't say =
anything regarding an OPA device.
>=20
> It might be that today the semantics are "close enough".
> But in the future, both feature sets and semantics may diverge =
considerably.
> What are you going to do then?
>=20
> In addition, today, the host admin knows that 2 IB CA nodes will =
always interoperate. If you share the node type with OPA, everything =
breaks down. There is no way of knowing which devices work with which.

You=E2=80=99ve not done yourself any favors with this argument.  =
You=E2=80=99ve actually stretched yourself into the land of hyperbole =
and FUD in order to make this.  Do you not see that =E2=80=9C2 IB CA =
nodes will always interoperate=E2=80=9D is not true as soon as you =
consider differing link layer types?  For example, an mlx4_en device =
will not interoperate with a qib device, yet they are both IB_CA node =
types.  Conflating allowing an OPA device to be node type IB_CA and link =
layer OPA to everything breaking down is pure and utter rubbish.  And =
with that, we are done with this discussion.  I=E2=80=99ve detailed what =
my litmus test will be, and I=E2=80=99m sticking with exactly that.

In the case of iWARP and usNIC, there are significant differences from =
an IB_CA that render a program responsible for possibly altering its =
intended transfer mechanism significantly (for instance usNIC is UD =
only, iWARP can=E2=80=99t do atomics or immediate data, so any transfer =
engine design that uses either of those is out of the question).  On the =
other hand, everything that uses IB_CA supports the various primitives =
and only vary in their addressing/management.  If OPA stays true to that =
(and it certainly does so far by supporting the same verbs as qib), then =
IB_CA/link_layer OPA is perfectly acceptable and in fact preferred due =
to the fact that it will produce the minimum amount of change in user =
space applications before they can support the OPA devices.

>> So this will be my litmus test.  Currently, an app that supports all =
of
>> the RDMA types looks like this:
>>=20
>> if (node_type =3D=3D RNIC)
>> 	do iwarpy stuff
>> else if (node_type =3D=3D USNIC)
>> 	do USNIC stuff
>> else if (node_type =3D=3D IB_CA)
>> 	do IB verbs stuff
>> 	if (link_layer =3D=3D Ethernet)
>> 		do RoCE addressing/management
>> 	else
>> 		do IB addressing/management
>>=20
>>=20
>>=20
>> If, in the end, apps that are modified to support OPA end up looking
>> like this:
>>=20
>> if (node_type =3D=3D RNIC)
>> 	do iwarpy stuff
>> else if (node_type =3D=3D USNIC)
>> 	do USNIC stuff
>> else if (node_type =3D=3D IB_CA || node_type =3D=3D OPA_CA)
>> 	do IB verbs stuff
>> 	if (node_type =3D=3D OPA_CA)
>> 		do OPA addressing/management
>> 	else if (link_layer =3D=3D Ethernet)
>> 		do RoCE addressing/management
>> 	else
>> 		do IB addressing/management
>>=20
>> where you can plainly see that the exact same goal can be =
accomplished
>> whether you have an OPA node_type or an IB_CA node_type + OPA
>> link_layer, then I will be fine with either a new node_type or a new
>> link_layer.  They will be functionally equivalent as far as I'm =
concerned.
>>=20
>=20
> It is true that for some applications, your abstraction might work =
transparently.
> But for other applications, your "do IB verbs stuff" (and not just the =
addressing/management) will either break today or break tomorrow.

FUD.  Come to me when you have a concrete issue and not hand-wavy scare =
mongering.

> This is bad both for IB and for OPA.

No, it=E2=80=99s not.

> Why on earth are we putting ourselves into a position which could =
easily be avoided in the first place?
>=20
> The solution is simple:
> - As an API, Verbs will support IB/ROCE, iWARP, USNIC, and OPA

There is *zero* functional difference between node_type =3D=3D OPA or =
node_type =3D=3D IB_CA and link_layer =3D=3D OPA. An application has =
*exactly* what they need to do everything you have mentioned.  It =
changes the test the application makes, but not what the application =
does.

> - The node type and link type refer to specific technologies

Yes, and Intel has made it clear that they are copying IB Verbs as a =
technology.  It is common that the one being copied be pissed off by the =
copying, but it is also common that they can=E2=80=99t do a damn thing =
about it.

> -- Most applications indeed don't care and don't check either of these =
properties anyway
> -- Those that do, do it for a good reason; don't break them
> - Management helpers will do a good job to keep the code maintainable =
and efficient even if OPA and IB have different node types
>=20
> Win-win situation...
> --Liran
>=20
>=20
>=20
> =
N=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BDy=EF=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BD=
X=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD{#<^_NSED=
R_^#<=D9=9A=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=BF=BDf=EF=
=BF=BDh=EF=BF=BD=EF=BF=BDz=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=0C=
=EF=BF=BDj:+v=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=
=BF=BDzZ+=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=BD!

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_AF439F8A-CB9F-4BDF-AB41-8317E86D2E68
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVgzFUAAoJELgmozMOVy/dcqcP/2mfHhWMTiZp+cmnyHqRx1Ag
D9k0NLRGYLZRPSr3/WgdR8A17DXFIxxnbdcqf2TRX4EDQR4rXo2JpdVDyWWQ1yTd
XREfGhSG+xknY5hjkRAu5T2rbcGMRa8JCHx+TUqd8dszrcnJEPC8mQrd8au7czN8
Fc9RNHiQNP7P/w0Yy7PKbomoaAbZwcb2Iw+vSWIYlwdBCxHwmapt1dTg1JWdYFK8
V4qxqMg7SeZ2ApWVpFXAI877GVWgl/EbeFFEBwhDXhOO+67qOt5HZlhuh0A/9p/R
ZKtyDtc/M40W+juIcWfFnsBnSzOr/LymMxQVFsA0Q3VA2KiA+3jwzwz51afPhdno
xLOmqXzyil3nGAG/N1X1AkeXR0X8U3ejmoU23WKcAZM2bNTysJTl2aoIYGFqNNjn
c5G4Y+3fvOVth03zqwLXAdDujCB5TTRjUa/DCFxGJmDXmv4ejZTDNU4ddtaaep5R
pEl9wyTHmBLIAnBkvP5/+gCU+uICTTp7WvC5X9PmD/+C8FHCGfPU/YH1/vIg9+5o
CKd/MC1XYS8UMmw8VjN0GExBeT3UKEd5pjiXMi0FS3rhwAL+JhzZ9eD8A6C6avYP
Vhedmj9hHqyBJwXhA1rE8qHjqgrtudVuM/CtZIW37A22EPUkrv6J5paHYGGDiVCl
0tDKaqB3GUrTGFI+FBCq
=N92G
-----END PGP SIGNATURE-----

--Apple-Mail=_AF439F8A-CB9F-4BDF-AB41-8317E86D2E68--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
