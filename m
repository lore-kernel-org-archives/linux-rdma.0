From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/7] svcrdma: Another sendto chunk list parsing update
Date: Tue, 7 Feb 2017 15:30:58 -0500
Message-ID: <C65F013C-84A2-456D-A0C0-04444D3C4D58@oracle.com>
References: <20170207165131.14422.47088.stgit@klimt.1015granger.net> <20170207165815.14422.77348.stgit@klimt.1015granger.net> <20170207194252.GA28088@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170207194252.GA28088-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 7, 2017, at 2:42 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
>> 	/* Prepare the SGE for the RPCRDMA Header */
>> 	ctxt->sge[0].lkey = rdma->sc_pd->local_dma_lkey;
>> -	ctxt->sge[0].length = svc_rdma_xdr_get_reply_hdr_len(rdma_resp);
>> +	ctxt->sge[0].length =
>> +	    svc_rdma_xdr_get_reply_hdr_len((__be32 *)rdma_resp);
> 
> That case is pretty ugly, but given that it'll go away soon it's
> probably fine for now.

Yes, the type cast will be replaced.


> Otherwise this look good:
> 
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Bruce, I assume you will pick up the extra Reviewed-by tags
if I don't have to send another version of this series.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
