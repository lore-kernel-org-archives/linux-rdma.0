From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH v3 0/3] new ib_drain_qp() API
Date: Sat, 13 Feb 2016 18:10:49 +0200
Message-ID: <20160213161049.GB14741@leon.nu>
References: <cover.1455230646.git.swise@chelsio.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1455230646.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 11, 2016 at 02:44:06PM -0800, Steve Wise wrote:
> This series creates new helper API functions for draining a queue pair.
> It is a rework of an original patch created by Christoph Hellwig as
> part of the CQ API rework and was dropped to be resubmitted by me with
> iw_cxgb4 support.
> 
> Original thread: http://www.spinics.net/lists/linux-rdma/msg30296.html

Hi Steve,
For future submission, can you please use versioning on all patches
submitted in the series and not only in cover letter?

In such way, internal filtering of new emails will be more informative.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
