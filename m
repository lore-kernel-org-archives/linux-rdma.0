From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] kernel.h: Add generic roundup_64() macro
Date: Thu, 23 May 2019 14:19:25 -0700
Message-ID: <CAHk-=whATjcpjVmTtM-MJw=XWY9kxq2xc67wA4_UkmVgF1mf2Q@mail.gmail.com>
References: <20190523100013.52a8d2a6@gandalf.local.home> <CAHk-=wg5HqJ2Kfgpub+tCWQ2_FiFwEW9H1Rm+an-BLGaGvDDXw@mail.gmail.com>
 <20190523112740.7167aba4@gandalf.local.home> <CAHk-=whFJqTOk0mSxJGeh38ZxDksgRaMrNV8hqTngiuokyJzew@mail.gmail.com>
 <20190523133648.591f9e78@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190523133648.591f9e78@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>, nouveau@lists.freedesktop.org, linux-rdma <linux-rdma@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 23, 2019 at 10:36 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> >
> > Of course, you probably want the usual "at least use 'int'" semantics,
> > in which case the "type" should be "(x)+0":
> >
> >      #define round_up(x, y) size_fn((x)+0, round_up_size, x, y)
> >
> >  and the 8-bit and 16-bit cases will never be used.
>
> I'm curious to what the advantage of that is?

Let's say that you have a structure with a 'unsigned char' member,
because the value range is 0-255.

What happens if you do

   x = round_up(p->member, 4);

and the value is 255?

Now, if you stay in 'unsigned char' the end result is 0. If you follow
the usual C integer promotion rules ("all arithmetic promotes to at
least 'int'"), you get 256.

Most people probably expect 256, and that implies that even if you
pass an 'unsigned char' to an arithmetic function like this, you
expect any math to be done in 'int'. Doing the "(x)+0" forces that,
because the "+0" changes the type of the expression from "unsigned
char" to "int" due to C integer promotion.

Yes. The C integer type rules are subtle and sometimes surprising. One
of the things I've wanted is to have some way to limit silent
promotion (and silent truncation!), and cause warnings. 'sparse' does
some of that with some special-case types (ie __bitwise), but it's
pretty limited.

              Linus
