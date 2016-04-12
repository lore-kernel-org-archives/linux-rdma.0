From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 05/18] xprtrdma: Avoid using Write list for small NFS
 READ requests
Date: Tue, 12 Apr 2016 07:15:33 -0700
Message-ID: <20160412141533.GA16218@infradead.org>
References: <20160411200323.20531.8893.stgit@manet.1015granger.net>
 <20160411201050.20531.53651.stgit@manet.1015granger.net>
 <033901d19431$b3725d20$1a571760$@opengridcomputing.com>
 <65CBC59F-3005-44FE-8C70-9DDBC8507C9E@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <65CBC59F-3005-44FE-8C70-9DDBC8507C9E-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 11, 2016 at 04:38:44PM -0400, Chuck Lever wrote:
> No, pre-4.2 Linux servers have a bug that can be fixed by
> applying the above commit, which shouldn't be difficult to
> backport.
> 
> Clients have always been allowed to send NFS READ this way.

But the clients might be out in a the wild.  I think we'll need at
least a mount option to work around them.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
