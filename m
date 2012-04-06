From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ibacm: Fixes to ACM package to support distros
Date: Fri, 6 Apr 2012 04:43:37 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823734519B304@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A823734519A805@ORSMSX101.amr.corp.intel.com>
 <4F7DC3F8.2030406@redhat.com>
 <1828884A29C6694DAF28B7E6B8A823734519B048@ORSMSX101.amr.corp.intel.com>
 <4F7DF0D4.5040101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F7DF0D4.5040101-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I create a .tar.gz package using 'make dist', copy it to another
> > system, then install it using 'configure && make install'.  When I do
> > that, sysconfdir defaults to /usr/local/etc, sbindir /usr/local/sbin,
> > and bindir to /usr/local/bin.  I added /usr/local to PATH, so that
> > the init script would work.  Otherwise I get a 'command not found'
> > error when running the script.  On a side note, my ibacm
> > configuration files end up in /usr/local/etc/rdma.
> 
> configure --prefix=/usr --sysconfdir=/etc && make && make install

I should have mentioned that this is on my development systems.  I'd like to avoid using rmp's or needing to pass in extra configure options.  I'd like it to 'just work' in all cases.  :/

> > To say that I'm not sure what autotools and the init scripts are
> > doing is an understatement...  The init script finds ibacm in
> > /usr/sbin,
> 
> Which means some time it got installed there, either by an rpm or
> something else.

I manually copied the file there to see if the init script would find it.

> make dist
> rpmbuild --rebuild <name_of_tarball>
> rpm -Uvh ~/rpmbuild/RPMS/<arch>/<rpmlist>
> 
> You might need this in your ~/.rpmmacros file:
> 
> %_topdir %(echo $HOME)/rpmbuild

thanks - I'll try to test the rmp installation as well.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
