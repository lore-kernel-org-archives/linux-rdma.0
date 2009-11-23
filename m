From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: qos on service-id
Date: Mon, 23 Nov 2009 09:25:47 -0500
Message-ID: <f0e08f230911230625r61a1d262p3df61960d1dbe211@mail.gmail.com>
References: <4B0A4C71.5080209@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B0A4C71.5080209-6ktuUTfB/bM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?C=C3=A9line_Bourde?= <celine.bourde-6ktuUTfB/bM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2009 at 3:48 AM, C=C3=A9line Bourde <celine.bourde@bull=
=2Enet> wrote:
> Hi,
>
> I'm trying to configure qos-policy.donc file for service-id use.
> I've tried basic RDMA_PS_TCP service-id level with service id 0x0106
>
> []# cat /etc/opensm/qos-policy.conf
> qos-levels
> =C2=A0 =C2=A0 qos-level
> =C2=A0 =C2=A0 name: DEFAULT
> =C2=A0 =C2=A0 sl: 0
> =C2=A0 =C2=A0 end-qos-level
> =C2=A0 =C2=A0 qos-level
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 name: TCP
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 sl: 4
> =C2=A0 =C2=A0 end-qos-level
> =C2=A0 =C2=A0 =C2=A0 qos-level
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0name: MPI
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sl: 5
> =C2=A0 =C2=A0 =C2=A0end-qos-level
> end-qos-levels
>
> qos-ulps
> =C2=A0default =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 : 0 # default SL
> =C2=A0any, service-id 0x0000000001060000- 0x000000000106FFFF : 4
> end-qos-ulps
>
> I add this rule in my configuration and check by mapping
> sl 4 on a vl with a weight of 0
>
> # QoS default options
> qos_max_vls 8
> qos_high_limit 1
> qos_vlarb_high 0:1,1:0,2:0,3:0,4:0
> qos_vlarb_low 0:1,1:2,2:4,3:8,4:0,5:32
> qos_sl2vl 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>
> I've launched qperf on the server side
> and listen on client:
>
> j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf -ri mlx4_0:1 -li ml=
x4_0:1
> 10.12.1.4 -sl 4 -lp 20004 rc_bw; done;
> rc_bw:
> =C2=A0bw =C2=A0=3D =C2=A00 bytes/sec
> rc_bw:
> =C2=A0bw =C2=A0=3D =C2=A00 bytes/sec
>
> j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf -ri mlx4_0:1 -li ml=
x4_0:1
> 10.12.1.4 -sl 5 -lp 20005 rc_bw; done;
> rc_bw:
> =C2=A0bw =C2=A0=3D =C2=A03.37 GB/sec
> rc_bw:
> =C2=A0bw =C2=A0=3D =C2=A03.37 GB/sec
>
> Qperf gives me results I expected due to qos-level configuration part=
, but
> no
> expected results using qperf tcp_bw, bandwith is not
> filtered/blocked by sl weight.
>
> # j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf 10.12.1.4 tcp_bw;=
 done;
> tcp_bw:
> =C2=A0bw =C2=A0=3D =C2=A0923 MB/sec
> tcp_bw:
> =C2=A0bw =C2=A0=3D =C2=A0935 MB/sec
>
> j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf -ri mlx4_0:1 -li ml=
x4_0:1
> 10.12.1.4 -sl 5 -lp 20005 rc_bw; done;
> rc_bw:
> =C2=A0bw =C2=A0=3D =C2=A02.23 GB/sec
> rc_bw:
> =C2=A0bw =C2=A0=3D =C2=A02.24 GB/sec
> rc_bw:
> =C2=A0bw =C2=A0=3D =C2=A02.21 GB/sec
>
> Could you help me to understanding service-id mechanism or give me a
> relevant
> test to test TCP service id level ?

A weight of 0 for a VL can still allow for packets to be sent when the
arbiter has available "slots".

To filter, the SL can be set to VL15 or some VL above the OperationalVL=
s.

-- Hal

>
> Thanks.
>
> C=C3=A9line Bourde.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
