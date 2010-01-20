From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3] rdma_cm: Add support for a new RDMA_PS_LUSTRE	Lustre
 port space
Date: Wed, 20 Jan 2010 17:26:17 +0200
Message-ID: <4B572099.3030604@Voltaire.com>
References: <20100113154952.0f01aa1d@frecb007965>	<20100113155150.59867f40@frecb007965>	<7ED07283D76C422C9210FBE7C832731B@amr.corp.intel.com>	<ada6376ndgs.fsf@roland-alpha.cisco.com>	<20100114135815.69d5a9a5@frecb007965>	<ada3a28mwdw.fsf@roland-alpha.cisco.com>	<20100115084102.2258eba8@frecb007965>	<adaiqax37g4.fsf@roland-alpha.cisco.com>	<20100120085530.5d675ef8@frecb007965> <4B56B8E3.3010909@voltaire.com> <20100120101717.60d733e3@frecb007965>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100120101717.60d733e3@frecb007965>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

sebastien dugue wrote:
>  No, because in OpenSM's QoS logic, there's no way to map the TCP por=
t
> space with specific target GUIDs onto an SL. You have keywords for SD=
P, SRP,
> RDS, ISER, ... but not for the TCP port space (or am I missing someth=
ing?).

going with this, what prevents you from patching opensm qos engine to s=
upport
the lustre service under the tcp port-space and/or support a combinatio=
n of service=20
and target port-guid? all in all, first, I don't see what a kernel patc=
h buys you
and second, if it buys you something you should be able to gain the sam=
e effect with
patching open-sm.

thinking on this a bit more, since the rules are processed by order wou=
ldn't the=20
following scheme let you achieve the same effect?

target-=C2=ADport=C2=ADguid 0x1234,0x1235 : 1 # traffic to MDSs
lustre                        : 2 # default lustre traffic (to OSSs)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
