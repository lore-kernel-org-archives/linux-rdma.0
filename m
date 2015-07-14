From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 10/12] xprtrdma: Fix large NFS SYMLINK calls
Date: Tue, 14 Jul 2015 15:09:52 -0400
Message-ID: <91D99EC6-3229-4CE6-B6E9-FAC3799C022D@oracle.com>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net> <20150709204315.26247.47851.stgit@manet.1015granger.net> <55A53259.8090606@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A53259.8090606-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <schumaker.anna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 14, 2015, at 12:01 PM, Anna Schumaker <schumaker.anna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:

> Hey Chuck,
>=20
> On 07/09/2015 04:43 PM, Chuck Lever wrote:
>> Repair how rpcrdma_marshal_req() chooses which RDMA message type
>> to use for large non-WRITE operations so that it picks RDMA_NOMSG
>> in the correct situations, and sets up the marshaling logic to
>> SEND only the RPC/RDMA header.
>>=20
>> Large NFSv2 SYMLINK requests now use RDMA_NOMSG calls. The Linux NFS
>> server XDR decoder for NFSv2 SYMLINK does not handle having the
>> pathname argument arrive in a separate buffer. The decoder could be
>> fixed, but this is simpler and RDMA_NOMSG can be used in a variety
>> of other situations.
>>=20
>> Ensure that the Linux client continues to use "RDMA_MSG + read
>> list" when sending large NFSv3 SYMLINK requests, which is more
>> efficient than using RDMA_NOMSG.
>>=20
>> Large NFSv4 CREATE(NF4LNK) requests are changed to use "RDMA_MSG +
>> read list" just like NFSv3 (see Section 5 of RFC 5667). Before,
>> these did not work at all.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> fs/nfs/nfs3xdr.c               |    1 +
>> fs/nfs/nfs4xdr.c               |    1 +
>> net/sunrpc/xprtrdma/rpc_rdma.c |   21 ++++++++++++---------
>> 3 files changed, 14 insertions(+), 9 deletions(-)
>=20
> It might be better to split this into separate patches for nfs and su=
nrpc, since Trond might want to accept the nfs changes separately.

Originally I had the fs/nfs/*xdr.c changes split into separate patches.
But I=92ve convinced myself that it is better to bundle the NFS changes
with the rpc_rdma.c changes here.

If the fs/nfs/*xdr.c changes come before the rpc_rdma.c changes, then
the XDRBUF_WRITE flag is being set in the NFS XDR encoders, but never
used anywhere. Which is safe, but somewhat nonsensical.

If the fs/nfs/*xdr.c changes come after the rpc_rdma.c changes, then
the client will send NFSv3 SYMLINK and NFSv4 CREATE(NF4LNK) differently
for a moment when just the rpc_rdma.c change is applied.

Together in a single commit, these are a single indivisible change that
stands up well to bisect, and is easy for distributions to cherry-pick.
It doesn=92t make sense to apply the NFS and RPC/RDMA changes separatel=
y.

So, it=92s up to you and Trond. I will change it if he prefers it broke=
n
out. I think the most benign way to split them is to merge the
fs/nfs/*xdr.c changes first, but let=92s hear from Trond.


> Anna
>=20
>>=20
>> diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
>> index 9b04c2e..267126d 100644
>> --- a/fs/nfs/nfs3xdr.c
>> +++ b/fs/nfs/nfs3xdr.c
>> @@ -1103,6 +1103,7 @@ static void nfs3_xdr_enc_symlink3args(struct r=
pc_rqst *req,
>> {
>> 	encode_diropargs3(xdr, args->fromfh, args->fromname, args->fromlen)=
;
>> 	encode_symlinkdata3(xdr, args);
>> +	xdr->buf->flags |=3D XDRBUF_WRITE;
>> }
>>=20
>> /*
>> diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
>> index 558cd65d..03a20ec 100644
>> --- a/fs/nfs/nfs4xdr.c
>> +++ b/fs/nfs/nfs4xdr.c
>> @@ -1155,6 +1155,7 @@ static void encode_create(struct xdr_stream *x=
dr, const struct nfs4_create_arg *
>> 		p =3D reserve_space(xdr, 4);
>> 		*p =3D cpu_to_be32(create->u.symlink.len);
>> 		xdr_write_pages(xdr, create->u.symlink.pages, 0, create->u.symlink=
=2Elen);
>> +		xdr->buf->flags |=3D XDRBUF_WRITE;
>> 		break;
>>=20
>> 	case NF4BLK: case NF4CHR:
>> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rp=
c_rdma.c
>> index 2e721f2..64fc4b4 100644
>> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
>> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
>> @@ -484,21 +484,24 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
>> 	 *
>> 	 * o If the total request is under the inline threshold, all ops
>> 	 *   are sent as inline.
>> -	 * o Large non-write ops are sent with the entire message as a
>> -	 *   single read chunk (protocol 0-position special case).
>> 	 * o Large write ops transmit data as read chunk(s), header as
>> 	 *   inline.
>> +	 * o Large non-write ops are sent with the entire message as a
>> +	 *   single read chunk (protocol 0-position special case).
>> 	 *
>> -	 * Note: the NFS code sending down multiple argument segments
>> -	 * implies the op is a write.
>> -	 * TBD check NFSv4 setacl
>> +	 * This assumes that the upper layer does not present a request
>> +	 * that both has a data payload, and whose non-data arguments
>> +	 * by themselves are larger than the inline threshold.
>> 	 */
>> -	if (rpcrdma_args_inline(rqst))
>> +	if (rpcrdma_args_inline(rqst)) {
>> 		rtype =3D rpcrdma_noch;
>> -	else if (rqst->rq_snd_buf.page_len =3D=3D 0)
>> -		rtype =3D rpcrdma_areadch;
>> -	else
>> +	} else if (rqst->rq_snd_buf.flags & XDRBUF_WRITE) {
>> 		rtype =3D rpcrdma_readch;
>> +	} else {
>> +		headerp->rm_type =3D htonl(RDMA_NOMSG);
>> +		rtype =3D rpcrdma_areadch;
>> +		rpclen =3D 0;
>> +	}
>>=20
>> 	/* The following simplification is not true forever */
>> 	if (rtype !=3D rpcrdma_noch && wtype =3D=3D rpcrdma_replych)
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs"=
 in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>=20

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
