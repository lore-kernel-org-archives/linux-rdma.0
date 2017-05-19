From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH V3 for-next 15/15] RDMA/bnxt_re: Remove FMR support
Date: Thu, 18 May 2017 23:26:58 -0700
Message-ID: <20170519062658.GA8235@infradead.org>
References: <1495169074-12641-1-git-send-email-selvin.xavier@broadcom.com>
 <1495169074-12641-16-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1495169074-12641-16-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 18, 2017 at 09:44:34PM -0700, Selvin Xavier wrote:
> Some issues observed with FMR implementation
> while running stress traffic. So removing the
> FMR verbs support for now.

Thanks!  And place don't bring it back ever, we shouldn't add FMR
support to new drivers..

Acked-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
