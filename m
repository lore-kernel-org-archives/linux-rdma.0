From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Please update the linux-next location for the RDMA subsystem
Date: Wed, 29 Nov 2017 11:12:44 -0500
Message-ID: <9a80e43d-d32a-742b-fa6b-adacb152e8dd@redhat.com>
References: <1510948060.3973.29.camel@redhat.com>
 <20171119064640.GV18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Rq4e6NHrlSUonJtVxrjnfTepmCMnhmavv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171119064640.GV18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Rq4e6NHrlSUonJtVxrjnfTepmCMnhmavv
Content-Type: multipart/mixed; boundary="sPaakwE1LvEiAdDUwHOmEX3FvSwFpjFav";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Message-ID: <9a80e43d-d32a-742b-fa6b-adacb152e8dd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Please update the linux-next location for the RDMA subsystem
References: <1510948060.3973.29.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20171119064640.GV18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20171119064640.GV18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--sPaakwE1LvEiAdDUwHOmEX3FvSwFpjFav
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/19/17 1:46 AM, Leon Romanovsky wrote:
> On Fri, Nov 17, 2017 at 02:47:40PM -0500, Doug Ledford wrote:
>> Hi Stephen,
>>
>> Jason Gunthorpe is now co-maintaining the RDMA subsystem with me.  We
>> have a shared repo that we can both write into.  I would like you to r=
e-
>> aim the RDMA linux-next pull point to:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-
>> next
>=20
> Doug,
>=20
> Does it make sense to get rid of "k.o" notation for for-next and for-rc=
 branches?
> It is already on kernel.org and seems to me as a redundant.

Jason and I talked about this offline.  The reason it's there is
actually more technical than anything else.  In order to have WIP
branches that you want to quickly/easily get on github, but to not have
them pollute k.o with WIP branches that haven't passed 0day yet, the
easy solution is to add this to your .git/config for your kernel repo:

        push =3D refs/heads/k.o/*:refs/heads/k.o/*
        push =3D +refs/tags/for-linus*:refs/tags/for-linus*
        push =3D +refs/tags/for-next*:refs/tags/for-next*
        push =3D refs/heads/master:refs/heads/master

That keeps only the stuff you really want going to k.o going there, and
everything can then go to your WIP repository.  Going forward, whether
Jason decides to use a github repo for 0day like I do or not, it now has
a second benefit in that we can each have our own private namespace,
which is basically anything not in k.o/, and treat the k.o/ namespace as
a shared namespace where we worry about branch name conflicts, fast
forward only updates, etc.  So, it's redundant to the people pulling,
but I still think it has value for Jason and I.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--sPaakwE1LvEiAdDUwHOmEX3FvSwFpjFav--

--Rq4e6NHrlSUonJtVxrjnfTepmCMnhmavv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloe3HwACgkQuCajMw5X
L93CRg//cZI+IJVccZf/NOjQwPpbCy73dVaXYzfOxWUfYnJ2fLZ/r5CNxdJFbUqA
rO+tTT31Lx6ib6E58/SYkN3/mtZqNNwGqsF25Jb7jvJ0zLASJxUetEBWEpw3scMI
xaI1LoMNCy+bRiG53dPFq9XGovbkjKFzj2nmAiM67+qeZ20bvESWIqgs1KN082sO
VKJcXb+7ekfG1/f5PyTTGkEn3mvXtvdUXsWQpghBUELuU8IIZ1DfnzNa/s8+OWU9
m2koWXgc1idspOsPocEe73sWKv/N7wRd0NY456MOFl03Nvtwh42pDA5paHSWyXoq
1H48EJeAtEptr0rgUV8hnb5v34EI3neJG0sQLT5MaAIy53IA5aBLd84/ihIN91w1
/Ambsy3ZvkyBvo8NygMase4VxSq6MHG7j9ZDLQTb2HQ5/Yz0xjJgLkxr4QHYJ7L6
zC/q8oL9x3RfVmgNLIPOFIR+2n6ysjDVV9vvONQZbvE+b/P94KxksL3tCb69/adX
Pq8Loq3VQLEslWMHqNlz15jiiuae6WuexL4HnQ/vzV08MQROFnlZXh8VjlKSB7Z9
gA/HCUzfp2xU4L5cVTHVQe2xFgarAIBTFETzw6qywmxAGXtg51kt4W8T0TXN+P5g
OXJkFIUnIRA8ifrbStaNoWTDhP15QIynrB1e/f8aU71ECk8N1Ug=
=JcDo
-----END PGP SIGNATURE-----

--Rq4e6NHrlSUonJtVxrjnfTepmCMnhmavv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
