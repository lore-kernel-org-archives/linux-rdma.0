From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Please pull rdma.git
Date: Mon, 29 Apr 2019 09:48:18 -0700
Message-ID: <CAHk-=wiYHXxkHrbDACc1-5bqJPuiMnmwbStSYBYo82zsO=gstQ@mail.gmail.com>
References: <48cbd548d153d1d2a1cf6c4f2127a6cef5d55deb.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <48cbd548d153d1d2a1cf6c4f2127a6cef5d55deb.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Gunthorpe, Jason" <jgg@ziepe.ca>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2019 at 9:29 AM Doug Ledford <dledford@redhat.com> wrote:
>
>
>  drivers/infiniband/core/uverbs_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This trivial one-liner is actually incorrect.

It should use 'vmf->address', because the point of the ZERO_PAGE
argument is to pick the page with the right virtual address alias for
broken architectures that need those kinds.

I'm actually surprised s390 wants it, usually it's just MIPS that has
the horribly broken virtual address translation stuff. But it looks
like for s390 it's at least only a performance issue (ie it causes
some aliases in L1 that cause cacheline ping-pong rather than anything
else).

                 Linus
