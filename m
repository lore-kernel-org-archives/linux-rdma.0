From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 6/7] xprtrdma: Add class for RDMA backwards direction transport
Date: Tue, 1 Dec 2015 09:36:47 -0500
Message-ID: <170ADDEE-DBC2-4481-BD98-8DB0ADF94877@oracle.com>
References: <20151130222141.13029.98664.stgit@klimt.1015granger.net> <20151130222513.13029.52447.stgit@klimt.1015granger.net> <565DA2CA.5090507@talpey.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565DA2CA.5090507-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Dec 1, 2015, at 8:38 AM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> On 11/30/2015 5:25 PM, Chuck Lever wrote:
>> To support the server-side of an NFSv4.1 backchannel on RDMA
>> connections, add a transport class that enables backward
>> direction messages on an existing forward channel connection.
>>=20
>=20
>> +static void *
>> +xprt_rdma_bc_allocate(struct rpc_task *task, size_t size)
>> +{
>> +	struct rpc_rqst *rqst =3D task->tk_rqstp;
>> +	struct svc_rdma_op_ctxt *ctxt;
>> +	struct svcxprt_rdma *rdma;
>> +	struct svc_xprt *sxprt;
>> +	struct page *page;
>> +
>> +	if (size > PAGE_SIZE) {
>> +		WARN_ONCE(1, "failed to handle buffer allocation (size %zu)\n",
>> +			  size);
>=20
> You may want to add more context to that rather cryptic string, at
> least the function name.
>=20
> Also, it's not exactly "failed to handle", it's an invalid size. Why
> would this ever happen? Why even log it?
>=20
>=20
>=20
>> +static int
>> +rpcrdma_bc_send_request(struct svcxprt_rdma *rdma, struct rpc_rqst =
*rqst)
>> +{
> ...
>> +
>> +drop_connection:
>> +	dprintk("Failed to send backchannel call\n");
>=20
> Ditto on the prefix / function context.
>=20
> And also...
>=20
>> +	dprintk("%s: sending request with xid: %08x\n",
>> +		__func__, be32_to_cpu(rqst->rq_xid));
> ...
>> +	dprintk("RPC:       %s: xprt %p\n", __func__, xprt);
>=20
> The format strings for many of the dprintk's are somewhat inconsisten=
t.
> Some start with "RPC", some with the function name, and some (in othe=
r
> patches of this series) with "svcrdma". Confusing, and perhaps hard t=
o
> pick out of the log.

They do follow a convention: =E2=80=9CRPC:      =E2=80=9C is used on th=
e client
side when there is no rpc_task::tk_pid available. =E2=80=9Csvcrdma=E2=80=
=9D is
used on the server everywhere.

The dprintk changes here were a bit cursory, so I will go back and
review them more carefully.

--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
