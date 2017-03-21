From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 02/14] svcrdma: Add svc_rdma_map_reply_hdr()
Date: Tue, 21 Mar 2017 14:40:16 -0400
Message-ID: <A18F9D5E-09BA-4268-9AA6-3E5866101F76@oracle.com>
References: <20170316154132.4482.56769.stgit@klimt.1015granger.net> <20170316155242.4482.64809.stgit@klimt.1015granger.net> <f5000e25-6ca1-fc24-35c0-6089cf50923c@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f5000e25-6ca1-fc24-35c0-6089cf50923c-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Mar 21, 2017, at 1:54 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> 
>> 	svc_rdma_build_send_wr(ctxt, 1);
>> 	ret = svc_rdma_send(rdma, &ctxt->send_wr);
>> 	if (ret) {
>> +		svc_rdma_unmap_dma(ctxt);
>> +		svc_rdma_put_context(ctxt, 1);
>> 		ret = -EIO;
>> -		goto out_unmap;
>> 	}
> 
> Any specific reason to not go with the goto scheme?

Only one "goto out_unmap" call site is left, and this
isn't a performance critical path.


> Can't this function grow more error paths in the future?

I can't think of any. The only time this code changes is
when overhauls like this happens.

I don't mind putting the out_unmap label back.


> btw, I'm assuming svc_rdma_unmap_dma() is the opposite of
> svc_rdma_map_reply_hdr() ?

svc_rdma_map_reply_hdr() DMA-maps the transport header buffer.

svc_rdma_unmap_dma() DMA-unmaps everything associated with
the ctxt.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
