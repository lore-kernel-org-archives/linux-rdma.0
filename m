From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 11/18] xprtrdma: Save I/O direction in struct rpcrdma_frwr
Date: Tue, 26 Apr 2016 16:14:06 -0400
Message-ID: <DDD1E1BA-B4FA-407A-BE02-A07F6391BC76@oracle.com>
References: <20160425185956.3566.64142.stgit@manet.1015granger.net> <20160425192218.3566.13233.stgit@manet.1015granger.net> <571FCBBD.9070200@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571FCBBD.9070200-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Apr 26, 2016, at 4:12 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> 
>> Move the the I/O direction field from rpcrdma_mr_seg into the
>> rpcrdma_frmr. This makes it possible to perform the DMA unmapping
>> long after the rpcrdma_mr_seg has been released and re-used.
> 
> A little explanation on why this is desired/useful would help understand
> this patch.

Can do.

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
