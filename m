From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH for kernel v4.6] IB/srpt: Revert "Convert to percpu_ida
 tag allocation"
Date: Thu, 31 Mar 2016 20:12:57 -0700
Message-ID: <56FDE739.9090801@sandisk.com>
References: <56FDBA63.7010804@sandisk.com> <20160401030322.GH2670@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160401030322.GH2670-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/31/16 20:05, Leon Romanovsky wrote:
> On Thu, Mar 31, 2016 at 05:01:39PM -0700, Bart Van Assche wrote:
>> That patch is wrong because it makes the ib_srpt driver use I/O
>> contexts allocated by transport_alloc_session_tags() but it does
>> not initialize these I/O contexts properly.
>
> Did you have a chance to see which initializations are missing in this
> case? What is needed to do if we decide to fix original patch?
>
> Except these questions, the revert is fine :)
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hello Leon,

Thanks for the review. The initializations that are missing from that 
patch are the 'buf' pointer in the srpt_ioctx structure and mapping that 
buffer for DMA. Another bug introduced by that patch is that it doubles 
the amount of memory that is allocated for I/O contexts. New I/O context 
allocations were added by that patch but the existing I/O context 
allocation code was not removed.

Regarding reconsidering the original patch: before we do that it has to 
be shown with numbers that the percpu_ida conversion does not decrease 
performance. This is something I had already asked two months ago. See 
also 
http://thread.gmane.org/gmane.linux.scsi.target.devel/11253/focus=110559.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
