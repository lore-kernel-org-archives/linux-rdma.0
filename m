From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Wed, 31 Jan 2018 14:04:57 -0700
Message-ID: <20180131210457.GE23352@mellanox.com>
References: <20180131174735.GA18568@ziepe.ca>
 <CA+55aFxmnW-iu1Na3QC8Ci8Q_Qdfn2Ak_9wDB6+A564R=Xn9Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxmnW-iu1Na3QC8Ci8Q_Qdfn2Ak_9wDB6+A564R=Xn9Ag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 31, 2018 at 12:11:24PM -0800, Linus Torvalds wrote:
> On Wed, Jan 31, 2018 at 9:47 AM, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> >
> > Since the conflict with v4.15 involves some code motion and is not so
> > trivial, so I have included a merge to tag v4.15 as the top commit in
> > this PR that has the resolution reviewed by the patch authors and
> > tested in linux-next. The tag 'for-linus-unmerged' is available
> > without this merge if you desire.
> 
> Thanks, this was well done. A thoughtful merge with explanation for
> why the conflict happened and why back-merge was done, and taking a
> sane merge point (v4.15 rather than some random daily point).

Thanks Linus, it is good to know I've understood your past remarks
properly!

On the topic of back merges, can you give some guidance?

With some success, we've encouraged all the driver vendors to test -rc
kernels and test our RDMA for-next internally during the entire -rc
cycle. Most of the testers are taking RDMA for-next and merging it
with latest -rcX then testing the result.

Due to the conflict above our tree was left with complicated merge
conflicts for about 3-4 weeks, and some of the testers have had pain
due to this.

Would back merging -rcX ealier, with a similar but better merge
commit, be an acceptable practice?

I'm unsure since we'd be doing this to support testers/users and not
as a development requirement.

In this case we'd send you a PR with the back merge for conflict
resolution well down the commit list.

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
