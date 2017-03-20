From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC v1 for verbs counters]
Date: Mon, 20 Mar 2017 18:34:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0FBC62@ORSMSX109.amr.corp.intel.com>
References: <AM5PR0502MB30578E5BC54125D013D416DCBD250@AM5PR0502MB3057.eurprd05.prod.outlook.com>
 <a2fb88b0-7538-dcbe-7c9c-35a2566818c7@intel.com>
 <HE1PR0502MB30667CF2D73927A036EE4010BD3B0@HE1PR0502MB3066.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR0502MB30667CF2D73927A036EE4010BD3B0-692Kmc8YnlInzEhYgqUDPcDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Regarding counters width  - After giving it a lot of thought. I believe
> that 64bit counters are the best
> decision.

I agree - unless we're talking about thousands of counters, smaller ones do=
n't seem worth the additional complexity to save a few bytes.

> a) Allowing more than one size of counters will make the memory
> allocation and data parsing harder.
>=20
> b) 64bit is exactly the right size.

Well, I wouldn't go this far.

Is there a need to indicate if hardware doesn't actually support 64-bits?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
