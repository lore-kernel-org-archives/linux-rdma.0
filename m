From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 00/24] Series short description
Date: Wed, 28 May 2014 19:15:44 -0400
Message-ID: <B50B248D-901F-41FE-B6B1-A99A6F22E1CC@oracle.com>
References: <20140528142521.23214.39655.stgit@manet.1015granger.net>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140528142521.23214.39655.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Test results:

On May 28, 2014, at 10:31 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrot=
e:

> Updates since v4:
>=20
> - Rebased on v3.15-rc7
> - Addressed Trond's review comment in "Reset connection timeout..."
> - Wake up RPC tasks only when cwnd is growing in "Avoid deadlock when=
=2E.."
> - Fix patch description of "Remove MEMWINDOWS registration modes"
>=20
> Pull from the "nfs-rdma-client" branch of my git repo:
>=20
>  git://git.linux-nfs.org/projects/cel/cel-2.6.git

Client:
v3.15-rc7 with my 24 patches applied.
ConnectX-2 adapter (mlx4)

Server:
Solaris 11.2 beta
ConnectX-2 adapter

Server:
stock Linux v3.15-rc7
InfiniHost III adapter (mthca)



Connectathon tests: =93./server -a -N30=94 with NFSv3 and NFSv4 against
Solaris and Linux servers. All passed. No hangs, stalls, or crashes.

Client tested in FRMR, FMR, and PHYSICAL memory registration modes.

With Linux server, added =93rsize=3D32768=94 mount option for PHYSICAL.

With Solaris server, added =93rsize=3D131072,wsize=3D65536=94 mount opt=
ions
for PHYSICAL.



xfstests: =93sudo ./check -nfs=94 with NFSv3 and NFSv4 against Linux
server. Test failure rate same as over TCP. No hangs, stalls, or
crashes.

Client ran in FRMR, FMR, and PHYSICAL memory registration modes.
PHYSICAL registration added =93rsize=3D32768=94 mount option



> ---
>=20
> Allen Andrews (1):
>      nfs-rdma: Fix for FMR leaks
>=20
> Chuck Lever (21):
>      xprtrdma: Disconnect on registration failure
>      xprtrdma: Remove BUG_ON() call sites
>      xprtrdma: Avoid deadlock when credit window is reset
>      SUNRPC: Move congestion window constants to header file
>      xprtrdma: Reset connection timeout after successful reconnect
>      xprtrdma: Use macros for reconnection timeout constants
>      xprtrdma: Remove Tavor MTU setting
>      xprtrdma: Ensure ia->ri_id->qp is not NULL when reconnecting
>      xprtrdma: Reduce the number of hardway buffer allocations
>      xprtrdma: Limit work done by completion handler
>      xprtrmda: Reduce calls to ib_poll_cq() in completion handlers
>      xprtrmda: Reduce lock contention in completion handlers
>      xprtrdma: Split the completion queue
>      xprtrdma: Make rpcrdma_ep_destroy() return void
>      xprtrdma: Simplify rpcrdma_deregister_external() synopsis
>      xprtrdma: mount reports "Invalid mount option" if memreg mode no=
t supported
>      xprtrdma: Fall back to MTHCAFMR when FRMR is not supported
>      xprtrdma: Remove REGISTER memory registration mode
>      xprtrdma: Remove MEMWINDOWS registration modes
>      xprtrdma: Remove BOUNCEBUFFERS memory registration mode
>      xprtrdma: RPC/RDMA must invoke xprt_wake_pending_tasks() in proc=
ess context
>=20
> Shirley Ma (1):
>      xprtrdma: Allocate missing pagelist
>=20
> Steve Wise (1):
>      xprtrdma: mind the device's max fast register page list depth
>=20
>=20
> include/linux/sunrpc/xprt.h     |    6=20
> net/sunrpc/xprt.c               |   28 -
> net/sunrpc/xprtrdma/rpc_rdma.c  |  119 +++---
> net/sunrpc/xprtrdma/transport.c |   90 ++---
> net/sunrpc/xprtrdma/verbs.c     |  753 ++++++++++++++++--------------=
---------
> net/sunrpc/xprtrdma/xprt_rdma.h |   17 +
> 6 files changed, 411 insertions(+), 602 deletions(-)
>=20
> --=20
> Chuck Lever
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
