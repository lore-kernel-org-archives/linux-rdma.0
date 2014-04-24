From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1] NFS-RDMA: fix qp pointer validation checks
Date: Thu, 24 Apr 2014 11:01:25 -0400
Message-ID: <B39C0B38-357F-4BDA-BDA7-048BD38853F7@oracle.com>
References: <014738b6-698e-4ea1-82f9-287378bfec19@CMEXHTCAS2.ad.emulex.com> <D7AB2150-5F25-4BA2-80D9-94890AD11F8F@primarydata.com> <F1C70AD6-BDD4-4534-8DC4-61D2767581D9@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDEAA43@CMEXMB1.ad.emulex.com> <E66D006A-0D04-4602-8BF5-6834CACD2E24@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDEB3B4@CMEXMB1.ad.emulex.com> <BD7B05C0-4733-4DD1-83F3-B30B6B0EE48C@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDEB3DF@CMEXMB1.ad.emulex.com> <56C87770-7940-4006-948C-FEF3C0EC4ACC@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDEBD66@CMEXMB1.ad.emulex.com> <5710A71F-C4D5-408B-9B41-07F21B5853F0@oracle.com> <6837A427-B677-4CC7-A022-4FB9E52A3FC6@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDED915@CMEXMB1.ad.emulex.com> <C689AB91-46F6-4E96-A673-0DE76FE54CC4@oracle
 .com> <EE7902D3F51F404C82415C4803930ACD3FDEE11F@CMEXMB1.ad.emulex.com> <1bab6615-60c4-4865-a6a0-c53bb1c32341@CMEXHTCAS1.ad.emulex.com> <5358B975.4020207@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5358B975.4020207-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Apr 24, 2014, at 3:12 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> w=
rote:

> On 4/24/2014 2:30 AM, Devesh Sharma wrote:
>> Hi Chuck
>>=20
>> Following is the complete call trace of a typical NFS-RDMA transacti=
on while mounting a share.
>> It is unavoidable to stop calling post-send in case it is not create=
d. Therefore, applying checks to the connection state is a must
>> While registering/deregistering frmrs on-the-fly. The unconnected st=
ate of QP implies don't call  post_send/post_recv from any context.
>>=20
>=20
> Long thread... didn't follow it all.

I think you got the gist of it.

> If I understand correctly this race comes only for *cleanup* (LINV) o=
f FRMR registration while teardown flow destroyed the QP.
> I think this might be disappear if for each registration you post LIN=
V+FRMR.
> This is assuming that a situation where trying to post Fastreg on a "=
bad" QP can
> never happen (usually since teardown flow typically suspends outgoing=
 commands).

That=92s typically true for =93hard=94 NFS mounts. But =93soft=94 NFS m=
ounts
wake RPCs after a timeout while the transport is disconnected, in
order to kill them.  At that point, deregistration still needs to
succeed somehow.

IMO there are three related problems.

1.  rpcrdma_ep_connect() is allowing RPC tasks to be awoken while
    there is no QP at all (->qp is NULL). The woken RPC tasks are
    trying to deregister buffers that may include page cache pages,
    and it=92s oopsing because ->qp is NULL.

    That=92s a logic bug in rpcrdma_ep_connect(), and I have an idea
    how to address it.

2.  If a QP is present but disconnected, posting LOCAL_INV won=92t work=
=2E=20
    That leaves buffers (and page cache pages, potentially) registered.
    That could be addressed with LINV+FRMR. But...

3.  The client should not leave page cache pages registered indefinitel=
y.
    Both LINV+FRMR and our current approach depends on having a working
    QP _at_ _some_ _point_ =85 but the client simply can=92t depend on =
that.
    What happens if an NFS server is, say, destroyed by fire while ther=
e
    are active client mount points? What if the HCA=92s firmware is
    permanently not allowing QP creation?

Here's a relevant comment in rpcrdma_ep_connect():

 815                 /* TEMP TEMP TEMP - fail if new device:
 816                  * Deregister/remarshal *all* requests!
 817                  * Close and recreate adapter, pd, etc!
 818                  * Re-determine all attributes still sane!
 819                  * More stuff I haven't thought of!
 820                  * Rrrgh!
 821                  */

xprtrdma does not do this today.

When a new device is created, all existing RPC requests could be
deregistered and re-marshalled.  As far as I can tell,
rpcrdma_ep_connect() is executing in a synchronous context (the connect
worker) and we can simply use dereg_mr, as long as later, when the RPCs
are re-driven, they know they need to re-marshal.

I=92ll try some things today.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
