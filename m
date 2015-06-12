From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Fri, 12 Jun 2015 10:23:25 -0400
Message-ID: <557AEB5D.1040003@redhat.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>	 <1433615915-24591-15-git-send-email-ira.weiny@intel.com>	 <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0@HE1PR05MB1418.eurprd05.prod.outlook.com>	 <1433961446.71666.26.camel@redhat.com>	 <20150610185653.GA28153@obsidianresearch.com> <1433966378.71666.44.camel@redhat.com> <HE1PR05MB141885494D6967919DAE135EB1BC0@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7Xgp2EnrvUBWJp3RnBF32q4niPBqKmpuT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR05MB141885494D6967919DAE135EB1BC0-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7Xgp2EnrvUBWJp3RnBF32q4niPBqKmpuT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 06/11/2015 02:27 PM, Liran Liss wrote:
>> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
>=20
>>>>> OPA cannot impersonate IB; OPA node and link types have to be
>>>>> designated as such.  In terms of MAD processing flows, both
>>>>> explicit (as in the handle_opa_smi() call below) and implicit code
>>>>> paths (which share IB flows - there are several cases) must make
>>>>> this distinction.
>>>>
>>>> As far as in the kernel is concerned, the individual capability bits=

>>>> are much more important.  I would actually like to do away with the
>>>> node_type variable from struct ib_device eventually.  As for user
>>>> space,
>=20
> We agreed on the concept of capability bits for the sake of simplifying=
 code sharing.
> That is OK.
>=20
> But the node_type stands for more than just an abstract RDMA device:
> In IB, it designates an instance of an industry-standard, well-defined,=
 device type: it's possible link types, transport, semantics, management,=
 everything.
> It *should* be exposed to user-space so apps that know and care what th=
ey are running on could continue to work.

I'm sorry, but your argument here is not very convincing at all.  And
it's somewhat hypocritical.  When RoCE was first introduced, the *exact*
same argument could be used to argue for why RoCE should require a new
node_type.  Except then, because RoCE was your own, you argued for, and
got, an expansion of the IB node_type definition that now included a
relevant link_layer attribute that apps never needed to care about
before.  However, now you are a victim of your own success.  You set the
standard then that if the new device can properly emulate an IB Verbs/IB
Link Layer device in terms of A) supported primitives (iWARP and usNIC
both fail here, and hence why they have their own node_types) and B)
queue pair creation process modulo link layer specific addressing
attributes, then that device qualifies to use the IB_CA node_type and
merely needs only a link_layer attribute to differentiate it.

The new OPA stuff appears to be following *exactly* the same development
model/path that RoCE did.  When RoCE was introduced, all the apps that
really cared about low level addressing on the link layer had to be
modified to encompass the new link type.  This is simply link_layer
number three for apps to care about.

> The place for abstraction is in the rdmacm/CMA, which serves applicatio=
ns that just
> want some RDMA functionality regardless of the underlying technology.
>=20
>>>
>>> All SMI code has different behavior if it is running on a switch or
>>> HCA, so testing for 'switchyness' is very appropriate here.
>>
>> Sure...
>>
>>> cap_is_switch_smi would be a nice refinement to let us drop nodetype.=

>>
>> Exactly, we need a bit added to the immutable data bits, and a new cap=
_
>> helper, and then nodetype is ready to be retired.  Add a bit, drop a
>> u8 ;-)
>>
>=20
> This is indeed a viable solution.
>=20
>>> I don't have a problem with sharing the IBA constant names for MAD
>>> structures (like RDMA_NODE_IB_SWITCH) between IB and OPA code. They
>>> already share the structure layouts/etc.
>>>
>=20
> The node type is reflected to user-space, which, as I mentioned above, =
is important.
> Abusing this enumeration is misleading, even in the kernel.
> Jason's proposal for a 'cap_is_switch_smi' is more readable, and direct=
ly in line with
> the explicit capability approach that we discussed.
>=20
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=BF=
=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=BF=
=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=EF=BF=
=BD=D9=9A=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=BF=BD=EF=BF=
=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=BF=BD=1E=EF=
=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=EF=BF=BDj:+v=EF=BF=
=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D
>=20



--7Xgp2EnrvUBWJp3RnBF32q4niPBqKmpuT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVeutdAAoJELgmozMOVy/dK0wP/RtZy4Z33rZX8pyhWuI5cJHc
ncoF9lkHX7DNOLmg//WzCdlPrjnLUtTVKf6KQoQhnqppg9PFUbtvihfJsgdL2Ky0
W5q3jHwsxCWwoeoFx4Z1WFmpWOyf2oxWRrR5h9BgoXwE66CWBDb9p/w1mLe/Py1I
JolOImf+I3KAohsYkDQTK23c7nR57kzk4qmGmO2Sed2lyYVdHM0rbtqbQPQEgKo7
ivHyjJYxUOprpepjHd403tqgAAwldZ2Ak5r7BI4zKBKVZkzj5g57ynGWEOhKPZ0U
POaY/mEB5HTdSdcojieKR5uwV3uRjtpgB06vV9BRpAElNvBFnc2kBsD537xtROVl
eK7b2uHeK7cAbjlhoisFkQp7yK8gPdCJEqat+TxNZ0wfRKSmkIG6+0W573uPJvOu
tXUOHBSOjuBuzPaY/sY1kI4nj9i0hIpLBlzYI1wAS82gfXFHjA3E92XWx57zSkyI
9KdY039K5AilHEFuyzLgcLNrGzQMKRp5sQ8i5B1MIXM5YoW6439wgE02m/J/R77c
sB58KJTUzBigxhd3EXh2TA1Io3+mTDine8WHstg+vlJ36aXYXnsmNv206YEiaPHq
RaoPOS9Hj5BLsx8d/HlsFshg3rVcCyE2Yl1TVbRzDd0jl4ri0RlMYB2WxVxgLtYP
JmUFhz7+3djtVxJePNfb
=k7cw
-----END PGP SIGNATURE-----

--7Xgp2EnrvUBWJp3RnBF32q4niPBqKmpuT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
