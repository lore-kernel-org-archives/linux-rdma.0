From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH rdma-core] Support writing man pages in MarkDown
Date: Wed, 27 Dec 2017 10:53:53 +0100
Message-ID: <1514368433.4412.2.camel@profitbricks.com>
References: <20171212225936.GA29558@ziepe.ca>
         <455f0faf-516b-fa8d-c0d2-d2cee9194e5b@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <455f0faf-516b-fa8d-c0d2-d2cee9194e5b-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Am Sonntag, den 24.12.2017, 14:03 +0200 schrieb Yishai Hadas:
> On 12/13/2017 12:59 AM, Jason Gunthorpe wrote:
> > > pandoc is fairly widely available in the distros with the notable
> > problem that centos 6 and 7 can only get it from EPEL.
> > 
> 
> There might be even a worse case scenario where pandoc may not exist
> as 
> a package to be installed, for example how about SLES OS ?

The release tarball could contain pre-built man page. So in case the OS
does provide pandoc to regenerate the man pages, the pre-built can be
used.

> > Since this may be a problem, I am thinking about following the
> > libfabric approach and either including the precompiled man pages
> > in
> > the source tree, or just providing a framework for downstream to
> > add-on precompiled files (with a cbuild command to make them)
> > Looking for feedback on what path is best..
> > 

Please do not place generated files in the git repository. 

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
