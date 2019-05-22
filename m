From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] RDMA/mlx5: Use DIV_ROUND_UP_ULL macro to allow 32 bit
 to build
Date: Wed, 22 May 2019 15:43:05 -0400
Message-ID: <20190522154305.615d1d76@gandalf.local.home>
References: <20190522145450.25ff483d@gandalf.local.home>
        <20190522192821.GG6054@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190522192821.GG6054@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 22 May 2019 16:28:21 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Wed, May 22, 2019 at 02:54:50PM -0400, Steven Rostedt wrote:
> > 
> > From: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > 
> > When testing 32 bit x86, my build failed with:
> > 
> >   ERROR: "__udivdi3" [drivers/infiniband/hw/mlx5/mlx5_ib.ko] undefined!
> > 
> > It appears that a few non-ULL roundup() calls were made, which uses a
> > normal division against a 64 bit number. This is fine for x86_64, but
> > on 32 bit x86, it causes the compiler to look for a helper function
> > __udivdi3, which we do not have in the kernel, and thus fails to build.
> > 
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---  
> 
> Do you like this version better?
> 
> https://patchwork.kernel.org/patch/10950913/
> 

Honestly, I don't care ;-)

As long as it is correct and doesn't break my builds. I really prefer
if these kinds of things don't make it into Linus's tree to begin with.
I'm surprised the zero-day bot didn't catch this. Because this is
something that it normally does.

-- Steve
