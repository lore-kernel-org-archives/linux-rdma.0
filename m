From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Wed, 31 Jan 2018 12:11:24 -0800
Message-ID: <CA+55aFxmnW-iu1Na3QC8Ci8Q_Qdfn2Ak_9wDB6+A564R=Xn9Ag@mail.gmail.com>
References: <20180131174735.GA18568@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180131174735.GA18568-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 31, 2018 at 9:47 AM, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
> Since the conflict with v4.15 involves some code motion and is not so
> trivial, so I have included a merge to tag v4.15 as the top commit in
> this PR that has the resolution reviewed by the patch authors and
> tested in linux-next. The tag 'for-linus-unmerged' is available
> without this merge if you desire.

Thanks, this was well done. A thoughtful merge with explanation for
why the conflict happened and why back-merge was done, and taking a
sane merge point (v4.15 rather than some random daily point).

Maybe the back-merge commit itself could have had a slightly more
complete merge message (the kind you had in the pull request here),
but that's a small nit.

So I thought I'd send out a "good job" email just as a contrast to me
having to sometimes complain about back-merges.

               Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
