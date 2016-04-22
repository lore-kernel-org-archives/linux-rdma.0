From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 11/12] IB/core: add RW API support for signature MRs
Date: Fri, 22 Apr 2016 14:53:32 -0700
Message-ID: <571A9D5C.6070508@sandisk.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-12-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460410360-13104-12-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/11/2016 02:32 PM, Christoph Hellwig wrote:
> +			pr_err("%s: failed to allocated %d MRs\n",
> +				__func__, nr_mrs);

The above probably should read "failed to allocate" instead of "failed 
to allocated"?

> +			pr_err("%s: failed to allocated %d SIG MRs\n",
> +				__func__, nr_mrs);

Same comment here.

If you have to repost this patch, please remove the trailing whitespace 
introduced by this patch.

Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
