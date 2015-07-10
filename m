From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 5/5] svcrdma: Boost NFS READ/WRITE payload size maximum
Date: Fri, 10 Jul 2015 10:59:48 -0400
Message-ID: <11D08769-F6EB-4696-8910-8B207B20CC10@oracle.com>
References: <20150709204230.8481.45457.stgit@klimt.1015granger.net> <20150709204546.8481.65857.stgit@klimt.1015granger.net> <20150710141814.GA31121@fieldses.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150710141814.GA31121-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Jul 10, 2015, at 10:18 AM, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org wrote:

> On Thu, Jul 09, 2015 at 04:45:47PM -0400, Chuck Lever wrote:
>> Increased to 1 megabyte.
>=20
> Why not more or less?
>=20
> Why do we even have this constant, why shouldn't we just use
> RPCSVC_MAXPAYLOAD?

The payload size maximum for RDMA is based on RPCRDMA_MAX_SVC_SEGS.
We could reverse the relationship and make RPCRDMA_MAX_SVC_SEGS
based on RPCSVC_MAXPAYLOAD divided by the platform=92s page size.


> --b.
>=20
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>=20
>> include/linux/sunrpc/svc_rdma.h |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>=20
>> diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/=
svc_rdma.h
>> index 13af61b..1bca6dd 100644
>> --- a/include/linux/sunrpc/svc_rdma.h
>> +++ b/include/linux/sunrpc/svc_rdma.h
>> @@ -172,7 +172,7 @@ struct svcxprt_rdma {
>> #define RDMAXPRT_SQ_PENDING	2
>> #define RDMAXPRT_CONN_PENDING	3
>>=20
>> -#define RPCRDMA_MAX_SVC_SEGS	(64)	/* server max scatter/gather */
>> +#define RPCRDMA_MAX_SVC_SEGS	(256)	/* server max scatter/gather */
>> #if RPCSVC_MAXPAYLOAD < (RPCRDMA_MAX_SVC_SEGS << PAGE_SHIFT)
>> #define RPCRDMA_MAXPAYLOAD	RPCSVC_MAXPAYLOAD
>> #else
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs"=
 in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
