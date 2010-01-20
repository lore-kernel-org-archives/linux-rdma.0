From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [PATCH 1/3] rdma_cm: Add support for a new RDMA_PS_LUSTRE
 Lustre port space
Date: Wed, 20 Jan 2010 08:55:30 +0100
Message-ID: <20100120085530.5d675ef8@frecb007965>
References: <20100113154952.0f01aa1d@frecb007965>
	<20100113155150.59867f40@frecb007965>
	<7ED07283D76C422C9210FBE7C832731B@amr.corp.intel.com>
	<ada6376ndgs.fsf@roland-alpha.cisco.com>
	<20100114135815.69d5a9a5@frecb007965>
	<ada3a28mwdw.fsf@roland-alpha.cisco.com>
	<20100115084102.2258eba8@frecb007965>
	<adaiqax37g4.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaiqax37g4.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  Hi Roland,

On Tue, 19 Jan 2010 17:12:43 -0800
Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:

>=20
>  >   Well, without a specific port space, the default for Lustre is t=
o use the
>  > TCP port space so you cannot distinguish Lustre traffic from other=
 traffic using
>  > that same port space.
>=20
> I'm still a bit confused.  The problem as I understand it is that Lus=
tre
> always uses the same TCP port, so there's no way to apply different Q=
oS
> to different types of Lustre traffic.

  Right, all Lustre servers (MDS and OSS) use the same TCP port, so the=
re's no
way to distinguish between the 2 types of traffic.

>  But if we create a new port space
> and don't change the ports that Lustre uses, then there's still no wa=
y
> to apply different QoS for different Lustre traffic.

  With the OpenSM patch and the Lustre port space, you can map Lustre t=
raffic
to specific target port GUIDs onto a specific SL hence separating the f=
lows.

>  So I guess you
> need to change the ports used within the new port space -- but then w=
hy
> can't you just stay in the TCP space but change the ports used?

  No, with the new port space, there's no need to change ports. You onl=
y need
to specify the target GUIDs.

  For example:

    qos-=C2=ADulps=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0default=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0	      :=C2=A00=C2=A0#=C2=A0default=C2=A0SL
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0lustre,=C2=A0target-=C2=
=ADport=C2=ADguid=C2=A00x1234,0x1235=C2=A0:=C2=A01=C2=A0#=C2=A0lustre=C2=
=A0traffic to MDSs
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0lustre=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0	      :=C2=A02=C2=A0#=C2=A0default lustre traffic (t=
o OSSs)
    end=C2=AD-qos-=C2=ADulps


  Hope this helps clarify things a bit.

  Thanks,

  S=C3=A9bastien.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
