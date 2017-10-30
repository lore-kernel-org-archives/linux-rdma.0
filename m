From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCE] OFED 4.8-1-rc2 release is available
Date: Mon, 30 Oct 2017 16:59:32 +0800
Message-ID: <68fac738-c365-4e9d-0d17-285123d49e0e@huawei.com>
References: <59F1FE42.5020306@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <59F1FE42.5020306-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi, Vladimir Sokolovsky
 I am trying to install OFED-4.8-1-rc2 and happen a fail
the intall steps as follows:

root@Turing-Arch-b:~/OFED-4.8-1-rc2# ./install.pl
Smartmatch is experimental at ./install.pl line 2696.
cannot remove directory for /var/tmp/OFED_topdir/BUILD: Permission denied at ./install.pl line 1251.
cannot remove directory for /var/tmp/OFED_topdir/SPECS: Permission denied at ./install.pl line 1251.
cannot remove directory for /var/tmp/OFED_topdir/BUILDROOT: Permission denied at ./install.pl line 1251.
cannot remove directory for /var/tmp/OFED_topdir/RPMS/x86_64: Permission denied at ./install.pl line 1251.
cannot remove directory for /var/tmp/OFED_topdir/RPMS: Permission denied at ./install.pl line 1251.
cannot remove directory for /var/tmp/OFED_topdir/SOURCES: Permission denied at ./install.pl line 1251.
cannot remove directory for /var/tmp/OFED_topdir/SRPMS: Permission denied at ./install.pl line 1251.
cannot remove directory for /var/tmp//OFED_topdir: Operation not permitted at ./install.pl line 1251.
OFED Distribution Software Installation Menu

   1) View OFED Installation Guide
   2) Install OFED Software
   3) Show Installed Software
   4) Configure IPoIB
   5) Uninstall OFED Software

   Q) Exit

Select Option [1-5]:2
OFED Distribution Software Installation Menu

   1) Basic (OFED modules and basic user level libraries)
   2) All packages
   3) Customize

   Q) Exit

Select Option [1-3]:1
dpkg-query: no packages found matching libstdc++-devel
dpkg-query: no packages found matching byacc

Below is the list of OFED packages that you have chosen
(some may have been added by the installer due to package dependencies):

ofed-scripts
rdma-core
rdma-core-devel
libibverbs
libibverbs-utils
librdmacm
librdmacm-utils
libibumad
libibcm
ibacm
iwpmd
srp_daemon
mstflint
ofed-docs
compat-rdma

Build ofed-scripts RPM
Running  rpmbuild --rebuild  --nodeps  --define '_topdir /var/tmp//OFED_topdir' --define 'dist %{nil}' --target x86_64 --define '_prefix /usr' --define '_exec_prefix /usr' --define '_sysconfdir /etc' --define '_usr /usr' /home/oulijun/OFED-4.8-1-rc2/SRPMS/ofed-scripts-4.8-1.1.g1f6e1a2.src.rpm
Failed to build ofed-scripts RPM
See /tmp/OFED.14758.logs/ofed-scripts.rpmbuild.log

And can you give me a help?

Thanks
Lijun Ou

在 2017/10/26 23:24, Vladimir Sokolovsky 写道:
> Hi,
> OFED-4.8-1-rc2 is available at:
> https://openfabrics.org/downloads/OFED/ofed-4.8-1/OFED-4.8-1-rc2.tgz
> 
> To get BUILD_ID run ofed_info
> 
> Please report any issues in bugzilla
> http://bugs.openfabrics.org/bugzilla/ for OFED 4.8-1
> 
> Release notes:
> http://openfabrics.org/downloads/OFED/release_notes/OFED_4.8-1_rc2-release_notes
> 
> OFED-4.8-1-rc2 Main Changes from OFED-4.8-1-rc1
> -------------------------------------------------------------------------------
> 1. compat-rdma
> - Fixes for i40iw which have been included in kernels 4.12 and 4.13
> - qedr: fix BZ 2642 - parse VLAN ID and priority correctly
> - bnxt_en: Bug 2645 - Set default completion ring for async events
> - bnxt_re: bz 2646 - 0012-bnxt_re-Make-room-for-mapping-beyond-32-entries.patch
> 
> 2. Updated packages
> - libfabric-1.5.1
> - fabtests-1.5.1
> 
> 
> Regards,
> Vladimir
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
