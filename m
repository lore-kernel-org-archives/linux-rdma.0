From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] svcrdma: Do not send XDR roundup bytes for a write chunk
Date: Thu, 12 Nov 2015 09:31:06 -0500
Message-ID: <25743A21-B35C-4B38-93A1-681727BFCC57@oracle.com>
References: <20151016132938.8597.65237.stgit@oracle-120.nfsv4bat.org> <94E65795-E205-44FE-93DE-A1FF24CD5C2E@oracle.com> <2CF378F3-09B3-441D-9DE6-5336F0B8BF65@oracle.com> <20151112141907.GA6137@fieldses.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151112141907.GA6137-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 12, 2015, at 9:19 AM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> w=
rote:
>=20
> On Wed, Nov 11, 2015 at 03:20:33PM -0500, Chuck Lever wrote:
>>=20
>>> On Nov 3, 2015, at 3:10 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wr=
ote:
>>>=20
>>>=20
>>>> On Oct 16, 2015, at 9:30 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> =
wrote:
>>>>=20
>>>> Minor optimization: when dealing with write chunk XDR roundup, do
>>>> not post a Write WR for the zero bytes in the pad. Simply update
>>>> the write segment in the RPC-over-RDMA header to reflect the extra
>>>> pad bytes.
>>>>=20
>>>> The Reply chunk is also a write chunk, but the server does not use
>>>> send_write_chunks() to send the Reply chunk. That's OK in this cas=
e:
>>>> the server Upper Layer typically marshals the Reply chunk contents
>>>> in a single contiguous buffer, without a separate tail for the XDR
>>>> pad.
>>>>=20
>>>> The comments and the variable naming refer to "chunks" but what is
>>>> really meant is "segments." The existing code sends only one
>>>> xdr_write_chunk per RPC reply.
>>>>=20
>>>> The fix assumes this as well. When the XDR pad in the first write
>>>> chunk is reached, the assumption is the Write list is complete and
>>>> send_write_chunks() returns.
>>>>=20
>>>> That will remain a valid assumption until the server Upper Layer c=
an
>>>> support multiple bulk payload results per RPC.
>>>>=20
>>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>> --
>>>=20
>>> Bruce, can you take this for 4.4 ?
>>=20
>> Hi Bruce-
>>=20
>> Your 4.4 pull request did not include this patch.
>=20
> Whoops, sorry.
>=20
> For some reason I don't have the original email, though I do see your
> first followup.  Would you mind resending?
>=20
> Also, it looks like that wasn't actually sent to me?  I really want
> submitted patches to have my address on the To: line.  Obviously I al=
so
> try to pick up stuff sent only to the mailing list, but I'm a little
> more likely to miss those.

Yep, my bad, I meant to address that To: you. Will repost.


> But my fault either way, apologies.
>=20
> --b.
>=20
>>=20
>>=20
>>>> net/sunrpc/xprtrdma/svc_rdma_sendto.c |    7 +++++++
>>>> 1 files changed, 7 insertions(+), 0 deletions(-)
>>>>=20
>>>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xp=
rtrdma/svc_rdma_sendto.c
>>>> index 1dfae83..6c48901 100644
>>>> --- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
>>>> +++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
>>>> @@ -342,6 +342,13 @@ static int send_write_chunks(struct svcxprt_r=
dma *xprt,
>>>> 						arg_ch->rs_handle,
>>>> 						arg_ch->rs_offset,
>>>> 						write_len);
>>>> +
>>>> +		/* Do not send XDR pad bytes */
>>>> +		if (chunk_no && write_len < 4) {
>>>> +			chunk_no++;
>>>> +			break;
>>>> +		}
>>>> +
>>>> 		chunk_off =3D 0;
>>>> 		while (write_len) {
>>>> 			ret =3D send_write(xprt, rqstp,
>>>>=20
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>=20
>>> =E2=80=94
>>> Chuck Lever
>>>=20
>>>=20
>>>=20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-nfs=
" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>> =E2=80=94
>> Chuck Lever
>>=20
>>=20

=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
