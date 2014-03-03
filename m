From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Proposal for simplifying NFS/RDMA client memory registration
Date: Mon, 3 Mar 2014 12:02:33 -0500
Message-ID: <E755E683-C064-4ED3-8448-C61F4E5AF16E@oracle.com>
References: <01C4496A-F074-4F72-9DF0-6076C05E8A1F@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01C4496A-F074-4F72-9DF0-6076C05E8A1F-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Feb 26, 2014, at 11:44 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrot=
e:

> Hi-
>=20
> Shirley Ma and I are reviving work on the NFS/RDMA client code base i=
n the Linux kernel.  So far we=92ve built and run functional tests to d=
etermine what is working and what is broken.
>=20
> One complication is the number of memory registration modes supported=
 by the RPC/RDMA transport: there are seven.  These were added over the=
 years to support particular HCAs or as proof-of-concept.  The transpor=
t chooses a registration mode at mount time based on what the link HCA =
supports.
>=20
> Not all HCAs support all memory registration modes, so our test matri=
x is quite large.  I=92d like to propose removing support for one or mo=
re of these memory registration modes in the name of making it easier t=
o change this code and test it without breaking something that we can=92=
t test.
>=20
> BOUNCEBUFFERS - All HCAs support this mode.  Does not use RDMA READ a=
nd WRITE, and the client end copies data into place.  RDMA is offloaded=
, by data copy is not.  I=92m told it was never intended for production=
 use.
>=20
> REGISTER - Safe but relatively slow.  Uses reg_phys_mr verb which is =
not supported in mlx4/mlx5, but all other HCAs/providers can use this m=
ode.
>=20
> MEM_WINDOWS - Uses bind_mr verb.  Safe, but supports only a narrow ra=
nge of HCAs.
>=20
> MEM_WINDOWS_ASYNC - Not always safe, and only a narrow range of HCAs =
is supported.
>=20
> MTHCA_FMR - Uses alloc_fmr verb.  Safe, reasonably fast, but only a n=
arrow range of older HCAs is supported.
>=20
> FRMR - Safe, generally fast.  Currently the preferred registration mo=
de, but is not supported with some older HCAs/providers.
>=20
> ALLPHYSICAL - Usually fast, but not safe as it exposes client memory.=
  All HCAs support this mode.
>=20
>=20
> I propose removing BOUNCEBUFFERS since it is not intended for product=
ion use.
>=20
> I propose removing ALLPHYSICAL and MEM_WINDOWS_ASYNC as they are not =
generally safe.  RFC 5666 suggests that unsafe memory registration mode=
s be avoided.
>=20
> I propose removing MEM_WINDOWS as it adds complexity without adding a=
 lot of HCA compatibility.
>=20
> I propose removing MTHCA_FMR as I=92m told it is hard to obtain HCAs =
we would need for testing this registration mode, and these are all old=
 adapters anyway.
>=20
> This leaves NFS/RDMA client support for REGISTER and FRMR, which shou=
ld cover all existing HCAs, and it is easy to test both of these memory=
 registration modes with just one or two well-picked HCAs.
>=20
> We would contribute these changes to the client code base.  The NFS/R=
DMA server code could use similar attention, but we are not volunteerin=
g to change it at this time.
>=20
> Thoughts/comments?

Karma score so far:

BOUNCEBUFFERS, REGISTER, MEM_WINDOWS, MEM_WINDOWS_ASYNC - no votes in f=
avor of keeping

MTHCA_FMR, FRMR, ALLPHYSICAL - one or more votes in favor of keeping


All HCAs in 3.13 (and rxe) can support either MTHCA_FMR or FRMR or both=
=2E Wendy=92s HCA supports only ALLPHYSICAL.

Does it make sense to deprecate then remove the registration modes in t=
he first list?

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
