From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Sun, 4 Sep 2016 22:10:44 -0600
Message-ID: <20160905041044.GA3490@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <4f0876ce-f3c9-83e3-d0ef-0c5656ce9462@grimberg.me>
 <53eb35b4-0320-acd9-9969-73f5817c8144@sandisk.com>
 <20160901172355.GA20472@obsidianresearch.com>
 <019b01d2047f$b9694f90$2c3beeb0$@opengridcomputing.com>
 <20160902233231.GA26309@obsidianresearch.com>
 <ef8214f8-d44d-2289-d1ed-a0998e9e05c0@sandisk.com>
 <20160903051222.GA2098@obsidianresearch.com>
 <BLUPR02MB16836859F638150FF6330A0A81E40@BLUPR02MB1683.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BLUPR02MB16836859F638150FF6330A0A81E40-Y8PPn9RqzNfZ9ihocuPUdanrV9Ap65cLvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Sep 03, 2016 at 02:08:24PM +0000, Bart Van Assche wrote:
> On my development system I run openSuSE Tumbleweed, a rolling release. I 
> update it every now and then by running "zypper dist-upgrade". Some of 
> our production systems run SLES 12 SP2; others run RHEL 6 or RHEL 7.

Okay, this is what I came up with. Not very pretty, but suse and rh
have different %cmake macros.. :|

Docker says it works on tumbleweed, os42.1, os13.2, fc24, c7, c6 -
which seems like enough :|

Name: rdma-plumbing
Version: 1
Release: 1%{?dist}
Summary: Userspace components for the Linux Kernel\'s drivers/infiniband stack

License: GPLv2 or BSD
Url: http://openfabrics.org/
Source: rdma-plumbing-%{version}.tgz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

BuildRequires: binutils
BuildRequires: cmake >= 2.8.11
BuildRequires: gcc
BuildRequires: pkgconfig
BuildRequires: pkgconfig(libnl-3.0)
BuildRequires: pkgconfig(libnl-route-3.0)
BuildRequires: valgrind-devel

# Since we recommend developers use Ninja, so should packagers, for consistency.
%define CMAKE_FLAGS %{nil}
%if 0%{?suse_version}
# SuSE releases have it, and sometime around cmake 3.3.2-1.2 the macros learned to use it.
BuildRequires: ninja,make
%define __builder ninja
# cmake_install,make_jobs is specified by opensuse
%else
%if 0%{?fedora} >= 23
# Ninja was introduced in FC23
BuildRequires: ninja-build
%define CMAKE_FLAGS -GNinja
%define make_jobs ninja -v %{?_smp_mflags}
%define cmake_install DESTDIR=%{buildroot} ninja-build install
%else
# Fallback to make otherwise
BuildRequires: make
%define make_jobs make -v %{?_smp_mflags}
%define cmake_install DESTDIR=%{buildroot} make install
%endif
%endif

%description
Temporary packaging

This is a simple example without the split sub packages to get things started.

%prep
%setup

%build

# Detect if systemd is supported on this system
%if 0%{?_unitdir:1}
%define my_unitdir %{_unitdir}
%else
%define my_unitdir /tmp/
%endif

# Pass all of the rpm paths directly to GNUInstallDirs and our other defines.
%cmake %{CMAKE_FLAGS} \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_INSTALL_BINDIR:PATH=%{_bindir} \
         -DCMAKE_INSTALL_SBINDIR:PATH=%{_sbindir} \
         -DCMAKE_INSTALL_LIBDIR:PATH=%{_libdir} \
         -DCMAKE_INSTALL_LIBEXECDIR:PATH=%{_libexecdir} \
         -DCMAKE_INSTALL_LOCALSTATEDIR:PATH=%{_localstatedir} \
         -DCMAKE_INSTALL_SHAREDSTATEDIR:PATH=%{_sharedstatedir} \
         -DCMAKE_INSTALL_INCLUDEDIR:PATH=%{_includedir} \
         -DCMAKE_INSTALL_INFODIR:PATH=%{_infodir} \
         -DCMAKE_INSTALL_MANDIR:PATH=%{_mandir} \
         -DCMAKE_INSTALL_SYSCONFDIR:PATH=%{_sysconfdir} \
	 -DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=%{my_unitdir} \
	 -DCMAKE_INSTALL_INITDDIR:PATH=%{_initrddir}
%make_jobs

%install
%cmake_install

%if 0%{?_unitdir:1}
rm -rf %{buildroot}/%{_initrddir}/
%else
rm -rf %{buildroot}/%{my_unitdir}/
%endif

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%files
%doc %{_mandir}/man*/*
%{_bindir}/*
%{_includedir}/*
%{_libdir}/lib*
%{_libdir}/rsocket/*
%{_sbindir}/*
%if 0%{?_unitdir:1}
%{_unitdir}/*
%else
%config %{_initrddir}/*
%endif
%config %{_sysconfdir}/iwpmd.conf
%config %{_sysconfdir}/srp_daemon.conf
%config %{_sysconfdir}/libibverbs.d/*
%config %{_sysconfdir}/logrotate.d/srp_daemon
%{_sysconfdir}/modprobe.d/*
%config %{_sysconfdir}/rsyslog.d/srp_daemon.conf
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
