From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/srp: use IB_PD_UNSAFE_GLOBAL_RKEY
Date: Tue, 30 Aug 2016 14:47:05 +0200
Message-ID: <20160830124705.GA7585@lst.de>
References: <1472464943-29450-1-git-send-email-hch@lst.de> <1472464943-29450-5-git-send-email-hch@lst.de> <df613e79-7c01-5fa6-5586-6f567254224b@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <df613e79-7c01-5fa6-5586-6f567254224b-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 29, 2016 at 10:00:33AM -0700, Bart Van Assche wrote:
> Was it really necessary to remove these two member variables? If the per-PD 
> global MR is ever removed all the code that uses pd->unsafe_global_rkey 
> will have to be touched again.

No, it won't.  I actually have a tree where it's gone, but as it so
far only supports mlx4 I didn't want to bother anyone with it.

> Keeping the two global_mr variables would 
> reduce the number of load instructions the CPU has to perform while mapping 
> SRP requests.

We can add pointers to the pd in the same places, that should give you
the same number of load instructions.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
