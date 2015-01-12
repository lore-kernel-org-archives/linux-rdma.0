From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 06/10] svcrdma: Plant reader function in struct svcxprt_rdma
Date: Mon, 12 Jan 2015 11:20:11 -0500
Message-ID: <A84D07C5-1879-49ED-A181-6FFC76B4864B@oracle.com>
References: <20150109191910.4901.29548.stgit@klimt.1015granger.net> <20150109192245.4901.89614.stgit@klimt.1015granger.net> <54B2B69E.2010503@dev.mellanox.co.il> <6A78707C-A371-412F-8E9A-24937318A01D@oracle.com> <002201d02e82$08d16070$1a742150$@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <002201d02e82$08d16070$1a742150$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jan 12, 2015, at 11:08 AM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> =
wrote:

>=20
>=20
>> -----Original Message-----
>> From: Chuck Lever [mailto:chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
>> Sent: Sunday, January 11, 2015 6:41 PM
>> To: Sagi Grimberg; Steve Wise
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linux NFS Mailing List
>> Subject: Re: [PATCH v1 06/10] svcrdma: Plant reader function in stru=
ct svcxprt_rdma
>>=20
>>=20
>> On Jan 11, 2015, at 12:45 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifUpdFzICT1y@public.gmane.org=
l> wrote:
>>=20
>>> On 1/9/2015 9:22 PM, Chuck Lever wrote:
>>>> The RDMA reader function doesn't change once an svcxprt is
>>>> instantiated. Instead of checking sc_devcap during every incoming
>>>> RPC, set the reader function once when the connection is accepted.
>>>=20
>>> General question(s),
>>>=20
>>> Any specific reason why to use FRMR in the server side? And why onl=
y
>>> for reads and not writes? Sorry if these are dumb questions...
>>=20
>> Steve Wise presented patches a few months back to add FRMR, he
>> would have to answer this. Steve has a selection of iWARP adapters
>> and maybe could provide some idea of performance impact. I have
>> only CX-[23] here.
>>=20
>=20
> The rdma rpc server has always tried to use FRMR for rdma reads as fa=
r as I recall.  The patch I submitted refactored the design in
> order to make it more efficient and to fix some bugs.   Unlike IB, th=
e iWARP  protocol only allows 1 target/sink SGE in an rdma read
> request message, so an FRMR is used to create that single target/sink=
 SGE allowing 1 read to be submitted instead of many.

How does this work when the client uses PHYSICAL memory registration?
It can=92t form a read/write list SGE larger than a page, thus the
server must emit an RDMA READ or WRITE for each page in the payload.

Curious, have you tried using iWARP with PHYSICAL MR on the client?

> I
> believe that the FRMR allows for more efficient IO since w/o it you e=
nd up with large SGLs of 4K each and lots of read requests.
> However, I have no data to back that up.  I would think that the writ=
e side (NFS READ) could also benefit from FRMRs too.  It also
> could use refactoring, because I believe it still creates an intermed=
iate data structure to hold the write chunks vs just
> translating them directly into the RDMA SGLs needed for the IO.  See =
send_write_chunks() and send_write() and how they create a
> svc_rdma_req_map vector first and then translate that into the SGL ne=
eded for the rdma writes.
>=20
>=20
>> My next step is to do some performance measurement to see if FRMR
>> is worth the trouble, at least with the cards on hand.
>>=20
>> I notice that the lcl case does not seem to work with my CX-3 Pro.
>> Probably a bug I will have to address first.
>>=20
>=20
>>=20
>>> Sagi.
>>>=20
>>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>=20
>>>> include/linux/sunrpc/svc_rdma.h          |   10 ++++
>>>> net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |   71 +++++++++++-------=
------------
>>>> net/sunrpc/xprtrdma/svc_rdma_transport.c |    2 +
>>>> 3 files changed, 39 insertions(+), 44 deletions(-)
>>>>=20
>>>> diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrp=
c/svc_rdma.h
>>>> index 2280325..f161e30 100644
>>>> --- a/include/linux/sunrpc/svc_rdma.h
>>>> +++ b/include/linux/sunrpc/svc_rdma.h
>>>> @@ -150,6 +150,10 @@ struct svcxprt_rdma {
>>>> 	struct ib_cq         *sc_rq_cq;
>>>> 	struct ib_cq         *sc_sq_cq;
>>>> 	struct ib_mr         *sc_phys_mr;	/* MR for server memory */
>>>> +	int		     (*sc_reader)(struct svcxprt_rdma *,
>>>> +					  struct svc_rqst *,
>>>> +					  struct svc_rdma_op_ctxt *,
>>>> +					  int *, u32 *, u32, u32, u64, bool);
>>>> 	u32		     sc_dev_caps;	/* distilled device caps */
>>>> 	u32		     sc_dma_lkey;	/* local dma key */
>>>> 	unsigned int	     sc_frmr_pg_list_len;
>>>> @@ -195,6 +199,12 @@ extern int svc_rdma_xdr_get_reply_hdr_len(str=
uct rpcrdma_msg *);
>>>>=20
>>>> /* svc_rdma_recvfrom.c */
>>>> extern int svc_rdma_recvfrom(struct svc_rqst *);
>>>> +extern int rdma_read_chunk_lcl(struct svcxprt_rdma *, struct svc_=
rqst *,
>>>> +			       struct svc_rdma_op_ctxt *, int *, u32 *,
>>>> +			       u32, u32, u64, bool);
>>>> +extern int rdma_read_chunk_frmr(struct svcxprt_rdma *, struct svc=
_rqst *,
>>>> +				struct svc_rdma_op_ctxt *, int *, u32 *,
>>>> +				u32, u32, u64, bool);
>>>>=20
>>>> /* svc_rdma_sendto.c */
>>>> extern int svc_rdma_sendto(struct svc_rqst *);
>>>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/=
xprtrdma/svc_rdma_recvfrom.c
>>>> index 577f865..c3aebc1 100644
>>>> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>>>> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>>>> @@ -117,26 +117,16 @@ static int rdma_read_max_sge(struct svcxprt_=
rdma *xprt, int sge_count)
>>>> 		return min_t(int, sge_count, xprt->sc_max_sge);
>>>> }
>>>>=20
>>>> -typedef int (*rdma_reader_fn)(struct svcxprt_rdma *xprt,
>>>> -			      struct svc_rqst *rqstp,
>>>> -			      struct svc_rdma_op_ctxt *head,
>>>> -			      int *page_no,
>>>> -			      u32 *page_offset,
>>>> -			      u32 rs_handle,
>>>> -			      u32 rs_length,
>>>> -			      u64 rs_offset,
>>>> -			      int last);
>>>> -
>>>> /* Issue an RDMA_READ using the local lkey to map the data sink */
>>>> -static int rdma_read_chunk_lcl(struct svcxprt_rdma *xprt,
>>>> -			       struct svc_rqst *rqstp,
>>>> -			       struct svc_rdma_op_ctxt *head,
>>>> -			       int *page_no,
>>>> -			       u32 *page_offset,
>>>> -			       u32 rs_handle,
>>>> -			       u32 rs_length,
>>>> -			       u64 rs_offset,
>>>> -			       int last)
>>>> +int rdma_read_chunk_lcl(struct svcxprt_rdma *xprt,
>>>> +			struct svc_rqst *rqstp,
>>>> +			struct svc_rdma_op_ctxt *head,
>>>> +			int *page_no,
>>>> +			u32 *page_offset,
>>>> +			u32 rs_handle,
>>>> +			u32 rs_length,
>>>> +			u64 rs_offset,
>>>> +			bool last)
>>>> {
>>>> 	struct ib_send_wr read_wr;
>>>> 	int pages_needed =3D PAGE_ALIGN(*page_offset + rs_length) >> PAGE=
_SHIFT;
>>>> @@ -221,15 +211,15 @@ static int rdma_read_chunk_lcl(struct svcxpr=
t_rdma *xprt,
>>>> }
>>>>=20
>>>> /* Issue an RDMA_READ using an FRMR to map the data sink */
>>>> -static int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
>>>> -				struct svc_rqst *rqstp,
>>>> -				struct svc_rdma_op_ctxt *head,
>>>> -				int *page_no,
>>>> -				u32 *page_offset,
>>>> -				u32 rs_handle,
>>>> -				u32 rs_length,
>>>> -				u64 rs_offset,
>>>> -				int last)
>>>> +int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
>>>> +			 struct svc_rqst *rqstp,
>>>> +			 struct svc_rdma_op_ctxt *head,
>>>> +			 int *page_no,
>>>> +			 u32 *page_offset,
>>>> +			 u32 rs_handle,
>>>> +			 u32 rs_length,
>>>> +			 u64 rs_offset,
>>>> +			 bool last)
>>>> {
>>>> 	struct ib_send_wr read_wr;
>>>> 	struct ib_send_wr inv_wr;
>>>> @@ -374,9 +364,9 @@ static int rdma_read_chunks(struct svcxprt_rdm=
a *xprt,
>>>> {
>>>> 	int page_no, ret;
>>>> 	struct rpcrdma_read_chunk *ch;
>>>> -	u32 page_offset, byte_count;
>>>> +	u32 handle, page_offset, byte_count;
>>>> 	u64 rs_offset;
>>>> -	rdma_reader_fn reader;
>>>> +	bool last;
>>>>=20
>>>> 	/* If no read list is present, return 0 */
>>>> 	ch =3D svc_rdma_get_read_chunk(rmsgp);
>>>> @@ -399,27 +389,20 @@ static int rdma_read_chunks(struct svcxprt_r=
dma *xprt,
>>>> 	head->arg.len =3D rqstp->rq_arg.len;
>>>> 	head->arg.buflen =3D rqstp->rq_arg.buflen;
>>>>=20
>>>> -	/* Use FRMR if supported */
>>>> -	if (xprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG)
>>>> -		reader =3D rdma_read_chunk_frmr;
>>>> -	else
>>>> -		reader =3D rdma_read_chunk_lcl;
>>>> -
>>>> 	page_no =3D 0; page_offset =3D 0;
>>>> 	for (ch =3D (struct rpcrdma_read_chunk *)&rmsgp->rm_body.rm_chunk=
s[0];
>>>> 	     ch->rc_discrim !=3D 0; ch++) {
>>>> -
>>>> +		handle =3D be32_to_cpu(ch->rc_target.rs_handle);
>>>> +		byte_count =3D be32_to_cpu(ch->rc_target.rs_length);
>>>> 		xdr_decode_hyper((__be32 *)&ch->rc_target.rs_offset,
>>>> 				 &rs_offset);
>>>> -		byte_count =3D ntohl(ch->rc_target.rs_length);
>>>>=20
>>>> 		while (byte_count > 0) {
>>>> -			ret =3D reader(xprt, rqstp, head,
>>>> -				     &page_no, &page_offset,
>>>> -				     ntohl(ch->rc_target.rs_handle),
>>>> -				     byte_count, rs_offset,
>>>> -				     ((ch+1)->rc_discrim =3D=3D 0) /* last */
>>>> -				     );
>>>> +			last =3D (ch + 1)->rc_discrim =3D=3D xdr_zero;
>>>> +			ret =3D xprt->sc_reader(xprt, rqstp, head,
>>>> +					      &page_no, &page_offset,
>>>> +					      handle, byte_count,
>>>> +					      rs_offset, last);
>>>> 			if (ret < 0)
>>>> 				goto err;
>>>> 			byte_count -=3D ret;
>>>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc=
/xprtrdma/svc_rdma_transport.c
>>>> index f2e059b..f609c1c 100644
>>>> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
>>>> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
>>>> @@ -974,10 +974,12 @@ static struct svc_xprt *svc_rdma_accept(stru=
ct svc_xprt *xprt)
>>>> 	 * NB:	iWARP requires remote write access for the data sink
>>>> 	 *	of an RDMA_READ. IB does not.
>>>> 	 */
>>>> +	newxprt->sc_reader =3D rdma_read_chunk_lcl;
>>>> 	if (devattr.device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
>>>> 		newxprt->sc_frmr_pg_list_len =3D
>>>> 			devattr.max_fast_reg_page_list_len;
>>>> 		newxprt->sc_dev_caps |=3D SVCRDMA_DEVCAP_FAST_REG;
>>>> +		newxprt->sc_reader =3D rdma_read_chunk_frmr;
>>>> 	}
>>>>=20
>>>> 	/*
>>>>=20
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>=20
>>>=20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-nfs=
" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>> --
>> Chuck Lever
>> chuck[dot]lever[at]oracle[dot]com
>>=20
>=20
>=20

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
