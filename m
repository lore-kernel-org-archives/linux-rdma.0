From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libacm fails to build
Date: Thu, 9 Mar 2017 16:23:52 -0700
Message-ID: <20170309232352.GA12387@obsidianresearch.com>
References: <20170309102527.3ni4pkuendwzqzrm@paradies.suse.de>
 <20170309171014.GC12694@obsidianresearch.com>
 <1489098918.2597.12.camel@sandisk.com>
 <20170309224904.GA5867@obsidianresearch.com>
 <1489099998.2597.16.camel@sandisk.com>
 <20170309230453.GA7844@obsidianresearch.com>
 <1489101151.2597.18.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489101151.2597.18.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "pth-l3A5Bk7waGM@public.gmane.org" <pth-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 09, 2017 at 11:12:43PM +0000, Bart Van Assche wrote:

> Without that patch building an RPM fails against a recent version of
> Tumbleweed:

I don't get it, it is fine for me - just rebuilt my local docker image
=66rom scratch with today's stuff to be certain:

$ rpm -qf /etc/issue.net
openSUSE-release-20170308-1.1.x86_64

Is your macros.cmake unmodified?

ea1f4008e57762c8c422e2562b2bff8f  /etc/rpm/macros.cmake

It seems like something else is going on with your system, I wonder if
your system could have a conflicting rpm macro? The docker image is
very minimal...

> $ cat ./build-rpm.sh =A0=A0=A0=A0=A0=A0=A0=A0=A0
> #!/bin/sh
> name=3Drdma-core
> version=3D$(sed -n 's/^Version:[[:blank:]]*//p' rdma-core.spec)
> rpmtopdir=3D$PWD/rpmbuilddir
> git archive --prefix rdma-core-${version}/ --output ${name}-${version}.tg=
z HEAD &&
>  =A0=A0=A0rm -rf ${rpmtopdir} &&
>  =A0=A0=A0mkdir -p ${rpmtopdir}/{BUILD,RPMS,SOURCES,SPECS,SRPMS} &&
>  =A0=A0=A0cp ${name}-${version}.tgz ${rpmtopdir}/SOURCES &&
>  =A0=A0=A0rpmbuild --define=3D"%_topdir ${rpmtopdir}" -ba ${name}.spec

I ran those commands by hand and had no problem either:

