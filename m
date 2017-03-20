From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [RFC v1 for verbs counters]
Date: Mon, 20 Mar 2017 22:25:07 +0000
Message-ID: <SN1PR07MB2207F398C0BCD97CCA86AF16F83A0@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <AM5PR0502MB30578E5BC54125D013D416DCBD250@AM5PR0502MB3057.eurprd05.prod.outlook.com>
 <a2fb88b0-7538-dcbe-7c9c-35a2566818c7@intel.com>
 <HE1PR0502MB30667CF2D73927A036EE4010BD3B0@HE1PR0502MB3066.eurprd05.prod.outlook.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0FBC62@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0FBC62-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Regarding counters width  - After giving it a lot of thought. I believe
> > that 64bit counters are the best
> > decision.
>=20
> I agree - unless we're talking about thousands of counters, smaller ones =
don't seem worth the additional complexity to
> save a few bytes.
>=20
> > a) Allowing more than one size of counters will make the memory
> > allocation and data parsing harder.
> >
> > b) 64bit is exactly the right size.

I agree on this size.

>=20
> Well, I wouldn't go this far.
>=20
> Is there a need to indicate if hardware doesn't actually support 64-bits?

I'm guessing that most, if not all, HW support 64-bits counters.
If not then the driver can overcome this by storing the previously read val=
ue and
reporting a 64-bit value (aggregate). This is cumbersome for the driver but=
 simplifies
the common implementation.

Ram






--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
