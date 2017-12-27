From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] Support writing man pages in MarkDown
Date: Wed, 27 Dec 2017 10:44:44 -0700
Message-ID: <20171227174444.GC31310@mellanox.com>
References: <20171212225936.GA29558@ziepe.ca>
 <455f0faf-516b-fa8d-c0d2-d2cee9194e5b@dev.mellanox.co.il>
 <1514368433.4412.2.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514368433.4412.2.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 27, 2017 at 10:53:53AM +0100, Benjamin Drung wrote:
> > > Am Sonntag, den 24.12.2017, 14:03 +0200 schrieb Yishai Hadas:
> > On 12/13/2017 12:59 AM, Jason Gunthorpe wrote:
> > > > pandoc is fairly widely available in the distros with the notable
> > > problem that centos 6 and 7 can only get it from EPEL.
> > > 
> > 
> > There might be even a worse case scenario where pandoc may not exist
> > as 
> > a package to be installed, for example how about SLES OS ?
> 
> The release tarball could contain pre-built man page. So in case the OS
> does provide pandoc to regenerate the man pages, the pre-built can be
> used.

Yes, this is my basic thinking. If pandoc is installed then the
pre-built can be ignored, otherwise they are used so the build can
succeed.

I was thinking of a scheme like
 buildlib/man-cache/<sha1 of .md file>

So if the .md files are changed for any reason then the build will
fail.

> Please do not place generated files in the git repository. 

Realistically, I don't know if this is possible... Too many developers
are using quite old distros these days, and they still have to be
able to build..

I guess we just turn off man page generation in ./build.sh ?

But, how will 'cubild pkg centos6' work?

The release .tar.gz files are created by travis
(buildilb/github-release) so it would not be too hard to
have it also build the cache.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
