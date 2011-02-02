From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: re librdmacm-devel dependency on librdmacm
Date: Wed, 2 Feb 2011 15:47:17 -0700
Message-ID: <20110202224717.GJ2283@obsidianresearch.com>
References: <4D4934FA.8070905@voltaire.com>
 <4D49DD4E.4070904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D49DD4E.4070904-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 02, 2011 at 03:40:14PM -0700, Steven Dake wrote:
> On 02/02/2011 03:42 AM, Or Gerlitz wrote:
> > Hi Sean,
> > 
> > I just realized the librdmacm-devel (version 1.0.8-5.el5 is installed on
> > the system I hit that) is dependent on librdmacm, and wasn't sure if its
> > a bug or a feature... the dependency is created through
> > /usr/lib64/librdmacm.so which is soft link to the obj file installed by
> > librdmacm.
> > 
> 
> This is a normal policy for RPM based distributions.  I believe deb
> based distributions do something different, but don't recall the details.

DEB is the same. The linker requires the actual .so to be able to
link, so a -devel package without a corrisponding (MATCHING) lib
package is useless.

$ apt-cache show libibverbs-dev 
Package: libibverbs-dev
Priority: extra
Section: libdevel
Installed-Size: 364
Maintainer: Ubuntu MOTU Developers <ubuntu-motu-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
Original-Maintainer: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Architecture: amd64
Source: libibverbs
Version: 1.1.3-2ubuntu1
Depends: libibverbs1 (= 1.1.3-2ubuntu1)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
