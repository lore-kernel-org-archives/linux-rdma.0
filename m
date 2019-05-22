From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] RDMA/mlx5: Use DIV_ROUND_UP_ULL macro to allow 32 bit
 to build
Date: Wed, 22 May 2019 16:19:18 -0400
Message-ID: <20190522161918.38c91478@gandalf.local.home>
References: <20190522145450.25ff483d@gandalf.local.home>
        <20190522192821.GG6054@ziepe.ca>
        <20190522154305.615d1d76@gandalf.local.home>
        <20190522201412.GI6054@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190522201412.GI6054@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 22 May 2019 17:14:12 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> > As long as it is correct and doesn't break my builds. I really prefer
> > if these kinds of things don't make it into Linus's tree to begin with.
> > I'm surprised the zero-day bot didn't catch this. Because this is
> > something that it normally does.  
> 
> Yes, I was also surprised and I asked them.. They said they needed to
> update ARM compilers to see this..

Really? This triggered on x86 not ARM for me.

-- Steve
