From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core package version schema
Date: Fri, 6 Jan 2017 11:47:17 -0700
Message-ID: <20170106184717.GC5724@obsidianresearch.com>
References: <1483642867.5227.18.camel@profitbricks.com>
 <20170105230928.GA4262@obsidianresearch.com>
 <1483723704.5227.23.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483723704.5227.23.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 06, 2017 at 06:28:24PM +0100, Benjamin Drung wrote:
> Good to hear. It looked more like being near of a release (and thus
> being the first step). Expect more comments from my side. ;)

Great

> > > The package version could follow the semantic versioning [2], the
> > > version schema from the kernel [3],
> > 
> > We discussed these options on the mailing list and they were not
> > popular.
> 
> Can you point me to these mails?

They were on the linux-rdma mailing list..

I think there were a couple threads, but here is one:

http://www.spinics.net/lists/linux-rdma/msg40407.html

> > We don't have any of the legacy compat reasons to have a two level
> > release number scheme like the kernel.
> 
> I like the two level release numbers, because they prevent the major
> number to rise high too early. IMO 42.1 is not simpler than 2.5.1.

The down side is that 2.5.1 looks like a semantic version '42' does
not.

Systemd is up to 278 and coreos is up to 1284, doesn't seem to bother
anyone?

> Using the date for the version number has benefits outside of time
> based releases. For example you can tell from the version number
> whether the release is recent or old (2017.1 is fresh, but 2012.5 is
> old legacy stuff).

Maybe, I don't think anyone was advocating for it..

> > I hope that
> > significant parts of the the debian/ dir can be maintained upstream
> > like Redhat is going to do for their packaging.
> 
> That is doable as long as the future Debian maintainers will have
> commit access. Otherwise the debian directory will get out of sync
> soon.

We will have to see how things work with this approach.

My hope is to keep things up to date on an ongoing basis, eg this
patch would be an example

https://github.com/linux-rdma/rdma-core/commit/4910f1eb752e1303b796ede7d45fcd2f618f220a

Which includes .spec and debian/ updates for the new installed files added.

I suspect the packaging changelogs will have to be maintained
downstream however.

> PS: How will you create the release tarballs?

via github so far:

https://github.com/linux-rdma/rdma-core/releases
https://github.com/linux-rdma/rdma-core/archive/rdma-core-12-rc4.tar.gz

I think Doug is still experimenting with this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
