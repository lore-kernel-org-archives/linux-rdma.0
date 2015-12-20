From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 10/10] IB: remove the unused usecnt field from struct
	ib_mr
Date: Sun, 20 Dec 2015 16:42:50 +0100
Message-ID: <20151220154250.GB10351@lst.de>
References: <1450446906-10336-1-git-send-email-hch@lst.de> <1450446906-10336-11-git-send-email-hch@lst.de> <567414B0.2050406@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <567414B0.2050406-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 18, 2015 at 03:14:08PM +0100, Bart Van Assche wrote:
> On 12/18/2015 02:55 PM, Christoph Hellwig wrote:
>> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>
> Shouldn't the description of this patch be changed into something like 
> "Remove the usecnt field from ib_mr since it is always zero" ?

In software context unused for my also includes something that's
only written to.  But I can change it to something like:

IB: remove the write only usecnt field from struct ib_mr

to be a little more precise.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
