From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/mlx5: Use DIV_ROUND_UP_ULL macro to allow 32 bit to
 build
Date: Wed, 22 May 2019 17:14:12 -0300
Message-ID: <20190522201412.GI6054@ziepe.ca>
References: <20190522145450.25ff483d@gandalf.local.home>
 <20190522192821.GG6054@ziepe.ca>
 <20190522154305.615d1d76@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190522154305.615d1d76@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 22, 2019 at 03:43:05PM -0400, Steven Rostedt wrote:
> On Wed, 22 May 2019 16:28:21 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Wed, May 22, 2019 at 02:54:50PM -0400, Steven Rostedt wrote:
> > > 
> > > From: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > 
> > > When testing 32 bit x86, my build failed with:
> > > 
> > >   ERROR: "__udivdi3" [drivers/infiniband/hw/mlx5/mlx5_ib.ko] undefined!
> > > 
> > > It appears that a few non-ULL roundup() calls were made, which uses a
> > > normal division against a 64 bit number. This is fine for x86_64, but
> > > on 32 bit x86, it causes the compiler to look for a helper function
> > > __udivdi3, which we do not have in the kernel, and thus fails to build.
> > > 
> > > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > 
> > Do you like this version better?
> > 
> > https://patchwork.kernel.org/patch/10950913/
> > 
> 
> Honestly, I don't care ;-)
> 
> As long as it is correct and doesn't break my builds. I really prefer
> if these kinds of things don't make it into Linus's tree to begin with.
> I'm surprised the zero-day bot didn't catch this. Because this is
> something that it normally does.

Yes, I was also surprised and I asked them.. They said they needed to
update ARM compilers to see this..

Jason
