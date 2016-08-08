From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libmlx5] fix err return values to match ibv_post_send
 expectations
Date: Mon, 8 Aug 2016 11:33:33 -0600
Message-ID: <20160808173333.GA26622@obsidianresearch.com>
References: <1470418439-59245-1-git-send-email-jarod@redhat.com>
 <20160805180107.GA31674@obsidianresearch.com>
 <20160806184823.GT6329@redhat.com>
 <20160808163018.GA1819@obsidianresearch.com>
 <20160808165213.GA64520@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160808165213.GA64520-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 08, 2016 at 12:52:13PM -0400, Jarod Wilson wrote:
> > If the man page doesn't document the function destroying errno, then
> > it should preserve it. Do not just randomly set errno.
> 
> $ man ibv_post_send
> ...
> RETURN VALUE
>        ibv_post_send() returns 0 on success, or the value of errno on
>        failure (which indicates the failure reason).
> ...
> 
> This is a little bit terse, but looks to me like it means to say do set
> errno in ibv_post_send. I really am not terribly familiar with this
> code

Yes, our man pages are a little baroque.

The phrase 'returns the value of errno' means it returns a E* value,
not errno itself and leaves errno alone.

Using the phrase 'it returns an error number' would be clearer and
more consistent with glibc documentation.

> patch if consensus is that errno shouldn't be touched. Looks like
> mlx5_post_send() will need some additional work as well if that's the case
> though.

Most likely.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
