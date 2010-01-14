From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [PATCH 1/3] rdma_cm: Add support for a new RDMA_PS_LUSTRE
 Lustre port space
Date: Thu, 14 Jan 2010 15:37:49 +0100
Message-ID: <20100114153749.11430b0f@frecb007965>
References: <20100113154952.0f01aa1d@frecb007965>
	<20100113155150.59867f40@frecb007965>
	<7ED07283D76C422C9210FBE7C832731B@amr.corp.intel.com>
	<20100114134713.01f2bb58@frecb007965>
	<4B4F25A7.6000900@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B4F25A7.6000900-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  Hi Or,

On Thu, 14 Jan 2010 16:09:43 +0200
Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org> wrote:

> sebastien dugue wrote:
> > That can be done with port numbers, except that we cannot separate
> > traffic to Lustre MDS and traffic to Lustre OSS=20
>=20
> Looking on these patches and going with you for a minute, I don't see=
 how this patch set serves you to assign a different QoS level (e.g SL)=
 to MDS vs OSS related traffic. Can you elaborate on that a bit?

  If you can specify a target-port-guid to the Lustre service ID in Ope=
nSM's
qos-policy.conf then you're all set.

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


>=20
> Sean Hefty wrote:
> > Can't this be done using port numbers in the existing port space?
>=20
> Indeed, Sebastien what prevents you from using the TCP port space, wi=
th one port used for MDS traffic and another port for OSS traffic? how =
does Lustre get ports to listen on, are they well known or you call bin=
d with port zero and use the port allocated by the rdma-cm?

  I'm not a Lustre expert (far from it), but after talking with our Lus=
tre guys,
it seems that all Lustre servers, OSS or MDS, use the same TCP port. So=
 there's
no possible way to separate traffic based on TCP port only.

  Thanks,

  S=C3=A9bastien.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
