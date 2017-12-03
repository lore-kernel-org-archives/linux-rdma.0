From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1] xprtrdma: Spread reply processing over more CPUs
Date: Sun, 3 Dec 2017 11:28:44 -0800
Message-ID: <20171203192844.GB311@infradead.org>
References: <20171202212840.11321.83261.stgit@manet.1015granger.net>
 <20171203183523.GA29539@infradead.org>
 <52245049-E101-4148-8A35-10368379FF20@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52245049-E101-4148-8A35-10368379FF20-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 03, 2017 at 01:52:28PM -0500, Chuck Lever wrote:
> 
> > On Dec 3, 2017, at 1:35 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > 
> > Hmm.  I'd love to find a way to handle this in the core code, but until
> > that is done you should probably move sc_rq_cq to execture in softirq
> > code.
> 
> You mean revert a4699f5647f3 as well? I tried that in combination
> with this change, and it did not result in any difference in
> throughput results.

Ok.  I guess we can leave things as-is for now then.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
