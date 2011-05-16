From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: don't declare wr_wait objects on the stack.
Date: Mon, 16 May 2011 10:56:45 -0500
Message-ID: <4DD1493D.3060401@opengridcomputing.com>
References: <20110513183727.32157.8873.stgit@build.ogc.int> <4DD14036.9050704@opengridcomputing.com> <BANLkTimGzzo1xDTvApAVxvv4C8WcYuCdUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimGzzo1xDTvApAVxvv4C8WcYuCdUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/16/2011 10:53 AM, Roland Dreier wrote:
> On Mon, May 16, 2011 at 8:18 AM, Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>  wrote:
>> Roland, I need to recall this patch.  It appears to have some problem.
> Good thing I didn't apply it yet.
>
> I did think it should be possible to declare wait objects on the stack... the
> origin of completions was to handle exactly that issue; the older semaphore
> structure was vulnerable to the wakeup after free, but completions handle
> that.  But I didn't look at the cxgb4 code at all...

I'm pretty sure the race exists as described in my commit comment.  And I don't see how the wait object code could avoid 
this issue.  Unless I'm just all wrong. :)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
