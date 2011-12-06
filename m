From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: =?windows-1252?Q?Re=3A_=5BRFC=5D_=96_Proposal_for_new_process_for_OFED_rele?=
	=?windows-1252?Q?ases?=
Date: Tue, 6 Dec 2011 10:59:13 -0800
Message-ID: <CAL1RGDXLvROQf9pfRv0nxm6WHzJAXaA0RZy+_zhg6kNP0iU=sA@mail.gmail.com>
References: <CD250C48050CFB4D95E78C95F2FDDD6E237661EA@MTLDAG01.mtl.com>
 <1828884A29C6694DAF28B7E6B8A8237323FC20F5@ORSMSX102.amr.corp.intel.com> <4EDC6D4A.7060407@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EDC6D4A.7060407-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The kernel is a large piece that keeps moving on - its made of many s=
maller
> pieces/components, but with very sharp and well defined dependencies =
and
> interactions. =A0The rdma stack is far from being an isolated piece w=
hich you
> can pull from kernel X and plug into kernel Y - this applies all over=
 the
> place in varying extents - e.g from the RDMA HW drivers, through the =
IB core
> and up to the ULPs.
>
> The latter is the easiest to explain, as Roland once commented, each =
IB ULP
> driver is a fish and a eel - so SRP/iSER/rNFS/IPoIB are all IB fishes
> working with the IB core services and with the HW through the verbs, =
but the
> are part from higher-level constructs in the kernel, such as being ne=
twork
> device (IPoIB), SCSI Low Level drivers (1st two), iscsi transport pro=
vider
> (iser) and RPC provider (rNFS). =A0Now, BACKPORTING these stacks (SCS=
I, iSCSI,
> RPC/NFS, etc) isn't something that OFA can carry, and it would be
> self-damaging to create notion with end-users that OFED does so. I te=
nd to
> think this is done now for rNFS, and its a mistake. Distributions do =
that,
> by the way, but its part of their bread and butter.

https://lkml.org/lkml/2011/9/9/327 and its links have interesting and p=
ossibly
useful information about the wireless-compat backporting project.  In f=
act
it might make sense to try and merge OFED efforts into that compat proj=
ect.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
