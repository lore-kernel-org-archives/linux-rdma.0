From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Proposal for simplifying NFS/RDMA client memory registration
Date: Fri, 28 Feb 2014 13:41:27 -0800
Message-ID: <53110287.9000400@talpey.com>
References: <01C4496A-F074-4F72-9DF0-6076C05E8A1F@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01C4496A-F074-4F72-9DF0-6076C05E8A1F-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/26/2014 8:44 AM, Chuck Lever wrote:
> Hi-
>
> Shirley Ma and I are reviving work on the NFS/RDMA client code base i=
n the Linux kernel.  So far we=92ve built and run functional tests to d=
etermine what is working and what is broken.
>
> One complication is the number of memory registration modes supported=
 by the RPC/RDMA transport: there are seven.  These were added over the=
 years to support particular HCAs or as proof-of-concept.  The transpor=
t chooses a registration mode at mount time based on what the link HCA =
supports.
>
> Not all HCAs support all memory registration modes, so our test matri=
x is quite large.  I=92d like to propose removing support for one or mo=
re of these memory registration modes in the name of making it easier t=
o change this code and test it without breaking something that we can=92=
t test.
>
> BOUNCEBUFFERS - All HCAs support this mode.  Does not use RDMA READ a=
nd WRITE, and the client end copies data into place.  RDMA is offloaded=
, by data copy is not.  I=92m told it was never intended for production=
 use.
>
> REGISTER - Safe but relatively slow.  Uses reg_phys_mr verb which is =
not supported in mlx4/mlx5, but all other HCAs/providers can use this m=
ode.
>
> MEM_WINDOWS - Uses bind_mr verb.  Safe, but supports only a narrow ra=
nge of HCAs.
>
> MEM_WINDOWS_ASYNC - Not always safe, and only a narrow range of HCAs =
is supported.
>
> MTHCA_FMR - Uses alloc_fmr verb.  Safe, reasonably fast, but only a n=
arrow range of older HCAs is supported.

The MTHCA FMR is not completely safe - it protects only on page
boundaries, therefore the neighboring bytes are vulnerable to
silent corruption (reads) and exposure (write).

It is quite correct that they are supported on only a specific
set of legacy Mellanox HCA. You should consider removing the
code that looked for this PCI ID and attempted to alter the
device's wire MTU, to overcome another of its limitations.

>
> FRMR - Safe, generally fast.  Currently the preferred registration mo=
de, but is not supported with some older HCAs/providers.

This should be, by far, the preferred mode. Also, if I recall
correctly, the server depends on this mode being available/supported.
However, it may not be supported by Soft iWARP. Physical addressing
is used.

>
> ALLPHYSICAL - Usually fast, but not safe as it exposes client memory.=
  All HCAs support this mode.

Not safe is an understatement. It exposes all of client physical
memory to the peer, for both read and write. A simple pointer error
on the server will silently corrupt the client. This mode was
intended only for testing, and in experimental deployments.


Tom.

>
>
> I propose removing BOUNCEBUFFERS since it is not intended for product=
ion use.
>
> I propose removing ALLPHYSICAL and MEM_WINDOWS_ASYNC as they are not =
generally safe.  RFC 5666 suggests that unsafe memory registration mode=
s be avoided.
>
> I propose removing MEM_WINDOWS as it adds complexity without adding a=
 lot of HCA compatibility.
>
> I propose removing MTHCA_FMR as I=92m told it is hard to obtain HCAs =
we would need for testing this registration mode, and these are all old=
 adapters anyway.
>
> This leaves NFS/RDMA client support for REGISTER and FRMR, which shou=
ld cover all existing HCAs, and it is easy to test both of these memory=
 registration modes with just one or two well-picked HCAs.
>
> We would contribute these changes to the client code base.  The NFS/R=
DMA server code could use similar attention, but we are not volunteerin=
g to change it at this time.
>
> Thoughts/comments?
>
> --
> Chuck Lever
> chuck[dot]lever[at]oracle[dot]com
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
