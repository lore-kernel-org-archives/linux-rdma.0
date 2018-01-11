From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: Please update the linux-next location for the RDMA subsystem
Date: Fri, 12 Jan 2018 07:16:21 +1100
Message-ID: <20180112071607.4dcfce82@canb.auug.org.au>
References: <1510948060.3973.29.camel@redhat.com>
        <20171119145633.07a3a715@canb.auug.org.au>
        <20180105180548.GD11972@mellanox.com>
        <20180107020124.37a7eff1@canb.auug.org.au>
        <1515617614.3403.163.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515617614.3403.163.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

On Wed, 10 Jan 2018 15:53:34 -0500 Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Jason and I would like you to make another change if you could.  Well,
> two actually.  First, we've found that now that we are both pushing to
> the same tree, the use of a tag instead of a branch for your for-next
> testing is dangerous.  In particular, kernel git repos have a fast-
> forward requirement on all branches, so an attempted push to a branch
> that has stale data from the pusher (say I just managed to push to the
> branch a few minutes before Jason and Jason hasn't pulled my changes
> into his branch before he decides to push his) is denied by the post
> hooks.  But no such check is in place for tags, and indeed we are
> allowed to wipe out tags at will.  This has already been an accident
> once, and there is no sense letting it be one again, so we've changed
> our workflows to compensate for this fact, and with that change, the
> for-next tag will no longer be kept up to date, it will only be pushed
> when we are sending a pull request, and that's too late for testing. 
> From now on, the for-next branch is the canonical source going forward
> for testing purposes prior to a pull request.
> 
> The second thing is we would like you to also add our for-rc branch. 
> Most of the time this will be a no-op, but we think there is some value
> in making sure that -rc patches aren't going to cause future merge
> problems with the for-next branch.  
> 
> Let me know if we can do those two things.  Thanks!

Both done.  The new branch in linux-next is called rdma-fixes.
-- 
Cheers,
Stephen Rothwell
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
