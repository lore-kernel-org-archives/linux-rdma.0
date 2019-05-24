From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] kernel.h: Add generic roundup_64() macro
Date: Fri, 24 May 2019 11:26:56 -0400
Message-ID: <20190524112656.5ef67c6c@gandalf.local.home>
References: <20190523100013.52a8d2a6@gandalf.local.home>
        <CAHk-=wg5HqJ2Kfgpub+tCWQ2_FiFwEW9H1Rm+an-BLGaGvDDXw@mail.gmail.com>
        <20190523112740.7167aba4@gandalf.local.home>
        <e4e875f0-2aa5-89f4-f462-78bedb9c5cde@filmlight.ltd.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e4e875f0-2aa5-89f4-f462-78bedb9c5cde@filmlight.ltd.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>, nouveau@lists.freedesktop.org, linux-rdma <linux-rdma@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 24 May 2019 16:11:14 +0100
Roger Willcocks <roger@filmlight.ltd.uk> wrote:

> On 23/05/2019 16:27, Steven Rostedt wrote:
> >
> > I haven't yet tested this, but what about something like the following:
> >
> > ...perhaps forget about the constant check, and just force
> > the power of two check:
> >
> > 							\
> > 	if (!(__y & (__y >> 1))) {			\
> > 		__x = round_up(x, y);			\
> > 	} else {					\  
> 
> You probably want
> 
>             if (!(__y & (__y - 1))
> 
> --

Yes I do. I corrected it in my next email.

 http://lkml.kernel.org/r/20190523133648.591f9e78@gandalf.local.home

> #define roundup(x, y) (					\
> {							\
> 	typeof(y) __y = y;				\
> 	typeof(x) __x;					\
> 							\
> 	if (__y & (__y - 1))				\
> 		__x = round_up(x, __y);			\
> 	else						\
> 		__x = (((x) + (__y - 1)) / __y) * __y;	\
> 	__x;						\
> })


-- Steve
