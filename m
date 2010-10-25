From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH management.git] Fix autotools to include the necessary
	M4 files
Date: Mon, 25 Oct 2010 12:14:51 -0600
Message-ID: <20101025181451.GE15514@obsidianresearch.com>
References: <20101007223301.GA30829@obsidianresearch.com> <20101025180556.GD14919@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101025180556.GD14919@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 25, 2010 at 08:05:56PM +0200, Sasha Khapyorsky wrote:
> Hi Jason,
> 
> On 16:33 Thu 07 Oct     , Jason Gunthorpe wrote:
> > Otherwise running autogen.sh with a new version of autotools and then
> > building on a system with an older version tends to explode.
> > Unfortunately this is sometimes necessary since the new version is
> > required by the package.
> > 
> > This is how GNU envisions this mess works at least..
> > 
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >  infiniband-diags/Makefile.am  |    1 +
> >  infiniband-diags/configure.in |    1 +
> >  libibmad/Makefile.am          |    2 +-
> >  libibmad/configure.in         |    1 +
> >  libibumad/Makefile.am         |    2 +-
> >  libibumad/configure.in        |    1 +
> >  opensm/configure.in           |    1 +
> >  7 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/infiniband-diags/Makefile.am b/infiniband-diags/Makefile.am
> > index af90b05..e4d3d90 100644
> > +++ b/infiniband-diags/Makefile.am
> > @@ -1,3 +1,4 @@
> > +ACLOCAL_AMFLAGS = -I config
> >  SUBDIRS = libibnetdisc
> >  
> >  INCLUDES = -I$(top_builddir)/include/ -I$(srcdir)/include -I$(includedir) \
> > diff --git a/infiniband-diags/configure.in b/infiniband-diags/configure.in
> > index b9326c0..3c16aec 100644
> > +++ b/infiniband-diags/configure.in
> > @@ -3,6 +3,7 @@ dnl Process this file with autoconf to produce a configure script.
> >  AC_PREREQ(2.57)
> >  AC_INIT(infiniband-diags, 1.5.7, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
> >  AC_CONFIG_AUX_DIR(config)
> > +AC_CONFIG_MACRO_DIR(config)
> >  AM_CONFIG_HEADER(config.h)
> >  AM_INIT_AUTOMAKE
> 
> infiniband-diags directory does have any custom m4 macros (libibmad and
> libibumad too). Could you explain why should it fail without the change?
> Is this for potential future use?

No, this is needed right now, libtool will install its custom m4
macros if this directive is present, otherwise it doesn't and that can
muck things up later.

If you don't have this directive then you get warnings from libtool
about this possible risk:

jggl{jgg}/tmp/ofa/management/libibumad#./autogen.sh 
+ aclocal -I config
+ libtoolize --force --copy
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `config'.
libtoolize: copying file `config/ltmain.sh'
libtoolize: Consider adding `AC_CONFIG_MACRO_DIR([m4])' to configure.in and
libtoolize: rerunning libtoolize, to keep the correct libtool macros in-tree.
libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
+ autoheader
+ automake --foreign --add-missing --copy
configure.in:45: installing `config/config.guess'
configure.in:45: installing `config/config.sub'
configure.in:8: installing `config/install-sh'
configure.in:8: installing `config/missing'
Makefile.am: installing `config/depcomp'
+ autoconf

vs after patching:

jggl{jgg}/tmp/ofa/management/libibumad#./autogen.sh 
+ aclocal -I config
+ libtoolize --force --copy
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `config'.
libtoolize: copying file `config/ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `config'.
libtoolize: copying file `config/libtool.m4'
libtoolize: copying file `config/ltoptions.m4'
libtoolize: copying file `config/ltsugar.m4'
libtoolize: copying file `config/ltversion.m4'
libtoolize: copying file `config/lt~obsolete.m4'
+ autoheader
+ automake --foreign --add-missing --copy
+ autoconf

Much happier.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
