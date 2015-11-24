From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 7/9] SUNRPC: Introduct xprt_commit_rqst()
Date: Tue, 24 Nov 2015 14:56:43 -0500
Message-ID: <DBE10AA1-F07E-4710-BF06-2B3E49A72B4D@oracle.com>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net> <20151123221446.32702.24797.stgit@manet.1015granger.net> <5654C079.7060507@Netapp.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5654C079.7060507-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 24, 2015, at 2:54 PM, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgRhl2p70BpVqQ@public.gmane.org=
m> wrote:
>=20
> Hi Chuck,
>=20
> On 11/23/2015 05:14 PM, Chuck Lever wrote:
>> I'm about to add code in the RPC/RDMA reply handler between the
>> xprt_lookup_rqst() and xprt_complete_rqst() call site that needs
>> to execute outside of spinlock critical sections.
>>=20
>> Add a hook to remove an rpc_rqst from the pending list once
>> the transport knows its going to invoke xprt_complete_rqst().
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> include/linux/sunrpc/xprt.h    |    1 +
>> net/sunrpc/xprt.c              |   14 ++++++++++++++
>> net/sunrpc/xprtrdma/rpc_rdma.c |    4 ++++
>> 3 files changed, 19 insertions(+)
>>=20
>> diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt=
=2Eh
>> index 69ef5b3..ab6c3a5 100644
>> --- a/include/linux/sunrpc/xprt.h
>> +++ b/include/linux/sunrpc/xprt.h
>> @@ -366,6 +366,7 @@ void			xprt_wait_for_buffer_space(struct rpc_tas=
k *task, rpc_action action);
>> void			xprt_write_space(struct rpc_xprt *xprt);
>> void			xprt_adjust_cwnd(struct rpc_xprt *xprt, struct rpc_task *task=
, int result);
>> struct rpc_rqst *	xprt_lookup_rqst(struct rpc_xprt *xprt, __be32 xid=
);
>> +void			xprt_commit_rqst(struct rpc_task *task);
>> void			xprt_complete_rqst(struct rpc_task *task, int copied);
>> void			xprt_release_rqst_cong(struct rpc_task *task);
>> void			xprt_disconnect_done(struct rpc_xprt *xprt);
>> diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
>> index 2e98f4a..a5be4ab 100644
>> --- a/net/sunrpc/xprt.c
>> +++ b/net/sunrpc/xprt.c
>> @@ -837,6 +837,20 @@ static void xprt_update_rtt(struct rpc_task *ta=
sk)
>> }
>>=20
>> /**
>> + * xprt_commit_rqst - remove rqst from pending list early
>> + * @task: RPC request to remove
>=20
> Is xprt_commit_rqst() the right name for this function?  Removing a r=
equest from a list isn't how I would expect a commit to work.

=E2=80=9Ccommit=E2=80=9D means the request is committed: we have a pars=
e-able
reply and will proceed to completion. The name does not reflect
the mechanism, but the policy.

Any suggestions on a different name?


> Anna
>=20
>> + *
>> + * Caller holds transport lock.
>> + */
>> +void xprt_commit_rqst(struct rpc_task *task)
>> +{
>> +	struct rpc_rqst *req =3D task->tk_rqstp;
>> +
>> +	list_del_init(&req->rq_list);
>> +}
>> +EXPORT_SYMBOL_GPL(xprt_commit_rqst);
>> +
>> +/**
>>  * xprt_complete_rqst - called when reply processing is complete
>>  * @task: RPC request that recently completed
>>  * @copied: actual number of bytes received from the transport
>> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rp=
c_rdma.c
>> index a169252..d7b9156 100644
>> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
>> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
>> @@ -811,6 +811,9 @@ rpcrdma_reply_handler(struct rpcrdma_rep *rep)
>> 	if (req->rl_reply)
>> 		goto out_duplicate;
>>=20
>> +	xprt_commit_rqst(rqst->rq_task);
>> +	spin_unlock_bh(&xprt->transport_lock);
>> +
>> 	dprintk("RPC:       %s: reply 0x%p completes request 0x%p\n"
>> 		"                   RPC request 0x%p xid 0x%08x\n",
>> 			__func__, rep, req, rqst,
>> @@ -901,6 +904,7 @@ badheader:
>> 	else if (credits > r_xprt->rx_buf.rb_max_requests)
>> 		credits =3D r_xprt->rx_buf.rb_max_requests;
>>=20
>> +	spin_lock_bh(&xprt->transport_lock);
>> 	cwnd =3D xprt->cwnd;
>> 	xprt->cwnd =3D credits << RPC_CWNDSHIFT;
>> 	if (xprt->cwnd > cwnd)
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs"=
 in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>=20

--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
