From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 19/19] sunrpc: Disable splice for krb5i
Date: Mon, 19 Jun 2017 08:30:18 -0700
Message-ID: <20170619153018.GA2667@infradead.org>
References: <20170616151535.14210.34926.stgit@klimt.1015granger.net>
 <20170616152254.14210.48071.stgit@klimt.1015granger.net>
 <20170617150705.GA27917@infradead.org>
 <A573E1EB-48DB-4E4A-B710-34914B0CF016@oracle.com>
 <20170618073438.GA15358@infradead.org>
 <14AD4311-5092-441C-8A3B-F7EC7E801358@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14AD4311-5092-441C-8A3B-F7EC7E801358-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 19, 2017 at 11:22:41AM -0400, Chuck Lever wrote:
> I'm going to submit this again with a comment change and
> Jeff's Reviewed-by. Can I add your Reviewed-by as well?

It looks ok as a quick fix for me but at least needs a big comment.
I'd also be much happier if we could find and fix the root cause.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
