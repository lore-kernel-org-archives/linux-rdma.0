From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: ehca driver status?
Date: Wed, 26 Aug 2015 16:34:24 +0200
Message-ID: <20150826163424.531d7d4f@worktp>
References: <20150826134648.GA21814@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150826134648.GA21814-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 26 Aug 2015 06:46:48 -0700
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> Hi Hoang-Nam, hi Christoph, hi Alexander,
> 
> do you know what the current state of the eHCA driver and hardware is?
> 
> The driver hasn't seen any targeted updats since 2010, so we wonder if
> it's still alive?  It's one of the few drivers not supporting FRWRs,
> and it's also really odd in that it has its own dma_map_ops
> implementation that seems to pass virtual addresses to the hardware
> (or probably rather firmware), getting in the way of at least two
> currently pending cleanups.
> 

Hi Christoph,

I'll try to find out if we still need the device driver in the
kernel tree. It will take 2-3 weeks because the key people are on
vacation right now, but I'll get back to you.

Regards,
Alex

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
