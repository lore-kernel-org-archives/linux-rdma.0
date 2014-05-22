From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 20/24] xprtrdma: Reset connection timeout after successful reconnect
Date: Wed, 21 May 2014 23:28:24 -0400
Message-ID: <D839BB6A-CDD2-47B6-B758-F89296F4A147@oracle.com>
References: <20140522004505.27190.58897.stgit@manet.1015granger.net> <20140522005707.27190.2035.stgit@manet.1015granger.net> <CAABAsM5m_CT7qUv4Xbm+LKoSZaia55APO3kgnt7Ti1x24gsrbg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAABAsM5m_CT7qUv4Xbm+LKoSZaia55APO3kgnt7Ti1x24gsrbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trondmy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On May 21, 2014, at 10:07 PM, Trond Myklebust <trondmy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:

> On Wed, May 21, 2014 at 8:57 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>=
 wrote:
>> If the new connection is able to make forward progress, reset the
>> re-establish timeout. Otherwise it keeps growing even if disconnect
>> events are rare.
>>=20
>> The same behavior as TCP is adopted: reconnect immediately if the
>> transport instance has been able to make some forward progress.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>=20
>> net/sunrpc/xprtrdma/rpc_rdma.c |    2 ++
>> 1 files changed, 2 insertions(+), 0 deletions(-)
>>=20
>> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rp=
c_rdma.c
>> index dc4a826..1334646 100644
>> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
>> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
>> @@ -770,6 +770,8 @@ repost:
>>=20
>>        /* from here on, the reply is no longer an orphan */
>>        req->rl_reply =3D rep;
>> +       if (xprt->reestablish_timeout)
>> +               xprt->reestablish_timeout =3D 0;
>=20
> What's the point of making this conditional?

Good catch. I=92ll remove the conditional.

I copied this straight from xs_tcp_data_ready().

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
