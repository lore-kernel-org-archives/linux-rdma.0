From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma-core make install is failing
Date: Mon, 10 Jul 2017 09:02:28 +0530
Message-ID: <CANjDDBhVbCsXOvjuJRDBfj6gEL8P59zv46Lu5i1N9gQBXfi0jQ@mail.gmail.com>
References: <CAGxzWdAvjAgeiRsR0UvArC0L+n_PbiuNJfoDvkWzV0Y3hypSeg@mail.gmail.com>
 <CANjDDBj4tSozHvEjqR1=QyydpH2iG7yBHU=FUyGj+oVn7Yvz+w@mail.gmail.com> <20170709164203.GA3058@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170709164203.GA3058-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Suman Debnath <suman.14san-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I did couple of experiments and removed bnxt_re from the list of
providers, "make install" now fails exactly the same way for cxgb3. If
we have "make install" target it should work cleanly instead of
failing with errors or confusing outputs.


On Sun, Jul 9, 2017 at 10:12 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> There is nothing special about bnxt_re - it should build in all cases,
> unless your source tree is older than the patch. Are you sure your
> build step is not failing for some reason?
>
>> Adding Jason, Seemingly a bug in the make-install path.
>
> Looks to me like a build problem, install assumes a successfull build,
> if it expects bnxt_re then it should have been built.
>
> The other option is your build output tree got confused when you
> switched between a tree before/after bnxt_re introduction, but even that is
> supposed to work automatically.
>
> Jason
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
