From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 07/12] xprtrdma: Don't provide a reply chunk when expecting a short reply
Date: Sun, 12 Jul 2015 14:38:44 -0400
Message-ID: <2EB8EA33-9345-4D18-8BE1-39C4EB2658E2@oracle.com>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net> <20150709204246.26247.10367.stgit@manet.1015granger.net> <55A2809C.7020106@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A2809C.7020106-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi-


On Jul 12, 2015, at 10:58 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> =
wrote:

> On 7/9/2015 11:42 PM, Chuck Lever wrote:
>> Currently Linux always offers a reply chunk, even for small replies
>> (unless a read or write list is needed for the RPC operation).
>>=20
>> A comment in rpcrdma_marshal_req() reads:
>>=20
>>> Currently we try to not actually use read inline.
>>> Reply chunks have the desirable property that
>>> they land, packed, directly in the target buffers
>>> without headers, so they require no fixup. The
>>> additional RDMA Write op sends the same amount
>>> of data, streams on-the-wire and adds no overhead
>>> on receive. Therefore, we request a reply chunk
>>> for non-writes wherever feasible and efficient.
>>=20
>> This considers only the network bandwidth cost of sending the RPC
>> reply. For replies which are only a few dozen bytes, this is
>> typically not a good trade-off.
>>=20
>> If the server chooses to return the reply inline:
>>=20
>>  - The client has registered and invalidated a memory region to
>>    catch the reply, which is then not used
>>=20
>> If the server chooses to use the reply chunk:
>>=20
>>  - The server sends a few bytes using a heavyweight RDMA WRITE for
>>    operation. The entire RPC reply is conveyed in two RDMA
>>    operations (WRITE_ONLY, SEND) instead of one.
>=20
> Pipelined WRITE+SEND operations are hardly an overhead compared to
> copying chunks of data.
>=20
>>=20
>> Note that both the server and client have to prepare or copy the
>> reply data anyway to construct these replies. There's no benefit to
>> using an RDMA transfer since the host CPU has to be involved.
>=20
> I think that preparation (posting 1 or 2 WQEs) and copying
> chunks of data of say 8K-16K might be different.

Two points that are probably not clear from my patch description:

1. This patch affects only replies (usually much) smaller than the
   client=92s inline threshold (1KB). Anything larger will continue
   to use RDMA transfer.

2. These replies are constructed in the RPC buffer by the server,
   and parsed in the receive buffer by the client. They are not
   simple data copies on either endpoint.

Think NFS GETATTR: the server is gathering metadata from multiple
sources, and XDR encoding it in the reply send buffer. The data
is not copied, it is manipulated before the SEND.

The client then XDR decodes the received stream and scatters the
decoded results into multiple in-memory data structures.

Because XDR encoding/decoding is involved, there really is no
benefit to an RDMA transfer for these replies.


> I understand that you probably see better performance scaling. But th=
is
> might be HW dependent. Also, this might backfire on you if your
> configuration is one-to-many. Then, data copy CPU cycles might become
> more expensive.
>=20
> I don't really know what is better, but just thought I'd present
> another side to this.

Thanks for your review!

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
