From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT PULL] Please pull NFSoRDMA changes for 4.4
Date: Mon, 2 Nov 2015 10:17:12 -0500
Message-ID: <56377E78.5070409@Netapp.com>
References: <562A9C42.7030506@Netapp.com>
 <914C310D-238E-4646-891F-7680492D440C@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <914C310D-238E-4646-891F-7680492D440C-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/24/2015 02:41 PM, Chuck Lever wrote:
>=20
>> On Oct 23, 2015, at 4:44 PM, Anna Schumaker <Anna.Schumaker@netapp.c=
om> wrote:
>>
>> Hi Trond,
>>
>> The following changes since commit 7379047d5585187d1288486d462787317=
0d0005a:
>>
>>  Linux 4.3-rc6 (2015-10-18 16:08:42 -0700)
>>
>> are available in the git repository at:
>>
>>  git://git.linux-nfs.org/projects/anna/nfs-rdma.git tags/nfs-rdma-4.=
4
>>
>> for you to fetch changes up to 50add18fd4c82cc1eaedc6ce879d998a66f20=
e1f:
>>
>>  NFS: Enable client side NFSv4.1 backchannel to use other transports=
 (2015-10-19 14:48:18 -0400)
>=20
> Anna, did you already send Steve Wise=E2=80=99s fix for 4.4?

Oops!  I think I forgot that patch.  I'll include it with the v4 pull r=
equest today.

Anna

>=20
> http://marc.info/?l=3Dlinux-nfs&m=3D144285627709672&w=3D2
>=20
>=20
>> Thanks,
>> Anna
>>
>> ----------------------------------------------------------------
>> Chuck Lever (16):
>>      xprtrdma: Enable swap-on-NFS/RDMA
>>      xprtrdma: Re-arm after missed events
>>      xprtrdma: Prevent loss of completion signals
>>      xprtrdma: Refactor reply handler error handling
>>      xprtrdma: Replace send and receive arrays
>>      xprtrdma: Use workqueue to process RPC/RDMA replies
>>      xprtrdma: Remove reply tasklet
>>      xprtrdma: Saving IRQs no longer needed for rb_lock
>>      SUNRPC: Abstract backchannel operations
>>      xprtrdma: Pre-allocate backward rpc_rqst and send/receive buffe=
rs
>>      xprtrdma: Pre-allocate Work Requests for backchannel
>>      xprtrdma: Add support for sending backward direction RPC replie=
s
>>      xprtrdma: Handle incoming backward direction RPC calls
>>      svcrdma: Add backward direction service for RPC/RDMA transport
>>      SUNRPC: Remove the TCP-only restriction in bc_svc_process()
>>      NFS: Enable client side NFSv4.1 backchannel to use other transp=
orts
>>
>> fs/nfs/callback.c                        |  33 +++++++++------
>> include/linux/sunrpc/bc_xprt.h           |   5 +++
>> include/linux/sunrpc/svc_rdma.h          |   6 ++-
>> include/linux/sunrpc/xprt.h              |   7 ++++
>> net/sunrpc/backchannel_rqst.c            |  24 ++++++++++-
>> net/sunrpc/svc.c                         |   5 ---
>> net/sunrpc/xprtrdma/Makefile             |   1 +
>> net/sunrpc/xprtrdma/backchannel.c        | 373 +++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+
>> net/sunrpc/xprtrdma/rpc_rdma.c           | 148 +++++++++++++++++++++=
++++++++++++++++++++++++--------------------
>> net/sunrpc/xprtrdma/svc_rdma.c           |   6 +++
>> net/sunrpc/xprtrdma/svc_rdma_transport.c |  58 +++++++++++++++++++++=
+++++
>> net/sunrpc/xprtrdma/transport.c          |  18 +++++++-
>> net/sunrpc/xprtrdma/verbs.c              | 479 +++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++++---------------------------------------------------------=
------------------------------------------------
>> net/sunrpc/xprtrdma/xprt_rdma.h          |  53 +++++++++++++++++++--=
---
>> net/sunrpc/xprtsock.c                    |  16 ++++++++
>> 15 files changed, 916 insertions(+), 316 deletions(-)
>> create mode 100644 net/sunrpc/xprtrdma/backchannel.c
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs"=
 in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> =E2=80=94
> Chuck Lever
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