[..]
Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.Xgc1tl
+ umask 022
+ cd /home/jgg/rpmbuild/rpmbuilddir/BUILD
+ /usr/bin/rm -rf /home/jgg/rpmbuild/rpmbuilddir/BUILDROOT/rdma-core-13-1.x=
86_64
++ dirname /home/jgg/rpmbuild/rpmbuilddir/BUILDROOT/rdma-core-13-1.x86_64
+ /usr/bin/mkdir -p /home/jgg/rpmbuild/rpmbuilddir/BUILDROOT
+ /usr/bin/mkdir /home/jgg/rpmbuild/rpmbuilddir/BUILDROOT/rdma-core-13-1.x8=
6_64
+ cd rdma-core-13
+ find . -name CMakeLists.txt -exec sed -i -re '/^[[:blank:]]*[sS][eE][tT][=
[:blank:]]*\([[:blank:]]*(CMAKE_BUILD_TYPE|CMAKE_COLOR_MAKEFILE|CMAKE_INSTA=
LL_PREFIX|CMAKE_VERBOSE_MAKEFILE).*\)/{s/^/#IGNORE /}' '{}' +
+ mkdir -p build
+ cd build
+ /usr/bin/cmake /home/jgg/rpmbuild/rpmbuilddir/BUILD/rdma-core-13/. -GNinj=
a -DCMAKE_INSTALL_PREFIX:PATH=3D/usr -DINCLUDE_INSTALL_DIR:PATH=3D/usr/incl=
ude -DLIB_INSTALL_DIR:PATH=3D/usr/lib64 -DSYSCONF_INSTALL_DIR:PATH=3D/etc -=
DSHARE_INSTALL_PREFIX:PATH=3D/usr/share -DCMAKE_INSTALL_LIBDIR:PATH=3D/usr/=
lib64 -DCMAKE_BUILD_TYPE=3DRelWithDebInfo '-DCMAKE_C_FLAGS=3D-O2 -g -m64 -f=
message-length=3D0 -D_FORTIFY_SOURCE=3D2 -fstack-protector -funwind-tables =
-fasynchronous-unwind-tables -DNDEBUG' '-DCMAKE_CXX_FLAGS=3D-O2 -g -m64 -fm=
essage-length=3D0 -D_FORTIFY_SOURCE=3D2 -fstack-protector -funwind-tables -=
fasynchronous-unwind-tables -DNDEBUG' '-DCMAKE_Fortran_FLAGS=3D-O2 -g -m64 =
-fmessage-length=3D0 -D_FORTIFY_SOURCE=3D2 -fstack-protector -funwind-table=
s -fasynchronous-unwind-tables -DNDEBUG' '-DCMAKE_EXE_LINKER_FLAGS=3D-Wl,--=
as-needed -Wl,--no-undefined -Wl,-z,now' '-DCMAKE_MODULE_LINKER_FLAGS=3D-Wl=
,--as-needed -Wl,--no-undefined -Wl,-z,now' '-DCMAKE_SHARED_LINKER_FLAGS=3D=
-Wl,--as-needed -Wl,--no-undefined -Wl,-z,now' -DLIB_SUFFIX=3D64 -DCMAKE_SK=
IP_RPATH:BOOL=3DON -DCMAKE_VERBOSE_MAKEFILE:BOOL=3DON -DBUILD_SHARED_LIBS:B=
OOL=3DON -DBUILD_STATIC_LIBS:BOOL=3DOFF -DCMAKE_COLOR_MAKEFILE:BOOL=3DOFF -=
DCMAKE_INSTALL_DO_STRIP:BOOL=3DOFF -DCMAKE_MODULES_INSTALL_DIR=3D/usr/share=
/cmake/Modules -DCMAKE_MODULE_LINKER_FLAGS=3D -DCMAKE_BUILD_TYPE=3DRelease =
-DCMAKE_INSTALL_BINDIR:PATH=3D/usr/bin -DCMAKE_INSTALL_SBINDIR:PATH=3D/usr/=
sbin -DCMAKE_INSTALL_LIBDIR:PATH=3D/usr/lib64 -DCMAKE_INSTALL_LIBEXECDIR:PA=
TH=3D/usr/lib -DCMAKE_INSTALL_LOCALSTATEDIR:PATH=3D/var -DCMAKE_INSTALL_SHA=
REDSTATEDIR:PATH=3D/usr/com -DCMAKE_INSTALL_INCLUDEDIR:PATH=3D/usr/include =
-DCMAKE_INSTALL_INFODIR:PATH=3D/usr/share/info -DCMAKE_INSTALL_MANDIR:PATH=
=3D/usr/share/man -DCMAKE_INSTALL_SYSCONFDIR:PATH=3D/etc -DCMAKE_INSTALL_SY=
STEMD_SERVICEDIR:PATH=3D/usr/lib/systemd/system -DCMAKE_INSTALL_INITDDIR:PA=
TH=3D/etc/init.d -DCMAKE_INSTALL_RUNDIR:PATH=3D/run -DCMAKE_INSTALL_DOCDIR:=
PATH=3D/usr/share/doc/packages/rdma-core-13 -DCMAKE_INSTALL_UDEV_RULESDIR:P=
ATH=3D/usr/lib/udev/rules.d
[..]
+ ninja -v -j8

I don't know what to say.. If you want to duplicate what I am looking
at install docker and do:

$ buildlib/cbuild build-images tumbleweed
$ buildlib/cbuild pkg tumbleweed --run-shell

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
