From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [ewg] DHCP over InfiniBand Update
Date: Mon, 6 Sep 2010 15:26:12 +0200
Message-ID: <20100906152612.4bf54c29@frecb007965>
References: <AANLkTinc9dER+PkBO9Yv=oeGd8NcjFtvSRa7+tXkpb+B@mail.gmail.com>
	<20100906150323.1e1b44c2@frecb007965>
	<AANLkTik1HhLoue-b+BhsnFm+MU3=MUJFBz391EUxTfw=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik1HhLoue-b+BhsnFm+MU3=MUJFBz391EUxTfw=@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: dhcp-users-/1rEenAg/5e+51mZqJFLXQ@public.gmane.org, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 6 Sep 2010 09:15:50 -0400
Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi S=C3=A9bastien,
>=20
> On Mon, Sep 6, 2010 at 9:03 AM, sebastien dugue
> <sebastien.dugue-6ktuUTfB/bM@public.gmane.org> wrote:
> > =C2=A0Hi Hal,
> >
> > On Tue, 31 Aug 2010 16:09:19 -0400
> > Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Hi,
> >>
> >> There appear to be two basic approaches to supporting DHCP (over
> >> InfiniBand) in Linux. There's LPF support (4.1.1 based) and older
> >> (3.0.4 based) socket support.
> >>
> >> The 4.1.1 LPF patches are:
> >> http://lists.openfabrics.org/pipermail/ewg/2010-May/015265.html
> >> http://lists.openfabrics.org/pipermail/ewg/2010-May/015266.html
> >> http://lists.openfabrics.org/pipermail/ewg/2010-May/015264.html
> >> The last being Matthieu Hautreux's <matthieu.hautreux at cea.fr>
> >> improved XID generation (same as
> >> https://lists.isc.org/mailman/htdig/dhcp-hackers/2009-January/0017=
73.html).
> >>
> >> AFAIT an LPF based approach will only work on older kernels (due t=
o
> >> elimination of CONFIG_FILTER support). Is this accurate ?
> >
> > =C2=A0Where have you seen that the LPF approach does not work on re=
cent kernels?
> > AFAICR, the CONFIG_FILTER disappeared a long time ago. Unless I'm m=
issing
> > something, you only need the CONFIG_PACKET option.
>=20
> The question was based on the README and some code in lpf.c but it
> sounds those comments relating to CONFIG_FILTER relate to 2.4 and not
> to 2.6 based kernels then. All that is needed with a 2.6 kernel is
> CONFIG_PACKET so the PF_PACKET socket can be created and used by lpf.
> Right ?

  Absolutely right.

>=20
> Out of curiousity, why did you choose a PF_PACKET rather than a UDP
> socket based approach ? The UDP socket approach seems simpler but
> maybe has some other pitfalls.

  For unknown reasons which I did not have time to investigate at the
time, I could not make it work using a plain UDP socket which I agree
should be straightforward. So I did it the LPF way.


  S=C3=A9bastien.
 =20

>=20
> Thanks again.
>=20
> -- Hal
>=20
> > =C2=A0S=C3=A9bastien.
> >
> >
> >>
> >> OFED has two patches for 3.0.4 for a socket approach in
> >> http://www.openfabrics.org/git/?p=3D~tziporet/docs.git;a=3Dtree;f=3D=
dhcp;h=3Daec68a2905559c8ed91f1157fa11d78cccb266cd;hb=3Dofed_1_5
> >> dhcp-3.0.4.patch
> >> 0001-Make-DHCP-server-print-HW-info.patch
> >>
> >> I've been upporting those to a 4.x based DHCP and have a fundament=
al
> >> question which occurs even with the 3.0.4 socket based version. On=
 the
> >> client machine, the DHCPOFFER in response to the DHCPDISCOVER is
> >> received (seen with tcpdump) but never seems to make it to the
> >> dhclient application. I can't see any kernel stack error counters
> >> incremented so I'm mystified as to what could be going wrong. I've
> >> also tried this on a number of different kernels. Any idea on why =
this
> >> might be or how to figure out where that packet is going ? I do se=
e
> >> the dhcp client port with netstat -a --udp -n
> >> udp =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A00 0.0.0.0:68 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.0.0.0:*
> >> udp =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A00 0.0.0.0:68 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.0.0.0:*
> >> Any idea on what I'm missing ?
> >>
> >> Also, is any of this work making it's way into a released DHCP ?
> >> What's the process for this ? Is there some branch in a source
> >> repository where this work is available ?
> >>
> >> Thanks in advance for any pointers on all this.
> >>
> >> -- Hal
> >> _______________________________________________
> >> ewg mailing list
> >> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> >> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
> >>
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
