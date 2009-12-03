From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: QoS settings not mapped correctly per pkey ?
Date: Thu, 3 Dec 2009 10:05:03 +0100
Message-ID: <20091203100503.19430d35@frecb007965>
References: <4B0D0DB2.6080802@bull.net>
	<4B0D1F36.1090007@dev.mellanox.co.il>
	<4B0D38C7.3080505@bull.net>
	<4B0D410E.2010903@dev.mellanox.co.il>
	<4B0D49F0.6060400@bull.net>
	<4B0D5110.70606@dev.mellanox.co.il>
	<4B0E34EB.6020403@bull.net>
	<4B0E3B63.40705@dev.mellanox.co.il>
	<4B0E4105.5080107@bull.net>
	<4B0E50D6.8020401@dev.mellanox.co.il>
	<4B177058.9070909@dev.mellanox.co.il>
	<4B1774F0.9060002@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B1774F0.9060002-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, BOURDE CELINE <Celine.Bourde-6ktuUTfB/bM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



  Hi Or,

On Thu, 03 Dec 2009 10:21:04 +0200
Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org> wrote:

> Yevgeny Kliteynik wrote:
> > " It looks like in 'datagram' mode, the SL weights
> >   do not seem to be applied, or maybe this is an
> >   artifact of IPoIB in 'datagram mode' "
>=20
> yes, there's no reason for connected mode to behave differently wrt t=
o QoS/SL assignment from the SM, as both modes get their SL from the pa=
th record provided by the SM and both mode use the same code for the pa=
th query...

  Right, that was my gut's feeling.

>=20
> > Have you checked that in this mode you do get the right
> > SL for each child interface by shutting off the relevant
> > SL (mapping it to VL15)?
>=20
> seeing what SL is provided by the SM in return to the path query is t=
rivial, either through the opensm logs or the ipoib ones, e.g here you =
see that ib1 got SL 0
> on its Path to GID fe80:0000:0000:0000:0008:f104:0399:3c92 LID 0x0006=
 which is
> 10.10.0.91

  Just checked, the SLs provided by the path queries are OK in datagram=
 mode.

  There might be some overhead somewhere (in iperf or in the IPoIB laye=
r) that
prevent using the link full bandwidth in datagram mode.

  Thanks,

  S=C3=A9bastien.


>=20
> > ifdown ib1
> > echo 1 > /sys/module/ib_ipoib/parameters/debug_level
> > ifup ib1
> > ping 10.10.0.91
> > dmesg | grep ib1
>=20
> > ib1: Start path record lookup for fe80:0000:0000:0000:0008:f104:039=
9:3c92 MTU > 0
> > ib1: PathRec LID 0x0006 for GID fe80:0000:0000:0000:0008:f104:0399:=
3c92
> > ib1: Created ah ffff81021ddda180
> > ib1: created address handle ffff81021ddda500 for LID 0x0006, SL 0
>=20
> > # ip neigh show dev ib1
> > 10.10.0.91 lladdr 80:00:00:49:fe:80:00:00:00:00:00:00:00:08:f1:04:0=
3:99:3c:92 REACHABLE
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
