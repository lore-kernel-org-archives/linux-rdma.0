From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v1 02/14] svcrdma: Add svc_rdma_map_reply_hdr()
Date: Wed, 22 Mar 2017 15:07:07 +0200
Message-ID: <c70544b7-1dfd-65fb-c18f-823085084c20@grimberg.me>
References: <20170316154132.4482.56769.stgit@klimt.1015granger.net>
 <20170316155242.4482.64809.stgit@klimt.1015granger.net>
 <f5000e25-6ca1-fc24-35c0-6089cf50923c@grimberg.me>
 <A18F9D5E-09BA-4268-9AA6-3E5866101F76@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A18F9D5E-09BA-4268-9AA6-3E5866101F76-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> I can't think of any. The only time this code changes is
> when overhauls like this happens.
>
> I don't mind putting the out_unmap label back.

Your call...

>> btw, I'm assuming svc_rdma_unmap_dma() is the opposite of
>> svc_rdma_map_reply_hdr() ?
>
> svc_rdma_map_reply_hdr() DMA-maps the transport header buffer.
>
> svc_rdma_unmap_dma() DMA-unmaps everything associated with
> the ctxt.

a bit non trivial, but ok I guess...
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
