From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [PATCH 1/3] rdma_cm: Add support for a new RDMA_PS_LUSTRE
 Lustre port space
Date: Wed, 20 Jan 2010 10:17:17 +0100
Message-ID: <20100120101717.60d733e3@frecb007965>
References: <20100113154952.0f01aa1d@frecb007965>
	<20100113155150.59867f40@frecb007965>
	<7ED07283D76C422C9210FBE7C832731B@amr.corp.intel.com>
	<ada6376ndgs.fsf@roland-alpha.cisco.com>
	<20100114135815.69d5a9a5@frecb007965>
	<ada3a28mwdw.fsf@roland-alpha.cisco.com>
	<20100115084102.2258eba8@frecb007965>
	<adaiqax37g4.fsf@roland-alpha.cisco.com>
	<20100120085530.5d675ef8@frecb007965>
	<4B56B8E3.3010909@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B56B8E3.3010909-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 20 Jan 2010 10:03:47 +0200
Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> sebastien dugue wrote:
> >> So I guess you need to change the ports used within the new port s=
pace -- but then=20
> >> why can't you just stay in the TCP space but change the ports used=
?
> >>    =20
> >
> > No, with the new port space, there's no need to change ports. You o=
nly need to specify the target GUIDs. For example:
> >         lustre, target-=C2=ADport=C2=ADguid 0x1234,0x1235 : 1 # lus=
tre traffic to MDSs
> >         lustre                  	      : 2 # default lustre traffic=
 (to OSSs)
> > Hope this helps clarify things a bit.
> >  =20
> sorry, but it doesn't,  as far as I understand there are three=20
> possibilities for what the string "lustre" is being translated to
> by the opensm QoS logic:
>=20
> (A) lustre port in the TCP port space
> (B) lustre port space
> (C) nothing (that is not a service, in the same manner that ipoib jus=
t=20
> doesn't mean anything to opensm)

  I'm not sure I'm following you here.

  With the patches, the 'lustre' keyword is being translated to the lus=
tre
port space and only to that port space, never to the TCP port space. So=
 if
I'm understanding you correctly, it's B.=20

>=20
> Assuming C is not the case, then either A or B will yield the same=20
> result and as such the new port space buys you nothing.

  No, because in OpenSM's QoS logic, there's no way to map the TCP port
space with specific target GUIDs onto an SL. You have keywords for SDP,=
 SRP,
RDS, ISER, ... but not for the TCP port space (or am I missing somethin=
g?).

  What B buys you is the ability to map Lustre traffic to a specific
target GUID onto an SL.

  An alternative would be to be able to map the TCP port space to a spe=
cific
port and specific target GUIDs onto an SL in OpenSM's QoS configuration=
, but
that's currently not possible.

  S=C3=A9bastien.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
