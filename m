From: =?ISO-8859-1?Q?C=E9line_Bourde?= <celine.bourde-6ktuUTfB/bM@public.gmane.org>
Subject: qos on service-id
Date: Mon, 23 Nov 2009 09:48:49 +0100
Message-ID: <4B0A4C71.5080209@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I'm trying to configure qos-policy.donc file for service-id use.
I've tried basic RDMA_PS_TCP service-id level with service id 0x0106

[]# cat /etc/opensm/qos-policy.conf
qos-levels
      qos-level
      name: DEFAULT
      sl: 0
      end-qos-level
      qos-level
          name: TCP
          sl: 4
      end-qos-level
        qos-level
           name: MPI
           sl: 5
       end-qos-level
end-qos-levels

qos-ulps
  default                       : 0 # default SL
  any, service-id 0x0000000001060000- 0x000000000106FFFF : 4
end-qos-ulps

I add this rule in my configuration and check by mapping
sl 4 on a vl with a weight of 0

# QoS default options
qos_max_vls 8
qos_high_limit 1
qos_vlarb_high 0:1,1:0,2:0,3:0,4:0
qos_vlarb_low 0:1,1:2,2:4,3:8,4:0,5:32
qos_sl2vl 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

I've launched qperf on the server side
and listen on client:

j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf -ri mlx4_0:1 -li mlx4=
_0:1
10.12.1.4 -sl 4 -lp 20004 rc_bw; done;
rc_bw:
  bw  =3D  0 bytes/sec
rc_bw:
  bw  =3D  0 bytes/sec

j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf -ri mlx4_0:1 -li mlx4=
_0:1
10.12.1.4 -sl 5 -lp 20005 rc_bw; done;
rc_bw:
  bw  =3D  3.37 GB/sec
rc_bw:
  bw  =3D  3.37 GB/sec

Qperf gives me results I expected due to qos-level configuration part,=20
but no
expected results using qperf tcp_bw, bandwith is not
filtered/blocked by sl weight.

# j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf 10.12.1.4 tcp_bw; d=
one;
tcp_bw:
  bw  =3D  923 MB/sec
tcp_bw:
  bw  =3D  935 MB/sec

j=3D100; for i in $(seq 0 $j) ; do /usr/bin/qperf -ri mlx4_0:1 -li mlx4=
_0:1
10.12.1.4 -sl 5 -lp 20005 rc_bw; done;
rc_bw:
  bw  =3D  2.23 GB/sec
rc_bw:
  bw  =3D  2.24 GB/sec
rc_bw:
  bw  =3D  2.21 GB/sec

Could you help me to understanding service-id mechanism or give me a=20
relevant
test to test TCP service id level ?

Thanks.

C=E9line Bourde.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
