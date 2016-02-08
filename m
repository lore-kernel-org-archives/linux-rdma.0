From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/9] svcrdma: Do not send XDR roundup bytes for a write chunk
Date: Mon, 8 Feb 2016 15:03:10 -0500
Message-ID: <6143AD37-7AB5-4B29-8740-D70454237EB9@oracle.com>
References: <20160208171756.13423.14384.stgit@klimt.1015granger.net> <20160208172430.13423.18896.stgit@klimt.1015granger.net> <20160208192119.GF17411@fieldses.org>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160208192119.GF17411-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 8, 2016, at 2:21 PM, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org wrote:
> 
> On Mon, Feb 08, 2016 at 12:24:31PM -0500, Chuck Lever wrote:
>> When the Linux server writes an odd-length data item into a Write
>> chunk, it finishes with XDR pad bytes. If the data item is smaller
>> than the Write chunk, the pad bytes are written at the end of the
>> data item, but still inside the chunk. That can expose these zero
>> bytes to the RPC consumer on the client.
>> 
>> XDR pad bytes are inserted in order to preserve the XDR alignment
>> of the next XDR data item in an XDR stream. But Write chunks do not
>> appear in the payload XDR stream, and only one data item is allowed
>> in each chunk. So XDR padding is unneeded.
>> 
>> Thus the server should not write XDR pad bytes in Write chunks.
>> 
>> I believe this is not an operational problem. Short NFS READs that
>> are returned in a Write chunk would be affected by this issue. But
>> they happen only when the read request goes past the EOF. Those are
>> zero bytes anyway, and there's no file data in the client's buffer
>> past EOF.
>> 
>> Otherwise, current NFS clients provide a separate extra segment for
>> catching XDR padding. If an odd-size data item fills the chunk,
>> then the XDR pad will be written to the extra segment.
>> 
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Reviewed-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> Tested-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> ---
>> net/sunrpc/xprtrdma/svc_rdma_sendto.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
>> index df57f3c..8591314 100644
>> --- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
>> @@ -308,7 +308,7 @@ static int send_write_chunks(struct svcxprt_rdma *xprt,
>> 			     struct svc_rqst *rqstp,
>> 			     struct svc_rdma_req_map *vec)
>> {
>> -	u32 xfer_len = rqstp->rq_res.page_len + rqstp->rq_res.tail[0].iov_len;
>> +	u32 xfer_len = rqstp->rq_res.page_len;
> 
> Is this just unconditionally dropping the tail of the xdr_buf?
> 
> The tail isn't necessarily only padding.  For example, I believe that
> the results of the GETATTR in a compound like:
> 
> 	PUTFH
> 	READ
> 	GETATTR
> 
> will also go in the tail.

nfsd4_encode_splice_read() does indeed put the remaining
compound operations in xdr_buf.tail, as it should.

However, the RDMA transport must not send these remaining
results as part of a write chunk. It has to send them
either inline or in a reply chunk, following the contents
of xdr_buf.head.

If the server is putting trailing compound operations in
Write chunks, that's wrong. I haven't seen any problems
that could be attributed to this in my testing, but
maybe clients just put up with it without complaint.


> (But maybe you're sending the rest of the tail somewhere else, I'm not
> very familiar with the RDMA code....)

We may have a little problem if a Write chunk has a pad
_and_ there are subsequent results. Putting the pad in
the tail moves those results to the wrong XDR alignment
in the reply.

So I think this hunk is correct, but I will need to verify
that the logic in svc_rdma_sendto.c does the right thing
with the xdr_buf's tail.

Thanks for the review.


> --b.
> 
>> 	int write_len;
>> 	u32 xdr_off;
>> 	int chunk_off;

--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
