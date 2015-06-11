From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Thu, 11 Jun 2015 19:24:48 -0400
Message-ID: <557A18C0.6010200@dev.mellanox.co.il>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>  <1433615915-24591-15-git-send-email-ira.weiny@intel.com>  <HE1PR05MB1418BB6C461790B76D9C02A3B1BD0@HE1PR05MB1418.eurprd05.prod.outlook.com>  <1433961446.71666.26.camel@redhat.com>  <20150610185653.GA28153@obsidianresearch.com> <1433966378.71666.44.camel@redhat.com> <1828884A29C6694DAF28B7E6B8A82373A8FEF1EA@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FEF1EA-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/11/2015 5:00 PM, Hefty, Sean wrote:
>>> cap_is_switch_smi would be a nice refinement to let us drop nodetyp=
e.
>>
>> Exactly, we need a bit added to the immutable data bits, and a new c=
ap_
>> helper, and then nodetype is ready to be retired.  Add a bit, drop a
>> u8 ;-)
>=20
> I agree that the node type enum isn't particularly useful and should =
be retired. =20

Are you referring to kernel space or user space or both ?

> In fact, I don't see where RDMA_NODE_IB_SWITCH is used by any upstrea=
m device. =20

While not upstream, there are at least 2 vendors with one or more switc=
h
device drivers using the upstream stack.

> So I don't think there's any obligation to keep it. =20

In kernel space, we can get rid of it but it's exposed by verbs and
currently relied upon in user space in a number of places.

There's one kernel place that needs more than just cap_is_switch_smi().

> But even if we do, I'm not sure this is the correct approach.  I don'=
t know this for a fact,=20
> but it seems more likely that someone would embed Linux on an IB swit=
ch than they would plug an IB switch=20
> into a Linux based system.  The code is designed around the latter.  =
Making this a system wide setting might simplify the code and optimize =
the code paths.

I think we need to discuss how user space would be addressed.

-- Hal

> - Sean
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=D9=9A=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=BF=
=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=
=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=EF=BF=
=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=BD=EF=
=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
