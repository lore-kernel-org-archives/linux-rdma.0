From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Fri, 17 Aug 2018 14:15:35 -0600
Message-ID: <20180817201535.GI28676@mellanox.com>
References: <20180816215726.GA20526@ziepe.ca>
 <CA+55aFxgT8Hipm6bDrHMZ-nmdk3KZTP=J6D5k10UHTcajXAEHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxgT8Hipm6bDrHMZ-nmdk3KZTP=J6D5k10UHTcajXAEHA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 17, 2018 at 12:31:00PM -0700, Linus Torvalds wrote:
> On Thu, Aug 16, 2018 at 2:57 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
> >
> > This time there are many merge conflicts, all due to various tree-wide or RDMA
> > subystem wide changes done by various people. The resolution is tricky, as git
> > does not highlight two areas that need revision.
> 
> I was confused by this, because there were no merge conflicts.
> 
> Then I looked at the history, and the reason is that you actually
> pushed the for-next branch into the for-linus branch, and so I got the
> pre-merged version.

Er, yes, sorry, I made a typo in my email, it should have read "As
before I've resolved the conflicts in the for-linus tag and provided
the unmerged tree in the for-linus-unmerged tag"

> Oh well. I'll look at what the conflicts were, but may end up just
> taking your resolution.

We often have merge conflicts with RDMA, how do you prefer to get the
PR? I'm actually not very clear on this part of the process.

Historically, when we have conflicts, I've given you a tag
'for-linus-unmerged', a text description of the conflicts with merge
diff hunks, and then a tag 'for-linus' which contains the full
resolution I used and checked (based on linux-next).

In the past you've taken from both tags, I think, depending on how
the resolution looks?

I generate the 'git request-pull' against the 'for-linus' tag only
because the diffstat of the resolved branch is closer to what you'll
actually see during merge. Otherwise there are always misleading
netdev changes due to the shared branches with netdev.

If you don't care about the diffstat I'll switch to 'for-linus' and
'for-linus-resolved' tags so you won't accidentally get any resolution
commit unless you want it.

Thanks,
Jason
