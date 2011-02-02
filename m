From: Greg Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Subject: Re: re librdmacm-devel dependency on librdmacm
Date: Wed, 2 Feb 2011 11:54:37 -0500
Message-ID: <201102021154.37997.kerr.g@husky.neu.edu>
References: <4D4934FA.8070905@voltaire.com> <4D497BA7.9070701@voltaire.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC0C1C85@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC0C1C85-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This is Red Hat's package, not mine, so I think they would need to answer
> this.  I guess I don't understand the problem, but why wouldn't the
> developer package depend on the real library?  Does libibverbs have a
> similar devel package? --

Every devel package I have ever used has depended on the underlying library. 
A-lot of times the developer packages might include the header files, etc.

I don't work for Red Hat but I don't think there's any issue here.

-- 
Greg Kerr
Northeastern University
High Performance Computing Laboratory

On Wednesday, February 02, 2011 10:55:10 am Hefty, Sean wrote:
> > > What is librdmacm-devel?
> > 
> > as the name suggests... package for developers
> > 
> > Or.
> > 
> > > [root@celery ~]# rpm -qi librdmacm-devel
> > > Name        : librdmacm-devel              Relocations: (not
> > > relocatable) Version     : 1.0.8                             Vendor:
> > > Red Hat, Inc. Release     : 5.el5                         Build Date:
> > > Mon 22 Jun 2009
> > 
> > 05:36:27 PM IDT
> > 
> > > Install Date: Wed 02 Feb 2011 03:05:06 PM IST      Build Host:
> > > hs20-bc1-
> > 
> > 2.build.redhat.com
> > 
> > > Group       : System Environment/Libraries   Source RPM:
> > > librdmacm-1.0.8-
> > 
> > 5.el5.src.rpm
> > 
> > > Size        : 45934                            License: GPL/BSD
> > > Signature   : DSA/SHA1, Thu 16 Jul 2009 08:14:31 AM IDT, Key ID
> > 
> > 5326810137017186
> > 
> > > Packager    : Red Hat, Inc. <http://bugzilla.redhat.com/bugzilla>
> > > URL         : http://www.openfabrics.org/
> > > Summary     : RDMA cm library header files
> > > Description :
> > > RDMA cm library header files.
> 
> This is Red Hat's package, not mine, so I think they would need to answer
> this.  I guess I don't understand the problem, but why wouldn't the
> developer package depend on the real library?  Does libibverbs have a
> similar devel package? --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Greg Kerr
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
