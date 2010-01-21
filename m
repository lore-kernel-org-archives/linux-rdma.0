From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [PATCH 1/3] rdma_cm: Add support for a new RDMA_PS_LUSTRE
 Lustre port space
Date: Thu, 21 Jan 2010 09:28:40 +0100
Message-ID: <20100121092840.7429e81f@frecb007965>
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
	<20100120101717.60d733e3@frecb007965>
	<4B572099.3030604@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B572099.3030604-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  Hi Or,

On Wed, 20 Jan 2010 17:26:17 +0200
Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org> wrote:

> sebastien dugue wrote:
> >  No, because in OpenSM's QoS logic, there's no way to map the TCP p=
ort
> > space with specific target GUIDs onto an SL. You have keywords for =
SDP, SRP,
> > RDS, ISER, ... but not for the TCP port space (or am I missing some=
thing?).
>=20
> going with this, what prevents you from patching opensm qos engine to=
 support
> the lustre service under the tcp port-space and/or support a combinat=
ion of service=20
> and target port-guid? all in all, first, I don't see what a kernel pa=
tch buys you
> and second, if it buys you something you should be able to gain the s=
ame effect with
> patching open-sm.

  Right, I can indeed achieve that with only a patch to OpenSM. Going w=
ith a
specific Lustre port space is simple and less intrusive although you ha=
ve to
patch the kernel and OpenSM.

  OK, then going with the TCP port space, what we need in OpenSM is a
combination of service id (TCP) _and_ TCP port _and_ target GUID.

  Something like:

  tcp port <lustre TCP port> target-port-guid <Lustre servers GUIDs>

  That way, as you point out, there's absolutely no need for a specific
Lustre specific port space and kernel patch. I just need to extend the
QoS parser logic to add the semantic above.

  I will look into this.

  Thanks, and sorry for the hassle.

  Sebastien.

>=20
> thinking on this a bit more, since the rules are processed by order w=
ouldn't the=20
> following scheme let you achieve the same effect?
>=20
> target-=C2=ADport=C2=ADguid 0x1234,0x1235 : 1 # traffic to MDSs
> lustre                        : 2 # default lustre traffic (to OSSs)
>=20
> Or.
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
