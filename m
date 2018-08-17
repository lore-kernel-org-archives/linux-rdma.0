From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Fri, 17 Aug 2018 12:31:00 -0700
Message-ID: <CA+55aFxgT8Hipm6bDrHMZ-nmdk3KZTP=J6D5k10UHTcajXAEHA@mail.gmail.com>
References: <20180816215726.GA20526@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180816215726.GA20526@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 16, 2018 at 2:57 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> This time there are many merge conflicts, all due to various tree-wide or RDMA
> subystem wide changes done by various people. The resolution is tricky, as git
> does not highlight two areas that need revision.

I was confused by this, because there were no merge conflicts.

Then I looked at the history, and the reason is that you actually
pushed the for-next branch into the for-linus branch, and so I got the
pre-merged version.

Oh well. I'll look at what the conflicts were, but may end up just
taking your resolution.

           Linus
