From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 05/21] xprtrdma: On disconnect, don't ignore pending CQEs
Date: Wed, 9 Jul 2014 17:39:32 -0400
Message-ID: <8831FD31-A62F-4DE1-84A4-4C71C5C1985D@oracle.com>
References: <20140709163326.3496.37893.stgit@manet.1015granger.net> <20140709165713.3496.64777.stgit@manet.1015granger.net> <53BDB3EE.8060509@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BDB3EE.8060509-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Shirley-

On Jul 9, 2014, at 5:28 PM, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> Should all rdma_clean_cq be replaced by flush_cqs? The outstanding CQ=
Es should be processed in any context.

The only other context is when the transport is being destroyed (ie,
at umount time).

Send CQEs don=92t matter at that point: the FRMRs are going to get
deregistered no matter what state they are in.

The RPC client waits for all remaining RPCs to complete before it=20
attempts to destroy the transport, so there shouldn=92t be any receive
CQEs at that point either.

> Shirley
>=20
> On 07/09/2014 09:57 AM, Chuck Lever wrote:
>> xprtrdma is currently throwing away queued completions during
>> a reconnect. RPC replies posted just before connection loss, or
>> successful completions that change the state of an FRMR, can be
>> missed.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> net/sunrpc/xprtrdma/verbs.c |   14 +++++++++-----
>> 1 file changed, 9 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index 0d5187d..7fd457e 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -310,6 +310,13 @@ rpcrdma_recvcq_upcall(struct ib_cq *cq, void *c=
q_context)
>> 	rpcrdma_recvcq_poll(cq, ep);
>> }
>>=20
>> +static void
>> +rpcrdma_flush_cqs(struct rpcrdma_ep *ep)
>> +{
>> +	rpcrdma_recvcq_upcall(ep->rep_attr.recv_cq, ep);
>> +	rpcrdma_sendcq_upcall(ep->rep_attr.send_cq, ep);
>> +}
>> +
>> #ifdef RPC_DEBUG
>> static const char * const conn[] =3D {
>> 	"address resolved",
>> @@ -872,9 +879,7 @@ retry:
>> 		if (rc && rc !=3D -ENOTCONN)
>> 			dprintk("RPC:       %s: rpcrdma_ep_disconnect"
>> 				" status %i\n", __func__, rc);
>> -
>> -		rpcrdma_clean_cq(ep->rep_attr.recv_cq);
>> -		rpcrdma_clean_cq(ep->rep_attr.send_cq);
>> +		rpcrdma_flush_cqs(ep);
>>=20
>> 		xprt =3D container_of(ia, struct rpcrdma_xprt, rx_ia);
>> 		id =3D rpcrdma_create_id(xprt, ia,
>> @@ -985,8 +990,7 @@ rpcrdma_ep_disconnect(struct rpcrdma_ep *ep, str=
uct rpcrdma_ia *ia)
>> {
>> 	int rc;
>>=20
>> -	rpcrdma_clean_cq(ep->rep_attr.recv_cq);
>> -	rpcrdma_clean_cq(ep->rep_attr.send_cq);
>> +	rpcrdma_flush_cqs(ep);
>> 	rc =3D rdma_disconnect(ia->ri_id);
>> 	if (!rc) {
>> 		/* returns without wait if not connected */
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
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
