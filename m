From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Wed, 3 Aug 2011 13:37:23 +0300
Message-ID: <201108031337.24527.jackm@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com> <201108021344.25284.jackm@dev.mellanox.co.il> <32D25205-3E9C-4757-B0AB-7117BDF3F2F7@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32D25205-3E9C-4757-B0AB-7117BDF3F2F7-1Heg1YXhbW8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tuesday 02 August 2011 19:29, Shamis, Pavel wrote:
> XRC domain is created by process that starts first. =A0All the rest p=
rocesses, that belong
> to the same mpi session and reside on the same node, join the domain.=
 =20
> TGT QP is created by process that receive inbound connection first an=
d it is not necessary
> the same process that created the domain. Even so we assume that both=
 processes belong to
> the same domain, and belong to the same mpi session. =20
>=20
The only things that are important here are:
1. Before the TGT QP creator exits (de-allocating its domain), there is=
 at least one other
   process active which has opened the same domain (so that the domain,=
 and the TGT QP
   are not de-allocated when the creator exits, which would clobber the=
 calculation).

   Note that this condition probably exists already in MPI -- if the cr=
eator had the only
   domain reference, then the domain would be de-allocated when the cre=
ator exited,
   and the calculation would not work anyway.

2. When the job is finished, all processes have de-allocated the XRC do=
main -- so that the
   domain gets de-allocated and all its TGT QPs destroyed. (i.e., the d=
omain's lifetime is the job).

If these 2 conditions are met, there is absolutely no justification for=
 TGT QP reference counting.
The domain reference count is good enough -- when the domain reference =
count goes to zero,
the domain is de-allocated and all its TGT QPs destroyed.

Things only get complicated when the domain-allocator process allocates=
 a single domain and simply
uses that single domain for all jobs (i.e., the domain is never de-allo=
cated for the lifetime of the
allocating process, and the allocating process is the server for all jo=
bs).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
