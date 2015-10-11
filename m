From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Sun, 11 Oct 2015 06:13:44 -0700
Message-ID: <20151011131344.GA21657@infradead.org>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442157215-22341-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 13, 2015 at 05:13:33PM +0200, Christoph Hellwig wrote:
> This series shrinks the WR size by splitting out the different WR
> types.
> 
> Patch number one is too large for the mailinglist, so if you didn't
> get it grab it here:
> 
> 	http://git.infradead.org/users/hch/rdma.git/commitdiff_plain/c752d80937ff2d71f25ae7fcdd1a151054fb2ceb
> 
> or the full git tree at:
> 
> 	git://git.infradead.org/users/hch/rdma.git wr-cleanup

This git tree has been updated with the latests ACKs and has been
rebased to the latest rdma tree which introduced a few trivial rejects.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
