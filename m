From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Tue, 29 Sep 2015 11:58:33 +0300
Message-ID: <560A52B9.50109@mellanox.com>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442157215-22341-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 13/09/2015 18:13, Christoph Hellwig wrote:
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
> 

Hi,

I've tested the current wr-cleanup branch with a Connect-IB device to
make sure the changes to the mlx5-internal UMR work requests are fine
(at least when invoked from user space). To test I also had to add
Sagi's patches to remove the reserved lkey, but with those patches it works.

Regards,
Haggai

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
