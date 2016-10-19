From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
Date: Wed, 19 Oct 2016 22:55:26 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E24F0E462@CRSMSX101.amr.corp.intel.com>
References: <20161014192136.11731-3-jarod@redhat.com>
 <20161014231934.GC16509@obsidianresearch.com>
 <20161017162221.GI14983@redhat.com>
 <20161017174611.GB6430@obsidianresearch.com>
 <20161017182037.GK14983@redhat.com>
 <20161017185657.GA8122@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24F0A408@CRSMSX101.amr.corp.intel.com>
 <20161017201309.GA24291@obsidianresearch.com>
 <20161018145104.GT14983@redhat.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24F0DF57@CRSMSX101.amr.corp.intel.com>
 <20161019185920.GA20600@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24F0E288@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E24F0E288-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Nevermind I think I have it...

Just need to test with an rpm build...

Ira




> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Weiny, Ira
> Sent: Wednesday, October 19, 2016 2:35 PM
> To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Doug
> Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: RE: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
> infrastructure bits
> 
> Udev below works great.  Thanks!
> 
> But I have another cmake question.
> 
> I have specified the following:
> 
> install(FILES rdma-ndd.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}")
> set(rdma_ndd_CONFIG_PATH "${CMAKE_INSTALL_SYSCONFDIR}")
> configure_file ("${PROJECT_SOURCE_DIR}/rdma-ndd/rdma-config.h.in"
>         "${PROJECT_BINARY_DIR}/rdma-ndd/rdma-config.h")
> include_directories("${PROJECT_BINARY_DIR}/rdma-ndd")
> 
> The idea here is to have an rdma-ndd.conf file which allows the user to
> configure their names.  (previously this was the infiniband-diags.conf file). But I
> have ported over the code.
> 
> The value in rdma-config.h ends up being:
> 
> 17:30:34 > cat build/rdma-ndd/rdma-config.h
> /* Pick up configuration items from cmake */ #define
> RDMA_NDD_CONFIG_PATH "etc"
> #define PACKAGE_VERSION 11
> 
> Which seems fine but after a "make install" I'm left with an incorrect path:
> 
> [root@phcppriv13 sbin]# pwd && ./rdma-ndd -f /usr/local/sbin
> rdma-ndd[91656]: Using config file (etc/rdma-ndd.conf) ...
> 
> So it is not reading the correct config file.
> 
> How do I link the install to this variable in the code?
> 
> Ira
> 
> 
> > -----Original Message-----
> > From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> > Sent: Wednesday, October 19, 2016 11:59 AM
> > To: Weiny, Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Doug
> > Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Subject: Re: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
> > infrastructure bits
> >
> > On Wed, Oct 19, 2016 at 06:38:52PM +0000, Weiny, Ira wrote:
> >
> > > I have the C code ported to rdma-core but how do I do this in cmake?
> >
> > Attached, you will also need
> >
> > target_link_libraries(rdma-ndd ${UDEV_LIBRARIES})
> >
> > >         PKG_CHECK_EXISTS(libudev >= 218, [with_dev_logging=no],
> > >                         [with_udev_logging=yes])
> > >         if test "$with_udev_logging" = "yes"; then
> > >                 AC_DEFINE_UNQUOTED([HAVE_UDEV_LOGGING], 1,
> > >                                 [whether libudev logging can be
> > > used])
> >
> > Dump HAVE_UDEV_LOGGING from the code, upstream deleted support for it:
> >
> > https://www.redhat.com/archives/libvir-list/2014-December/msg00749.htm
> > l
> >
> > src.c:3:2: warning: 'udev_set_log_fn' is deprecated (declared at
> > /usr/include/libudev.h:41) [-Wdeprecated-declarations]
> >   int main(int argc,const char *argv[]) {udev_set_log_fn(NULL, NULL); return
> 0;}
> >   ^
> >
> > > I've found a "modules" file which looks like it has a compatible BSD
> > > license and could be added but is there a better way?
> >
> > Basically the right idea, but I prefer to avoid pkgconfig whenever
> > possible as it screws up cross compiling.
> >
> > > I also have to convert the man page from *.rst to man in some way...
> > > Would it be ok if I put a dependency on rst2man in the repo?
> >
> > We have talked about it, maybe for now just include both the .rst and
> > the rst2man output and we can revisit it..
> >
> > Jason
> >
> > From b0062acc238e06289aa946dacd5c534cf6c68d7d Mon Sep 17 00:00:00
> > 2001
> > From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > Date: Wed, 19 Oct 2016 12:57:25 -0600
> > Subject: [PATCH] Add a dependency on libudev
> >
> > incomplete, needs the RH stuff too.
> >
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > ---
> >  .travis.yml             |  1 +
> >  CMakeLists.txt          |  4 ++++
> >  README.md               |  2 +-
> >  buildlib/FindUDev.cmake | 10 ++++++++++
> >  debian/control          |  1 +
> >  5 files changed, 17 insertions(+), 1 deletion(-)  create mode 100644
> > buildlib/FindUDev.cmake
> >
> > diff --git a/.travis.yml b/.travis.yml index
> > d81b699294eb..d9c36cc9c649 100644
> > --- a/.travis.yml
> > +++ b/.travis.yml
> > @@ -24,6 +24,7 @@ addons:
> >        - gcc-6
> >        - libnl-3-dev
> >        - libnl-route-3-dev
> > +      - libudev-dev
> >        - make
> >        - ninja-build
> >        - pkg-config
> > diff --git a/CMakeLists.txt b/CMakeLists.txt index
> > a23aa860e6d3..9402bacf70ce
> > 100644
> > --- a/CMakeLists.txt
> > +++ b/CMakeLists.txt
> > @@ -237,6 +237,10 @@ if (NOT NL_KIND EQUAL 0)
> >    set(CMAKE_REQUIRED_INCLUDES
> "${SAFE_CMAKE_REQUIRED_INCLUDES}")
> >  endif()
> >
> > +# udev
> > +find_package(UDev REQUIRED)
> > +include_directories(${UDEV_INCLUDE_DIRS})
> > +
> >  # Statically determine sizeof(long), this is largely unnecessary, no
> > new code  # should rely on this.
> >  check_type_size("long" SIZEOF_LONG BUILTIN_TYPES_ONLY LANGUAGE C)
> > diff --git a/README.md b/README.md index 66aee3f49f00..d24fd0bf2606
> > 100644
> > --- a/README.md
> > +++ b/README.md
> > @@ -48,7 +48,7 @@ only load from the system path.
> >  ### Debian Derived
> >
> >  ```sh
> > -$ apt-get install build-essential cmake gcc libnl-3-dev
> > libnl-route-3-dev ninja- build pkg-config valgrind
> > +$ apt-get install build-essential cmake gcc libudev-dev libnl-3-dev
> > +libnl-route-3-dev ninja-build pkg-config valgrind
> >  ```
> >
> >  ### Fedora
> > diff --git a/buildlib/FindUDev.cmake b/buildlib/FindUDev.cmake new
> > file mode
> > 100644 index 000000000000..ce05ddf991a1
> > --- /dev/null
> > +++ b/buildlib/FindUDev.cmake
> > @@ -0,0 +1,10 @@
> > +# COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
> > +
> > +find_library(LIBUDEV_LIBRARY NAMES udev libudev)
> > +
> > +set(UDEV_LIBRARIES ${LIBUDEV_LIBRARY})
> > +
> > +include(FindPackageHandleStandardArgs)
> > +find_package_handle_standard_args(UDev REQUIRED_VARS
> > LIBUDEV_LIBRARY)
> > +
> > +mark_as_advanced(LIBUDEV_LIBRARY)
> > diff --git a/debian/control b/debian/control index
> > 2335d1f4814d..ed9850a348be 100644
> > --- a/debian/control
> > +++ b/debian/control
> > @@ -8,6 +8,7 @@ Build-Depends: build-essential,
> >  	       dh-systemd,
> >  	       dpkg-dev (>= 1.17),
> >  	       gcc,
> > +	       libudev-dev,
> >  	       libnl-3-dev,
> >  	       libnl-route-3-dev,
> >  	       make,
> > --
> > 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
