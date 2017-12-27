From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH rdma-core] Support writing man pages in MarkDown
Date: Wed, 27 Dec 2017 19:06:05 +0100
Message-ID: <1514397965.4412.18.camel@profitbricks.com>
References: <20171212225936.GA29558@ziepe.ca>
         <455f0faf-516b-fa8d-c0d2-d2cee9194e5b@dev.mellanox.co.il>
         <1514368433.4412.2.camel@profitbricks.com>
         <20171227174444.GC31310@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227174444.GC31310-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Mittwoch, den 27.12.2017, 10:44 -0700 schrieb Jason Gunthorpe:
> On Wed, Dec 27, 2017 at 10:53:53AM +0100, Benjamin Drung wrote:
> > > > Am Sonntag, den 24.12.2017, 14:03 +0200 schrieb Yishai Hadas:
> > > 
> > > On 12/13/2017 12:59 AM, Jason Gunthorpe wrote:
> > > > > pandoc is fairly widely available in the distros with the
> > > > > notable
> > > > 
> > > > problem that centos 6 and 7 can only get it from EPEL.
> > > > 
> > > 
> > > There might be even a worse case scenario where pandoc may not
> > > exist
> > > as 
> > > a package to be installed, for example how about SLES OS ?
> > 
> > The release tarball could contain pre-built man page. So in case
> > the OS
> > does provide pandoc to regenerate the man pages, the pre-built can
> > be
> > used.
> 
> Yes, this is my basic thinking. If pandoc is installed then the
> pre-built can be ignored, otherwise they are used so the build can
> succeed.
> 
> I was thinking of a scheme like
>  buildlib/man-cache/<sha1 of .md file>
>
> So if the .md files are changed for any reason then the build will
> fail.

None of the projects that I know build a cache using checksums. The
projects are just fine with not failing when the source changed, but
the man pages are not updated.

> > Please do not place generated files in the git repository. 
> 
> Realistically, I don't know if this is possible... Too many
> developers
> are using quite old distros these days, and they still have to be
> able to build..
> 
> I guess we just turn off man page generation in ./build.sh ?

A configuration option would be good that allows one to either enable
or disable (re)generating the man pages. By default, cmake would check
if pandoc is available and set the value based on that.

> But, how will 'cubild pkg centos6' work?
> 
> The release .tar.gz files are created by travis
> (buildilb/github-release) so it would not be too hard to
> have it also build the cache.

Yes, let travis build the man pages for the release tarballs.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Geschäftsführer: Achim Weiss, Matthias Steinberg
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
