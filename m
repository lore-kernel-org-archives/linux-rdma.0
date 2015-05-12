From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 02/16] xprtrdma: Warn when there are orphaned IB objects
Date: Tue, 12 May 2015 14:20:00 -0400
Message-ID: <D9E151CC-AC68-42BF-9025-AEB77201611D@oracle.com>
References: <20150511174401.31263.79596.stgit@manet.1015granger.net> <20150511180235.31263.71754.stgit@manet.1015granger.net> <5552428D.7010907@Netapp.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5552428D.7010907-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 12, 2015, at 2:12 PM, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>=
 wrote:

> Hi Chuck,
>=20
> On 05/11/2015 02:02 PM, Chuck Lever wrote:
>> WARN during transport destruction if ib_dealloc_pd() fails. This is
>> a sign that xprtrdma orphaned one or more RDMA API objects at some
>> point, which can pin lower layer kernel modules and cause shutdown
>> to hang.
>=20
> I'm curious, what would cause an RDMA object to get orphaned in the f=
irst place?

A leaked object means there=92s a software bug in the API consumer, whi=
ch
is xprtrdma in this case. xprtrdma is supposed to track and clean up
every object it creates.

> Is there any way to prevent that?

The usual thing to do is find and fix the bug that allowed the leak.

> Anna
>=20
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reviewed-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
>> ---
>> net/sunrpc/xprtrdma/verbs.c |   10 +++++-----
>> 1 file changed, 5 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs=
=2Ec
>> index 4870d27..51900e6 100644
>> --- a/net/sunrpc/xprtrdma/verbs.c
>> +++ b/net/sunrpc/xprtrdma/verbs.c
>> @@ -702,17 +702,17 @@ rpcrdma_ia_close(struct rpcrdma_ia *ia)
>> 		dprintk("RPC:       %s: ib_dereg_mr returned %i\n",
>> 			__func__, rc);
>> 	}
>> +
>> 	if (ia->ri_id !=3D NULL && !IS_ERR(ia->ri_id)) {
>> 		if (ia->ri_id->qp)
>> 			rdma_destroy_qp(ia->ri_id);
>> 		rdma_destroy_id(ia->ri_id);
>> 		ia->ri_id =3D NULL;
>> 	}
>> -	if (ia->ri_pd !=3D NULL && !IS_ERR(ia->ri_pd)) {
>> -		rc =3D ib_dealloc_pd(ia->ri_pd);
>> -		dprintk("RPC:       %s: ib_dealloc_pd returned %i\n",
>> -			__func__, rc);
>> -	}
>> +
>> +	/* If the pd is still busy, xprtrdma missed freeing a resource */
>> +	if (ia->ri_pd && !IS_ERR(ia->ri_pd))
>> +		WARN_ON(ib_dealloc_pd(ia->ri_pd));
>> }
>>=20
>> /*
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs"=
 in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
