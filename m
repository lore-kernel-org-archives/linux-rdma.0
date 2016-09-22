From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core, cmake/ninja question
Date: Thu, 22 Sep 2016 09:48:14 -0600
Message-ID: <20160922154814.GB15212@obsidianresearch.com>
References: <00cc01d214e6$e4cb2d80$ae618880$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00cc01d214e6$e4cb2d80$ae618880$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 22, 2016 at 10:35:06AM -0500, Steve Wise wrote:
> Hey Jason, newb question:  
> 
> How do I force the rdma-core to build with /usr as the install prefix, /etc as
> the config dir, and /usr/lib64 as the lib dir?  It seems to default to
> /usr/local..

Yes, that is the GNU standard - it is what configure did.

The equivilant to configure --prefix is:
     -DCMAKE_INSTALL_PREFIX=/usr

You often also need.
     -DCMAKE_INSTALL_SYSCONFDIR=/etc

There are many paths that are configurable, each distro sets them as
appropriate via the packaging scripts. For instance this is what RPM
tells cmake to do on centos6:

/usr/bin/cmake -DCMAKE_VERBOSE_MAKEFILE=ON
-DCMAKE_INSTALL_PREFIX:PATH=/usr
-DCMAKE_INSTALL_LIBDIR:PATH=/usr/lib64
-DINCLUDE_INSTALL_DIR:PATH=/usr/include
-DLIB_INSTALL_DIR:PATH=/usr/lib64
-DSYSCONF_INSTALL_DIR:PATH=/etc
-DSHARE_INSTALL_PREFIX:PATH=/usr/share
-DLIB_SUFFIX=64
-DCMAKE_SKIP_RPATH:BOOL=ON
-DBUILD_SHARED_LIBS:BOOL=ON
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_INSTALL_BINDIR:PATH=/usr/bin
-DCMAKE_INSTALL_SBINDIR:PATH=/usr/sbin
-DCMAKE_INSTALL_LIBDIR:PATH=/usr/lib64
-DCMAKE_INSTALL_LIBEXECDIR:PATH=/usr/libexec
-DCMAKE_INSTALL_LOCALSTATEDIR:PATH=/var
-DCMAKE_INSTALL_SHAREDSTATEDIR:PATH=/var/lib
-DCMAKE_INSTALL_INCLUDEDIR:PATH=/usr/include
-DCMAKE_INSTALL_INFODIR:PATH=/usr/share/info
-DCMAKE_INSTALL_MANDIR:PATH=/usr/share/man
-DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc
-DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=/tmp/
-DCMAKE_INSTALL_INITDDIR:PATH=/etc/rc.d/init.d

Each distro is a little different. This is all the same stuff as
configure, just different names..

I recommend *against* running 'make install' to /usr. This is a big
package now, it is hard to unwind it once it installs over your
system. I really should finish the run in place patch :|

If you do this:

$ echo /usr/local/lib64/ > /etc/ld.so.conf.d/usrlocal.conf && ldconfig

Then you can install to /usr/local/ and things will work as you
expect. Note, this depends on a verbs patch that is still only in my
preview tree.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
