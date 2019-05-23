From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] kernel.h: Add generic roundup_64() macro
Date: Thu, 23 May 2019 08:10:44 -0700
Message-ID: <CAHk-=wg5HqJ2Kfgpub+tCWQ2_FiFwEW9H1Rm+an-BLGaGvDDXw@mail.gmail.com>
References: <20190523100013.52a8d2a6@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190523100013.52a8d2a6@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>, nouveau@lists.freedesktop.org, linux-rdma <linux-rdma@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 23, 2019 at 7:00 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> +# define roundup_64(x, y) (                            \
> +{                                                      \
> +       typeof(y) __y = y;                              \
> +       typeof(x) __x = (x) + (__y - 1);                \
> +       do_div(__x, __y);                               \
> +       __x * __y;                                      \
> +}                                                      \

The thing about this is that it absolutely sucks for power-of-two arguments.

The regular roundup() that uses division has the compiler at least
optimize them to shifts - at least for constant cases. But do_div() is
meant for "we already know it's not a power of two", and the compiler
doesn't have any understanding of the internals.

And it looks to me like the use case you want this for is very much
probably a power of two. In which case division is all kinds of just
stupid.

And we already have a power-of-two round up function that works on
u64. It's called "round_up()".

I wish we had a better visual warning about the differences between
"round_up()" (limited to powers-of-two, but efficient, and works with
any size) and "roundup()" (generic, potentially horribly slow, and
doesn't work for 64-bit on 32-bit).

Side note: "round_up()" has the problem that it uses "x" twice.

End result: somebody should look at this, but I really don't like the
"force division" case that is likely horribly slow and nasty.

                  Linus
