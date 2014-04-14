From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1] NFS-RDMA: fix qp pointer validation checks
Date: Mon, 14 Apr 2014 16:53:49 -0400
Message-ID: <6837A427-B677-4CC7-A022-4FB9E52A3FC6@oracle.com>
References: <014738b6-698e-4ea1-82f9-287378bfec19@CMEXHTCAS2.ad.emulex.com> <D7AB2150-5F25-4BA2-80D9-94890AD11F8F@primarydata.com> <F1C70AD6-BDD4-4534-8DC4-61D2767581D9@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDEAA43@CMEXMB1.ad.emulex.com> <E66D006A-0D04-4602-8BF5-6834CACD2E24@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDEB3B4@CMEXMB1.ad.emulex.com> <BD7B05C0-4733-4DD1-83F3-B30B6B0EE48C@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDEB3DF@CMEXMB1.ad.emulex.com> <56C87770-7940-4006-948C-FEF3C0EC4ACC@oracle.com> <EE7902D3F51F404C82415C4803930ACD3FDEBD66@CMEXMB1.ad.emulex.com> <5710A71F-C4D5-408B-9B41-07F21B5853F0@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5710A71F-C4D5-408B-9B41-07F21B5853F0-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Devesh-


On Apr 13, 2014, at 12:01 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrot=
e:

>=20
> On Apr 11, 2014, at 7:51 PM, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>=20
>> Hi  Chuck,
>> Yes that is the case, Following is the trace I got.
>>=20
>> <4>RPC:   355 setting alarm for 60000 ms
>> <4>RPC:   355 sync task going to sleep
>> <4>RPC:       xprt_rdma_connect_worker: reconnect
>> <4>RPC:       rpcrdma_ep_disconnect: rdma_disconnect -1
>> <4>RPC:       rpcrdma_ep_connect: rpcrdma_ep_disconnect status -1
>> <3>ocrdma_mbx_create_qp(0) rq_err
>> <3>ocrdma_mbx_create_qp(0) sq_err
>> <3>ocrdma_create_qp(0) error=3D-1
>> <4>RPC:       rpcrdma_ep_connect: rdma_create_qp failed -1
>> <4>RPC:   355 __rpc_wake_up_task (now 4296956756)
>> <4>RPC:   355 disabling timer
>> <4>RPC:   355 removed from queue ffff880454578258 "xprt_pending"
>> <4>RPC:       __rpc_wake_up_task done
>> <4>RPC:       xprt_rdma_connect_worker: exit
>> <4>RPC:   355 sync task resuming
>> <4>RPC:   355 xprt_connect_status: error 1 connecting to server 192.=
168.1.1
>=20
> xprtrdma=92s connect worker is returning =931=94 instead of a negativ=
e errno.
> That=92s the bug that triggers this chain of events.

rdma_create_qp() has returned -EPERM. There=92s very little xprtrdma ca=
n do if
the provider won=92t even create a QP. That seems like a rare and fatal=
 problem.

=46or the moment, I=92m inclined to think that a panic is correct behav=
ior, since
there are outstanding registered memory regions that cannot be cleaned =
up
without a QP (see below).


> RPC tasks waiting for the reconnect are awoken. xprt_connect_status()=
 doesn=92t
> recognize a tk_status of =931=94, so it turns it into -EIO, and kills=
 each waiting
> RPC task.

>> <4>RPC:       wake_up_next(ffff880454578190 "xprt_sending")
>> <4>RPC:   355 call_connect_status (status -5)
>> <4>RPC:   355 return 0, status -5
>> <4>RPC:   355 release task
>> <4>RPC:       wake_up_next(ffff880454578190 "xprt_sending")
>> <4>RPC:       xprt_rdma_free: called on 0x(null)
>=20
> And as part of exiting, the RPC task has to free its buffer.
>=20
> Not exactly sure why req->rl_nchunks is not zero for an NFSv4 GETATTR=
=2E
> This is why rpcrdma_deregister_external() is invoked here.
>=20
> Eventually this gets around to attempting to post a LOCAL_INV WR with
> ->qp set to NULL, and the panic below occurs.

This is a somewhat different problem.

Not only do we need to have a good ->qp here, but it has to be connecte=
d
and in the ready-to-send state before LOCAL_INV work requests can be po=
sted.

The implication of this is that if a server disconnects (server crash
or network partition), the client is stuck waiting for the server to co=
me
back before it can deregister memory and retire outstanding RPC request=
s.

This is bad for ^C or soft timeouts or umount =85 when the server is un=
available.

So I feel we need better clean-up when the client cannot reconnect. Pro=
bably
deregistering RPC chunk MR=92s before finally tearing down the old QP i=
s what
is necessary.

I=92ll play around with this idea.


--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
