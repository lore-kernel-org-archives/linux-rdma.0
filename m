From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Introduction of libqedr to the Consolidated Userspace RDMA
 Library Repo
Date: Thu, 13 Oct 2016 10:29:42 -0600
Message-ID: <20161013162942.GA5468@obsidianresearch.com>
References: <SN1PR07MB22073DF8F016A275DA036F8EF8C70@SN1PR07MB2207.namprd07.prod.outlook.com>
 <20161006163427.GG1224@obsidianresearch.com>
 <SN1PR07MB2207B8BA2C9C9A1FC610DE9FF8D90@SN1PR07MB2207.namprd07.prod.outlook.com>
 <SN1PR07MB22074FE9B280DDDCE439FBA9F8DC0@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB22074FE9B280DDDCE439FBA9F8DC0-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2016 at 02:37:24PM +0000, Amrani, Ram wrote:
> > >You will want to look at the various patches I've prepared and ensure
> > >you cover off the basic cleanups that have already been done, and that
> > >your code compiles warning-free on FC24.
> 
> By cleanups, do you mean to make sure the code compiles warning-free under 
> the various flags mentioned throughout the git log (-Wempty-body and etc.),

Yes, Travis will enforce this.

> or are there other kinds of cleanups that I'm missing?

Yes, many of the drivers copied the same stuff that is now gone. Here
is a sampling

https://github.com/linux-rdma/rdma-core/commit/1df0888f6a736e1612ce8b054d6c17651ebd003f
https://github.com/linux-rdma/rdma-core/commit/6771a2051ea5efd30e142866f722d2dae6f565a7
https://github.com/linux-rdma/rdma-core/commit/f29b3285f82815da3abdfea5be5c4f2d1ca92743
https://github.com/linux-rdma/rdma-core/commit/9358a8a5484d1caa0c7ad1826e07d2105f58cc4e
https://github.com/linux-rdma/rdma-core/commit/c5c7e32796b19c3707620a3d2f6b32d00d2fbc3c

> > >Once you feel everything is ready then post it to the mailing list and
> > >send a pull request. For the mailing list you can just split the
> > >patches by file..
> 
> As we don't have a publically accessed server I cannot do this at
> the moment (I'm checking how we can set one up).  Is it OK if I send
> you the update as a series of patches?

You don't need a server, just a personal github account.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
