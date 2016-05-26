From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Thu, 26 May 2016 11:07:23 -0600
Message-ID: <20160526170723.GB27115@obsidianresearch.com>
References: <1464181344-11987-1-git-send-email-yishaih@mellanox.com>
 <1464181344-11987-3-git-send-email-yishaih@mellanox.com>
 <20160525172624.GA4602@obsidianresearch.com>
 <153e0a54-2ca6-f05a-d36a-05e736a348d7@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <153e0a54-2ca6-f05a-d36a-05e736a348d7-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 26, 2016 at 06:00:09PM +0300, Matan Barak wrote:

> >This ensures if we add new function pointers to the end then they are
> >null'd even if libibverbs is older, which is a little safer than
> >overflowing memory.
> 
> In order to use read_xxxx function, a user should allocate a suitable CQ
> (with the correct flag). If a support for a flag is needed in libibverbs, it
> should be checked in the create function.

The purpose is to make the API safer by ensuring null's are present in
unsupported function pointers in case the user accidently calls
them. Of course the user shouldn't call them.

> >The driver should also null fields accessor function pointers that it
> >cannot return.
> 
> We could have checked when creating a QP if the to-be attached CQ doesn't
> support querying invalid attributes in respect of this QP (i.e SLID in RC),
> but doing that you won't be able to attach the same CQ to several QP types
> and get various QP-type specific attributes, as you can today. Thus, we
> prefer the current approach.

Hum, this is an interesting point.

My inclination is to prefer safety over generality, a CQ should not be
bound to a QP that cannot provide all the attributes the CQ is setup
for.

Requiring an app to have a few CQs of different types does not seem
like a significant burden, and directly prevents stupid mistakes on
the part of the user.

> The fields that the user requested are guaranteed to be correct only when
> querying a completion originated by a supporting QP - exactly like today. We
> of course nullify function pointers the user didn't request.

I've always thought that was confusing and hard to use, to be
honest...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
