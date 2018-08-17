From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Fri, 17 Aug 2018 15:27:22 -0600
Message-ID: <20180817212722.GB28777@ziepe.ca>
References: <20180816215726.GA20526@ziepe.ca>
 <CA+55aFxgT8Hipm6bDrHMZ-nmdk3KZTP=J6D5k10UHTcajXAEHA@mail.gmail.com>
 <20180817201535.GI28676@mellanox.com>
 <CA+55aFzcp=a2sNOVR7DTEY9dehYamXaJ1bpSfF0FZir_9MhsVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFzcp=a2sNOVR7DTEY9dehYamXaJ1bpSfF0FZir_9MhsVg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 17, 2018 at 01:27:02PM -0700, Linus Torvalds wrote:
> On Fri, Aug 17, 2018 at 1:15 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
> >
> > We often have merge conflicts with RDMA, how do you prefer to get the
> > PR? I'm actually not very clear on this part of the process.
> 
> I  generally prefer the non-merged version, but with comments about
> the conflicts.
> 
> In fact, the really preferred model is generally to send me a
> non-merged pull request (say "tags/for-linus") but if the conflicts
> look even half-way nasty - or simply because you did the merge anyway
> just to get the proper diffstat because history is complex - mention
> that you have a merged branch for verification (say
> "branch/for-linus-merged").
> 
> When I get that kind of pull request, I'll just do the merge
> resolution myself, and after I've done it I'll generally then do
> 
>    git checkout -b test-merge
>    git pull <repoaddress> for-linus-merged
> 
> and then just compare the end result with my resolution as an extra
> verification step.
> 
> I may end up skipping the verification step if everything looks
> entirely trivial (and really, if you have no real reason for the
> pre-merged branch, don't bother even mentioning it even if you did it
> for the diffstat), but in practice whenever somebody does that, I have
> no reason not to just do that simple extra verification.
> 
> Most of the time the merges are exactly the same, possibly with
> whitespace or trivial ordering differences (things like Makefiles and
> Kconfig files often have add-add conflicts where the ordering really
> doesn't matter between two config options).
> 
> And then sometimes it shows that I missed something in my mmerge.
> 
> And sometimes it shows that  I do so many merges that I actually ended
> up noticing something that the submaintainer didn't.
> 
> So it can be uninteresting, and when it isn't uninteresting it can go
> either way, but so far for the people who do this, I've never been in
> the situation where I was *sorry* for the double merge and extra
> verification step.
> 
> Because when mis-merges happen (they are happily pretty rare) they are
> _so_ annoying and can be so hard to figure out later, that I'd rather
> spend a bit more time on the merge than have a dodgy one.

Thanks for the explanation. Doug and I will do this in future.

Jason
