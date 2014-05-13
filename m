From: Chuck Lever <chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 RFC 2/3] svcrdma: Recvfrom changes
Date: Tue, 13 May 2014 17:44:41 -0400
Message-ID: <3DAF95F3-22D5-4FC5-8C98-5A440E54DC2F@gmail.com>
References: <20140506174621.18208.24242.stgit@build.ogc.int> <20140506174632.18208.28160.stgit@build.ogc.int> <F997E138-FB04-4149-811D-CE68608E8D6B@gmail.com> <00f901cf6eeb$2ff1f630$8fd5e290$@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00f901cf6eeb$2ff1f630$8fd5e290$@opengridcomputing.com>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 13, 2014, at 4:37 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> w=
rote:

>=20
>=20
>> -----Original Message-----
>> From: Chuck Lever [mailto:chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> Sent: Tuesday, May 13, 2014 1:22 PM
>> To: Steve Wise
>> Cc: J. Bruce Fields; Linux NFS Mailing List; linux-rdma-u79uwXL29TasMV2rI37PzA@public.gmane.org=
org; Tom Tucker
>> Subject: Re: [PATCH V2 RFC 2/3] svcrdma: Recvfrom changes
>>=20
>> Hi Steve-
>>=20
>> Some random review comments, see below.
>>=20
>=20
> <snip>
>=20
>>> +static int rdma_read_chunks(struct svcxprt_rdma *xprt,
>>> +			    struct rpcrdma_msg *rmsgp,
>>> +			    struct svc_rqst *rqstp,
>>> +			    struct svc_rdma_op_ctxt *head)
>>> {
>>> -	struct ib_send_wr read_wr;
>>> -	struct ib_send_wr inv_wr;
>>> -	int err =3D 0;
>>> -	int ch_no;
>>> -	int ch_count;
>>> -	int byte_count;
>>> -	int sge_count;
>>> -	u64 sgl_offset;
>>> +	int page_no, ch_count, ret;
>>> 	struct rpcrdma_read_chunk *ch;
>>> -	struct svc_rdma_op_ctxt *ctxt =3D NULL;
>>> -	struct svc_rdma_req_map *rpl_map;
>>> -	struct svc_rdma_req_map *chl_map;
>>> +	u32 page_offset, byte_count;
>>> +	u64 rs_offset;
>>> +	rdma_reader_fn reader;
>>>=20
>>> 	/* If no read list is present, return 0 */
>>> 	ch =3D svc_rdma_get_read_chunk(rmsgp);
>>> @@ -408,122 +368,53 @@ static int rdma_read_xdr(struct svcxprt_rdma=
 *xprt,
>>> 	if (ch_count > RPCSVC_MAXPAGES)
>>> 		return -EINVAL;
>>=20
>> I'm not sure what this ^^^ ch_count check is doing, but maybe I have=
n't had
>> enough caffeine this morning. Shouldn't this code be comparing the s=
egment
>> count, not the chunk count, with MAXPAGES?
>=20
> Isn't ch_count really the number of chunks in the RPC?

Sort of. Block comment in front of svc_rdma_rcl_chunk_counts() reads:

 74  * Determine number of chunks and total bytes in chunk list. The ch=
unk
 75  * list has already been verified to fit within the RPCRDMA header.

So, called from rdma_read_chunks(), ch_count is the number of chunks in
the Read list.

As you point out below, NFS/RDMA passes either a Read or a Write list,
not both. So it amounts to the same thing as the total number of chunks
in the RPC.

> I'm not sure what "segment count=94 you are talking about?

AFAICT a chunk is a list of segments. Thus one chunk can reference
many pages, one per segment.

If you print ch_count, it is 2 for NFS WRITEs from a Linux client,
no matter how large the write payload is. Therefore I think the check
as it is written is not particularly useful.

The returned ch_count here is not used beyond that check, after the
refactoring patch is applied. The returned byte_count includes all
chunks in the passed-in chunk list, whereas I think it should count
only the first chunk in the list.

>=20
>>=20
>>=20
>>>=20
>>> -	/* Allocate temporary reply and chunk maps */
>>> -	rpl_map =3D svc_rdma_get_req_map();
>>> -	chl_map =3D svc_rdma_get_req_map();
>>> -
>>> -	if (!xprt->sc_frmr_pg_list_len)
>>> -		sge_count =3D map_read_chunks(xprt, rqstp, hdr_ctxt, rmsgp,
>>> -					    rpl_map, chl_map, ch_count,
>>> -					    byte_count);
>>> -	else
>>> -		sge_count =3D fast_reg_read_chunks(xprt, rqstp, hdr_ctxt, rmsgp,
>>> -						 rpl_map, chl_map, ch_count,
>>> -						 byte_count);
>>> -	if (sge_count < 0) {
>>> -		err =3D -EIO;
>>> -		goto out;
>>> -	}
>>> -
>>> -	sgl_offset =3D 0;
>>> -	ch_no =3D 0;
>>> +	/* The request is completed when the RDMA_READs complete. The
>>> +	 * head context keeps all the pages that comprise the
>>> +	 * request.
>>> +	 */
>>> +	head->arg.head[0] =3D rqstp->rq_arg.head[0];
>>> +	head->arg.tail[0] =3D rqstp->rq_arg.tail[0];
>>> +	head->arg.pages =3D &head->pages[head->count];
>>> +	head->hdr_count =3D head->count;
>>> +	head->arg.page_base =3D 0;
>>> +	head->arg.page_len =3D 0;
>>> +	head->arg.len =3D rqstp->rq_arg.len;
>>> +	head->arg.buflen =3D rqstp->rq_arg.buflen + PAGE_SIZE;
>>>=20
>>> +	page_no =3D 0; page_offset =3D 0;
>>> 	for (ch =3D (struct rpcrdma_read_chunk *)&rmsgp->rm_body.rm_chunks=
[0];
>>> -	     ch->rc_discrim !=3D 0; ch++, ch_no++) {
>>> -		u64 rs_offset;
>>> -next_sge:
>>> -		ctxt =3D svc_rdma_get_context(xprt);
>>> -		ctxt->direction =3D DMA_FROM_DEVICE;
>>> -		ctxt->frmr =3D hdr_ctxt->frmr;
>>> -		ctxt->read_hdr =3D NULL;
>>> -		clear_bit(RDMACTXT_F_LAST_CTXT, &ctxt->flags);
>>> -		clear_bit(RDMACTXT_F_FAST_UNREG, &ctxt->flags);
>>> +	     ch->rc_discrim !=3D 0; ch++) {
>>=20
>>=20
>> As I understand it, this loop is iterating over the items in the RPC
>> header's read chunk list.
>>=20
>> RFC 5667 section 4 says
>>=20
>> "The server MUST ignore any Read list for other NFS procedures, as w=
ell
>> as additional Read list entries beyond the first in the list."
>>=20
>=20
> I interpret this to say the server should ignore an RDMA Write list, =
if present, when
> processing an NFS WRITE (because the server emits RDMA Reads to the c=
lient in this case).
> Similarly, it should ignore an RDMA Read list when processing an NFS =
READ (which generates
> RDMA Writes from the server->client to fulfill the NFS READ).=20

That=92s already stated explicitly in a later paragraph. So this text
is getting at something else, IMO. Here=92s the full context:
=20
4.  NFS Versions 2 and 3 Mapping

   A single RDMA Write list entry MAY be posted by the client to receiv=
e
   either the opaque file data from a READ request or the pathname from
   a READLINK request.  The server MUST ignore a Write list for any
   other NFS procedure, as well as any Write list entries beyond the
   first in the list.

   Similarly, a single RDMA Read list entry MAY be posted by the client
   to supply the opaque file data for a WRITE request or the pathname
   for a SYMLINK request.  The server MUST ignore any Read list for
   other NFS procedures, as well as additional Read list entries beyond
   the first in the list.

   Because there are no NFS version 2 or 3 requests that transfer bulk
   data in both directions, it is not necessary to post requests
   containing both Write and Read lists.  Any unneeded Read or Write
   lists are ignored by the server.

If there is a Read list, it can contain one chunk for NFS WRITE and
SYMLINK operations, otherwise it should contain zero chunks. Anything
else MUST be ignored (ie, the server mustn=92t process the additional
chunks, and mustn=92t throw an error).

Processing the second chunk from the client during NFS WRITE operations
is incorrect. The additional chunk should be ignored, and the first
chunk should be padded on the server to make things work right in the
upper layer (the server=92s NFS WRITE XDR decoder).

>=20
>> But rdma_read_chunks() still expects multiple chunks in the incoming=
 list.
>=20
> An RDMA Read list can have multiple chunks, yes?

It can. But RFC 5667 suggests that particularly for NFS requests, only
a Read list of zero or one chunks is valid.

>=20
>> Should this code follow the RFC and process only the first chunk in
>> each RPC header, or did I misunderstand the RFC text?
>>=20
>> I'm not sure how the RPC layer should enforce the requirement to ign=
ore
>> chunks for particular classes of NFS requests. But seems like valid
>> NFS/RDMA requests will have only zero or one item in each chunk list=
=2E
>>=20
>>=20
>> The ramification of this change:
>>=20
>> The Linux client sends an extra chunk which is a zero pad to satisfy=
 XDR
>> alignment. This results in an extra RDMA READ on the wire for a payl=
oad
>> that is never more than 3 bytes of zeros.
>>=20
>=20
> This sounds like a logic bug in the server then.

Perhaps it=92s simply that this code was designed before RFC 5667 was
published. Certainly the client expects the server might work this way.

> You see these IOs on the wire?

I see extra iterations in the RDMA READ loop on the server, both before
and after the refactoring patch.

I haven=92t looked at the wire because ib_dump doesn=92t work with the =
mthca
provider.

>=20
>> Section 3.7 of RFC 5666 states:
>>=20
>> "If in turn, no data remains to be decoded from the inline portion, =
then
>> the receiver MUST conclude that roundup is present, and therefore it
>> advances the XDR decode position to that indicated by the next chunk=
 (if
>> any).  In this way, roundup is passed without ever actually transfer=
ring
>> additional XDR bytes."
>>=20
>> Later, it states:
>>=20
>> "Senders SHOULD therefore avoid encoding individual RDMA Read Chunks=
 for
>> roundup whenever possible."
>>=20
>> The Solaris NFS/RDMA server does not require this extra chunk, but L=
inux
>> appears to need it. When I enable pad optimization on the Linux clie=
nt,
>> it works fine with the Solaris server. But the first NFS WRITE with =
an
>> odd length against the Linux server causes connection loss and the c=
lient
>> workload hangs.
>>=20
>> At some point I'd like to permanently enable this optimization on th=
e
>> Linux client. You can try this out with:
>>=20
>> sudo echo 1 > /proc/sys/sunrpc/rdma_pad_optimize
>>=20
>> The default contents of this file leave pad optimization disabled, f=
or
>> compatibility with the current Linux NFS/RDMA server.
>>=20
>> So rdma_read_chunks() needs to handle the implicit XDR length round-=
up.
>> That's probably not hard.
>>=20
>> What I'm asking is:
>>=20
>> Do you agree the server should be changed to comply with section 4 o=
f 5667?
>>=20
>=20
> I think it is complying and you are misinterpreting.  But I could be =
misinterpreting it
> too :)
>=20
> But we should fix the pad thing.

That may be enough to support a client that does not send the
pad bytes in a separate chunk. However, I wonder how such a
server would behave with the current client.

True, this isn=92t a regression, per se. The server is already
behaving incorrectly without the refactoring patch.

However, Tom=92s refactoring rewrites all this logic anyway, and
it wouldn=92t be much of a stretch to make the server comply with
RFC 5667, at this point.

--
Chuck Lever
chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
