From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ANNOUNCE] ibacm release 1.0.6
Date: Tue, 29 May 2012 14:57:43 +0300
Message-ID: <4FC4B9B7.10508@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A82373451AD691@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373451AD691-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/13/2012 09:47 PM, Hefty, Sean wrote:
> ibacm release 1.0.6 is now available from:
>
> https://www.openfabrics.org/downloads/rdmacm/ibacm-1.0.6.tar.gz

Hi Sean,
I tried to run rpmbuild with ibacm-1.0.6 from https://www.openfabrics.org/downloads/rdmacm/ofed/ibacm-1.0.6.tar.gz and it fails on RHEL6.2 with the following error:

Processing files: ibacm-1.0.6-1.x86_64
error: File not found by glob: /var/tmp/OFED_topdir/BUILDROOT/ibacm-1.0.6-1.x86_64/etc/rdma/*
Executing(%doc): /bin/sh -e /var/tmp/rpm-tmp.XvovF7
+ umask 022
+ cd /var/tmp//OFED_topdir/BUILD
+ cd ibacm-1.0.6
+ DOCDIR=/var/tmp/OFED_topdir/BUILDROOT/ibacm-1.0.6-1.x86_64/usr/share/doc/ibacm-1.0.6
+ export DOCDIR
+ rm -rf /var/tmp/OFED_topdir/BUILDROOT/ibacm-1.0.6-1.x86_64/usr/share/doc/ibacm-1.0.6
+ /bin/mkdir -p /var/tmp/OFED_topdir/BUILDROOT/ibacm-1.0.6-1.x86_64/usr/share/doc/ibacm-1.0.6
+ cp -pr AUTHORS COPYING README /var/tmp/OFED_topdir/BUILDROOT/ibacm-1.0.6-1.x86_64/usr/share/doc/ibacm-1.0.6
+ exit 0


RPM build errors:
     group libuuid does not exist - using root
     group libuuid does not exist - using root
     File not found by glob: /var/tmp/OFED_topdir/BUILDROOT/ibacm-1.0.6-1.x86_64/etc/rdma/*


There is an inconsistency between Makefile and ibacm.spec;

 From the Makefile.am:

install-exec-hook:
         install -D -m 755 ibacm.init $(DESTDIR)$(sysconfdir)/init.d/ibacm;

And ibacm.spec.in:
%config(noreplace) %{_sysconfdir}/rdma/*


Note:
The original ibacm (https://www.openfabrics.org/downloads/rdmacm/ibacm-1.0.6.tar.gz) has additional issue:

# rpmbuild -ts ibacm-1.0.6.tar.gz
error: Bad file: /tmp/ibacm.init: No such file or directory


RPM build errors:
     Bad file: /tmp/ibacm.init: No such file or directory



Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
