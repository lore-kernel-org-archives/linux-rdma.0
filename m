From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libmlx5] fix err return values to match ibv_post_send
 expectations
Date: Sat, 6 Aug 2016 14:48:23 -0400
Message-ID: <20160806184823.GT6329@redhat.com>
References: <1470418439-59245-1-git-send-email-jarod@redhat.com>
 <20160805180107.GA31674@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160805180107.GA31674-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 05, 2016 at 12:01:07PM -0600, Jason Gunthorpe wrote:
> On Fri, Aug 05, 2016 at 01:33:59PM -0400, Jarod Wilson wrote:
> > -	return _mlx5_post_send(ibqp, wr, bad_wr);
> > +	errno = _mlx5_post_send(ibqp, wr, bad_wr);
> > +	return errno;
> 
> Why still set errno? It was wrong in the first place..
> 
> Likely every use of errno in this provider should be reviewed.

Wasn't sure if something else might actually consume errno elsewhere,
since it's a global, and the other code path in that function set errno.
Could certainly just stick with returning the _mlx5_post_send() result
directly.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
