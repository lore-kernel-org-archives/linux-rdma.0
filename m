From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 02/14] xprtrdma: Warn when there are orphaned IB objects
Date: Wed, 6 May 2015 09:24:19 -0400
Message-ID: <963F9850-38D0-4434-88E8-14BC42F74499@oracle.com>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net> <20150504175700.3483.57728.stgit@manet.1015granger.net> <CANjDDBicLDb7K=RZB5Gqv+oACaAG8DANJX3ML971jnXd_5KEuQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBicLDb7K=RZB5Gqv+oACaAG8DANJX3ML971jnXd_5KEuQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Devesh-

On May 6, 2015, at 7:37 AM, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>=
 wrote:

> On Mon, May 4, 2015 at 11:27 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>=
 wrote:
>>=20
>> Print an error during transport destruction if ib_dealloc_pd()
>> fails. This is a sign that xprtrdma orphaned one or more RDMA API
>> objects at some point, which can pin lower layer kernel modules
>> and cause shutdown to hang.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> net/sunrpc/xprtrdma/verbs.c |    4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index 4870d27..0cc4617 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -710,8 +710,8 @@ rpcrdma_ia_close(struct rpcrdma_ia *ia)
>>        }
>>        if (ia->ri_pd !=3D NULL && !IS_ERR(ia->ri_pd)) {
>>                rc =3D ib_dealloc_pd(ia->ri_pd);
>> -               dprintk("RPC:       %s: ib_dealloc_pd returned %i\n"=
,
>> -                       __func__, rc);
>=20
> Should we check for EBUSY explicitly? other then this is an error in
> vendor specific ib_dealloc_pd()

Any error return means ib_dealloc_pd() has failed, right? Doesn=92t tha=
t
mean the PD is still allocated, and could cause problems later?


>> +               if (rc)
>> +                       pr_warn("rpcrdma: ib_dealloc_pd status %i\n"=
, rc);
>>        }
>> }

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
