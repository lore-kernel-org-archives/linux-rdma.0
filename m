From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 02/12] xprtrdma: Raise maximum payload size to one megabyte
Date: Fri, 10 Jul 2015 15:33:55 -0400
Message-ID: <F9717330-F362-477B-915D-D6AAE7B5DDDB@oracle.com>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net> <20150709204159.26247.44592.stgit@manet.1015granger.net> <55A01B56.2020107@Netapp.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A01B56.2020107-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 10, 2015, at 3:21 PM, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>=
 wrote:

> Hi Chuck,
>=20
> On 07/09/2015 04:41 PM, Chuck Lever wrote:
>> The point of larger rsize and wsize is to reduce the per-byte cost
>> of memory registration and deregistration. Modern HCAs can typically
>> handle a megabyte or more with a single registration operation.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> net/sunrpc/xprtrdma/xprt_rdma.h |    3 +--
>> 1 file changed, 1 insertion(+), 2 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/x=
prt_rdma.h
>> index f49dd8b..abee472 100644
>> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
>> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
>> @@ -165,8 +165,7 @@ rdmab_to_msg(struct rpcrdma_regbuf *rb)
>>  * struct rpcrdma_buffer. N is the max number of outstanding request=
s.
>>  */
>>=20
>> -/* temporary static scatter/gather max */
>> -#define RPCRDMA_MAX_DATA_SEGS	(64)	/* max scatter/gather */
>> +#define RPCRDMA_MAX_DATA_SEGS	((1 * 1024 * 1024) / PAGE_SIZE)
>                                         ^^^
> What is the significance of the 1 here?

This echoes the definition of RPCSVC_MAXPAYLOAD.

=931=94 documents =93one=94 megabyte, I assume.


> Thanks,
> Anna
>=20
>> #define RPCRDMA_MAX_SEGS 	(RPCRDMA_MAX_DATA_SEGS + 2) /* head+tail =3D=
 2 */
>>=20
>> struct rpcrdma_buffer;
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



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
