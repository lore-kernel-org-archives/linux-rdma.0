From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: =?iso-8859-1?Q?Na=EFv?= =?iso-8859-1?Q?e?= question wrt
	ibv_reg_mr(), pinned pages and Linux VM
Date: Sun, 14 Mar 2010 12:22:39 +0200
Message-ID: <20100314102239.GA23358@mtldesk030.lab.mtl.com>
References: <C7C03A40.9C2%tim.wright@rnanetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C7C03A40.9C2%tim.wright-c+vHNXOUHMmEK/hMebVsMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tim Wright <tim.wright-c+vHNXOUHMmEK/hMebVsMw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tim,
the memory you register using ibv_reg_mr() is pinned and the pages
cannot be used for anything else until you release them through a
call to ibv_dereg_mr() (or the process terminates). There is no need
to use mlock.
Did you check that the call to ibv_reg_mr() succedded?

On Fri, Mar 12, 2010 at 09:36:48PM -0500, Tim Wright wrote:
> Hello everybody,
> I have a question regarding behavior of the memory pinning using
> ibv_reg_mr() on RHEL/Centos 5.3/OFED-1.4.1. This may be more a Linux
> feature/issue, and I apologize if that is the case. Here is the scena=
rio
>=20
> 1. An application runs which allocates a significant fraction of the =
system
> memory as RDMA buffers (e.g. 3GB of ram on a 4GB system). These are s=
etup
> using ibv_reg_mr(). It is clear that the pages are pinned from the ke=
rnel
> perspective. With just this program running, the resident set size of=
 the
> program approaches the allocation size.
> 2. If other memory-intensive processes are now started, the resident =
set
> size of the RDMA-using program shrinks dramatically.
> 3. Even if the other memory-intensive programs are stopped, and the
> RDMA-using program is forced to read its memory, the resident set nev=
er
> grows to a =B3reasonable=B2 size again.
>=20
> My potentially foolish assumptions are/were that:
> i) Since the memory is pinned anyway, it would be locked into the pro=
cess
> address space, and
> ii) even if that were not the case, that the process would be able to=
 regain
> a large RSS when any competing processes stopped.
>=20
> For ii), it almost seems that the VM doesn=B9t realize that the pages=
 it would
> be grabbing back are already resident and therefore won=B9t actually =
take any
> more memory.
>=20
> Clearly, I can use mlock() to avoid the issue, but I was wondering if=
 I have
> missed something obvious here. Any clues/brickbats gratefully receive=
d!
>=20
> Regards,
>=20
> Tim Wright
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
