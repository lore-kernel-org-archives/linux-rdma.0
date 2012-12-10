From: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: ib/roce VLAN ibv_rc_pingpong test
Date: Mon, 10 Dec 2012 14:14:52 +0100
Message-ID: <OF5408F09F.E7FD583F-ONC1257AD0.0045268E-C1257AD0.0048C908@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hi,
we are doing a project with Linux/ib/roce (Mellanox ConnectX2) using
QPtypes=3DRC on IBM blades.
So far we ran on non-VLAN ethernet devs, which worked out well. Now we =
are
entering the VLAN based devs, which gives some headache. As we see the
ibv_rc_pingpong suffering the same symptom, lets refer to the
ibv_rc_pinpong() case.
=46or the pingpong test we follow the simple setup/approach as given in=
 the
"ConnectX-2EN Config Manual" as given from Mellanox:
1. The VLAN setup is done as given and the GID table (/sys/class...)
reflects that the GIDs are properly allocated during VLAN config.
server:~ # ifconfig eth3.200
eth3.200  Link encap:Ethernet  HWaddr 00:02:C9:4C:5A:AD
          inet addr:192.168.200.2  Bcast:192.168.200.255
Mask:255.255.255.0
          inet6 addr: fe80::2:c900:14c:5aad/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:102 errors:0 dropped:48 overruns:0 frame:0
          TX packets:45 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:55221 (53.9 Kb)  TX bytes:3458 (3.3 Kb)

Client:~ # ifconfig eth3.200
eth3.200  Link encap:Ethernet  HWaddr 00:02:C9:4C:5A:8F
          inet addr:192.168.200.1  Bcast:192.168.200.255
Mask:255.255.255.0
          inet6 addr: fe80::2:c900:14c:5a8f/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:57 errors:0 dropped:8 overruns:0 frame:0
          TX packets:71 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:3989 (3.8 Kb)  TX bytes:5336 (5.2 Kb)

2. The switch (BNT virt. fabric 10GB) has configured all ports as "vlan
tagging=3Denabled" (trunk-mode)

3. A "ping" on the VLAN dev shows packet transfer, both sides working.
4. Server as follows:
server:~ # ibv_rc_pingpong -g 1 -i 2
  local address:  LID 0x0000, QPN 0x700049, PSN 0x41aace, GID
fe80::202:c900:c84c:5aad

5. Client as follows:
client:~ # ibv_rc_pingpong -g 1 -i 2 server
  local address:  LID 0x0000, QPN 0x1c0049, PSN 0x00956d, GID
fe80::202:c900:c84c:5a8f
  remote address: LID 0x0000, QPN 0x700049, PSN 0x41aace, GID
fe80::202:c900:c84c:5aad
=46ailed status transport retry counter exceeded (12) for wr_id 2

(=3D> Using the vlan IP address 192.168.200.2 instead of server (which =
is
address on eth0) results in the same error no difference.)

Now my questions are: Any ideas what causes the "ibv_rc_pingpong" to fa=
il?
What should be the next step in debugging this situation?

Thanks in advance for your time.

Kind regards
Klaus Wacker
IBM Systems &Technology Group, Systems Software Development
SW Linux on System z Dev & Service
Phone:  +49-7031-16-3779   IBM Deutschland  E-Mail:  kdwacker-tA70FqPdS9Zhl2p70BpVqQ@public.gmane.org=
m
Schoenaicher Str. 220   71032 Boeblingen   Germany
IBM Deutschland Research & Development GmbH / Vorsitzende des
Aufsichtsrats: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen / Registergericht: Amtsgericht Stutt=
gart,
HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
