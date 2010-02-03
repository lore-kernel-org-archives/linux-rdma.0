From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: mlx4 kernel parameters
Date: Wed, 3 Feb 2010 16:54:29 +0200
Message-ID: <20100203145429.GD30979@mtls03>
References: <6978b4af1002030202h431384c4ub6de0313e51c4500@mail.gmail.com>
 <20100203124200.GA30979@mtls03>
 <6978b4af1002030617v4b55787ei4e66f72de662528a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6978b4af1002030617v4b55787ei4e66f72de662528a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 03, 2010 at 03:17:17PM +0100, Rui Machado wrote:
> 
> Great, thanks. I increased the log_mtts_per_seg to 5 and was able to
> register more memory. But one question remaining: what is then the
> maximum memory that one is able to register? 5 is the maximum value to
> this parameter, so what does it mean?
> 
The overall size of memory that can be registered, from the HCA's
perspective, depends on the number of MTT segments, the number of
MTTs in each segment and PAGE_SIZE. The number of MTT segments however
is limited by the MTT allocator's ability to allocate memory for
managing allocations. Roughly, this is 128K * 8 MTT segments.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
