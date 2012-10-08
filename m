From: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: RDMA Relaxed Ordering on Linux
Date: Mon, 8 Oct 2012 13:52:33 +0200
Message-ID: <OF926F7A9B.81FB4B34-ONC1257A91.003EF9D7-C1257A91.00413F9B@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hello,
we are doing a Infiniband/RoCE project on Linux/x86_64 based on
Mellanox/RoCE cards. Our data exchange is heavily build on RDMA. For so=
me
reasons we want to suppress the Relaxed Ordering (RO) of RDMA. This wou=
ld
serialize the RDMA requests on the server in the strict order as issued=
 on
the client.
A reading on this (solaris implementation) could be found here:
http://www.mail-archive.com/opensolaris-arc-k6qjsvWZbdBvv+Yoo/dBM2D2FQJk+8+b@public.gmane.org/msg084=
38.html

We are interested what the referred proposal describes as:
IBTF Transport Interface (ON Consolidation Private)
ibt_mr_flags_t: IBT_MR_DISABLE_RO flag - disable RO on registration

The udapl part in the reference is of no significance for our project.

Now my question is: Does Linux/x86 allow for "disable RO on registratio=
n"?
Any thoughts on this?

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
