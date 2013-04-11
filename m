From: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Mellanox/RoCE - VLAN support
Date: Thu, 11 Apr 2013 18:00:21 +0200
Message-ID: <OF5B0D4E67.C42BB7AC-ONC1257B4A.00569ED8-C1257B4A.0057F075@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hi all,
we are doing a project on IBM x-blades using Mellanox/RoCE. I have some
difficulties to get RoCE based VLANs to run.
We are currently on Linux 3.8. No OFED material involved.
While non-VLAN devices work ok, i experience the following on VLAN devs
- a GID for the VLAN is created and we use the proper index for gid sou=
rce
addr.
- a ping on the VLAN-device runs ok
- rdma/roce traffic fails in that the sender overruns the send retry co=
unt.

In terms of Mellanox driver level, what gives us Linux 3.8? Are we at m=
ost
current driver level?

And do we have to take special setup for VLAN, i.e. special MLX4 module
parms, or special qp parameters to get this going?

Any help on this is very much appreciated.

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
