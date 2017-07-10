From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core make install is failing
Date: Mon, 10 Jul 2017 11:42:03 -0600
Message-ID: <20170710174203.GB16595@obsidianresearch.com>
References: <CAGxzWdAvjAgeiRsR0UvArC0L+n_PbiuNJfoDvkWzV0Y3hypSeg@mail.gmail.com>
 <CANjDDBj4tSozHvEjqR1=QyydpH2iG7yBHU=FUyGj+oVn7Yvz+w@mail.gmail.com>
 <20170709164203.GA3058@obsidianresearch.com>
 <20170710052711.GK1528@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170710052711.GK1528-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suman Debnath <suman.14san-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 10, 2017 at 08:27:11AM +0300, Leon Romanovsky wrote:
> On Sun, Jul 09, 2017 at 10:42:03AM -0600, Jason Gunthorpe wrote:
> > There is nothing special about bnxt_re - it should build in all cases,
> > unless your source tree is older than the patch. Are you sure your
> > build step is not failing for some reason?
> >
> > > Adding Jason, Seemingly a bug in the make-install path.
> >
> > Looks to me like a build problem, install assumes a successfull build,
> > if it expects bnxt_re then it should have been built.
> >
> > The other option is your build output tree got confused when you
> > switched between a tree before/after bnxt_re introduction, but even that is
> > supposed to work automatically.
> 
> Jason,
> 
> They are building with build.sh script with -DIN_PLACE=1.
> 
> It is documentation issue on the rationale of building _in_place_ and why
> installation is not needed for the developers and how RPM/DEB files
> of rdma-core are generated.

Let me see if I can make 'make install' fail with a more sensible
error in this case.

As you said, 'make install' with '-DIN_PLACE' is not allowed or sane.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
