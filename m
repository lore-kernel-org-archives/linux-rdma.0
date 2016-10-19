From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
Date: Wed, 19 Oct 2016 18:38:52 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E24F0DF57@CRSMSX101.amr.corp.intel.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-3-jarod@redhat.com>
 <20161014231934.GC16509@obsidianresearch.com>
 <20161017162221.GI14983@redhat.com>
 <20161017174611.GB6430@obsidianresearch.com>
 <20161017182037.GK14983@redhat.com>
 <20161017185657.GA8122@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24F0A408@CRSMSX101.amr.corp.intel.com>
 <20161017201309.GA24291@obsidianresearch.com>
 <20161018145104.GT14983@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161018145104.GT14983-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ok,

I have the C code ported to rdma-core but how do I do this in cmake?

AS_IF([test x$rdmandd = xyes], [
    PKG_CHECK_MODULES([UDEV], [libudev])
    AC_CONFIG_FILES([doc/man/rdma-ndd.8 \
                        etc/rdma-ndd.init \
                        etc/rdma-ndd.service])
    AC_SUBST([UDEV_CFLAGS])
    AC_SUBST([UDEV_LIBS])
    if test "$with_udev" = "yes"; then
        PKG_CHECK_EXISTS(libudev >= 218, [with_dev_logging=no],
                        [with_udev_logging=yes])
        if test "$with_udev_logging" = "yes"; then
                AC_DEFINE_UNQUOTED([HAVE_UDEV_LOGGING], 1,
                                [whether libudev logging can be used])
        fi
    fi
])

I've found a "modules" file which looks like it has a compatible BSD license and could be added but is there a better way?

http://fossies.org/linux/flightgear/CMakeModules/FindUDev.cmake

I also have to convert the man page from *.rst to man in some way...  Would it be ok if I put a dependency on rst2man in the repo?

Ira


> -----Original Message-----
> From: Jarod Wilson [mailto:jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Tuesday, October 18, 2016 7:51 AM
> To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Weiny, Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Doug
> Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: Re: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
> infrastructure bits
> 
> On Mon, Oct 17, 2016 at 02:13:09PM -0600, Jason Gunthorpe wrote:
> > On Mon, Oct 17, 2016 at 07:10:46PM +0000, Weiny, Ira wrote:
> >
> > > What I have been worried about is conflicts between infiniband-diags
> > > and the new rdma-core.  RH made a separate package out of rdma-ndd
> > > so that would be easy but I don't think other distros have.
> >
> > > So how do you obsolete "part" of a package?
> >
> > The distros know how to do this, they just conflict with the old
> > version of infiniband-diags.
> 
> Yeah, basically, you spin up a new infiniband-diags package that doesn't have
> rdma-ndd and a new rdma-core package that includes it, along with (in
> rpm-ese) 'Conflicts: infiniband-diags < <first version w/o rdma-ndd>', and that
> should pretty much cover it.
> 
> --
> Jarod Wilson
> jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
