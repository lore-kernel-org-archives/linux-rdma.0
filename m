From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [ewg] DHCP over InfiniBand Update
Date: Mon, 6 Sep 2010 15:03:23 +0200
Message-ID: <20100906150323.1e1b44c2@frecb007965>
References: <AANLkTinc9dER+PkBO9Yv=oeGd8NcjFtvSRa7+tXkpb+B@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinc9dER+PkBO9Yv=oeGd8NcjFtvSRa7+tXkpb+B-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: dhcp-users-/1rEenAg/5e+51mZqJFLXQ@public.gmane.org, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  Hi Hal,

On Tue, 31 Aug 2010 16:09:19 -0400
Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi,
>=20
> There appear to be two basic approaches to supporting DHCP (over
> InfiniBand) in Linux. There's LPF support (4.1.1 based) and older
> (3.0.4 based) socket support.
>=20
> The 4.1.1 LPF patches are:
> http://lists.openfabrics.org/pipermail/ewg/2010-May/015265.html
> http://lists.openfabrics.org/pipermail/ewg/2010-May/015266.html
> http://lists.openfabrics.org/pipermail/ewg/2010-May/015264.html
> The last being Matthieu Hautreux's <matthieu.hautreux at cea.fr>
> improved XID generation (same as
> https://lists.isc.org/mailman/htdig/dhcp-hackers/2009-January/001773.=
html).
>=20
> AFAIT an LPF based approach will only work on older kernels (due to
> elimination of CONFIG_FILTER support). Is this accurate ?

  Where have you seen that the LPF approach does not work on recent ker=
nels?
AFAICR, the CONFIG_FILTER disappeared a long time ago. Unless I'm missi=
ng
something, you only need the CONFIG_PACKET option.

  S=C3=A9bastien.


>=20
> OFED has two patches for 3.0.4 for a socket approach in
> http://www.openfabrics.org/git/?p=3D~tziporet/docs.git;a=3Dtree;f=3Dd=
hcp;h=3Daec68a2905559c8ed91f1157fa11d78cccb266cd;hb=3Dofed_1_5
> dhcp-3.0.4.patch
> 0001-Make-DHCP-server-print-HW-info.patch
>=20
> I've been upporting those to a 4.x based DHCP and have a fundamental
> question which occurs even with the 3.0.4 socket based version. On th=
e
> client machine, the DHCPOFFER in response to the DHCPDISCOVER is
> received (seen with tcpdump) but never seems to make it to the
> dhclient application. I can't see any kernel stack error counters
> incremented so I'm mystified as to what could be going wrong. I've
> also tried this on a number of different kernels. Any idea on why thi=
s
> might be or how to figure out where that packet is going ? I do see
> the dhcp client port with netstat -a --udp -n
> udp        0      0 0.0.0.0:68                  0.0.0.0:*
> udp        0      0 0.0.0.0:68                  0.0.0.0:*
> Any idea on what I'm missing ?
>=20
> Also, is any of this work making it's way into a released DHCP ?
> What's the process for this ? Is there some branch in a source
> repository where this work is available ?
>=20
> Thanks in advance for any pointers on all this.
>=20
> -- Hal
> _______________________________________________
> ewg mailing list
> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
