From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Proposal for simplifying NFS/RDMA client memory registration
Date: Wed, 26 Feb 2014 08:44:49 -0800
Message-ID: <01C4496A-F074-4F72-9DF0-6076C05E8A1F@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi-

Shirley Ma and I are reviving work on the NFS/RDMA client code base in =
the Linux kernel.  So far we=92ve built and run functional tests to det=
ermine what is working and what is broken.

One complication is the number of memory registration modes supported b=
y the RPC/RDMA transport: there are seven.  These were added over the y=
ears to support particular HCAs or as proof-of-concept.  The transport =
chooses a registration mode at mount time based on what the link HCA su=
pports.

Not all HCAs support all memory registration modes, so our test matrix =
is quite large.  I=92d like to propose removing support for one or more=
 of these memory registration modes in the name of making it easier to =
change this code and test it without breaking something that we can=92t=
 test.

BOUNCEBUFFERS - All HCAs support this mode.  Does not use RDMA READ and=
 WRITE, and the client end copies data into place.  RDMA is offloaded, =
by data copy is not.  I=92m told it was never intended for production u=
se.

REGISTER - Safe but relatively slow.  Uses reg_phys_mr verb which is no=
t supported in mlx4/mlx5, but all other HCAs/providers can use this mod=
e.

MEM_WINDOWS - Uses bind_mr verb.  Safe, but supports only a narrow rang=
e of HCAs.

MEM_WINDOWS_ASYNC - Not always safe, and only a narrow range of HCAs is=
 supported.

MTHCA_FMR - Uses alloc_fmr verb.  Safe, reasonably fast, but only a nar=
row range of older HCAs is supported.

=46RMR - Safe, generally fast.  Currently the preferred registration mo=
de, but is not supported with some older HCAs/providers.

ALLPHYSICAL - Usually fast, but not safe as it exposes client memory.  =
All HCAs support this mode.


I propose removing BOUNCEBUFFERS since it is not intended for productio=
n use.

I propose removing ALLPHYSICAL and MEM_WINDOWS_ASYNC as they are not ge=
nerally safe.  RFC 5666 suggests that unsafe memory registration modes =
be avoided.

I propose removing MEM_WINDOWS as it adds complexity without adding a l=
ot of HCA compatibility.

I propose removing MTHCA_FMR as I=92m told it is hard to obtain HCAs we=
 would need for testing this registration mode, and these are all old a=
dapters anyway.

This leaves NFS/RDMA client support for REGISTER and FRMR, which should=
 cover all existing HCAs, and it is easy to test both of these memory r=
egistration modes with just one or two well-picked HCAs.

We would contribute these changes to the client code base.  The NFS/RDM=
A server code could use similar attention, but we are not volunteering =
to change it at this time.

Thoughts/comments?

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
