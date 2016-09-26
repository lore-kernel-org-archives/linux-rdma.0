From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: OFED-4.8 daily build with RHEL7.2 support
Date: Mon, 26 Sep 2016 18:04:16 +0300
Message-ID: <57E938F0.1000202@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060506030705000602070100"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------060506030705000602070100
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
The IB core stuff and ConnectX-3 IB and Ethernet drivers were backported 
for RHEL7.2.
Available kernel components on RHEL7.2 are ib_core, mlx4_core, mlx4_ib 
and mlx4_en.

https://www.openfabrics.org/downloads/OFED/ofed-4.8-daily/OFED-4.8-20160926-0542.tgz

To install this OFED version on RHEL7.2 use the attached ofed.conf file:
# cd OFED-4.8-20160926-0542
# ./install.pl -c ofed.conf

Compat-rdma development environment:

1. Clone the relevant git trees
git://git.openfabrics.org/compat-rdma/compat-rdma.git master
git://git.openfabrics.org/compat-rdma/linux-4.8.git master (includes the 
relevant upstream linux sub trees based on 4.8-rc8)
git://git.openfabrics.org/compat-rdma/compat.git ofed

2. Prepare compilation environment
# cd <workdir>/compat-rdma
# GIT_TREE=<workdir>/linux-4.8 GIT_COMPAT_TREE=<workdir>/compat 
./scripts/admin_rdma.sh -n -p

- This is what applies all the patches in the following order:
     1. backports from patches directory
     2. linux-next-cherry-picks
     3. linux-next-pending

Patches from the tech-preview directory will be applied by the configure 
script if the corresponding configuration parameter is set.

3. To add support for the new kernel module need to update configure, 
makefile, Makefile, compat-rdma.spec and ofed_scripts/openibd under 
compat-rdma.

4. Compilation procedure:
Note: Procedure to build/install OFED kernel modules on your local machine.
# ./configure --with-core-mod --with-user_mad-mod --with-user_access-mod 
--with-addr_trans-mod --with-mlx4-mod --with-mlx4_en-mod 
--with-cxgb3-mod --with-cxgb4-mod --with-nes-mod --with-qib-mod 
--with-ipoib-mod --with-srp-mod --with-nfsrdma-mod
# make
# make install

Notes:
Use "compat-rdma/ofed_scripts/ofed_format_patch.sh" to create backport 
patches.
All patches should be applicable using "git am"

OFED installation environment:
git://git.openfabrics.org/~vlad/ofed_scripts.git master

OFED build environment:
git://git.openfabrics.org/~vlad/build.git master

Next steps:
- Add ConnectX-4 backports for RHEL7.2
- Add ULPs backports for RHEL7.2
- Creating backports for SLES12 SP1
- Add support for other versions of RHEL7.x and SLES12
- Replace user space libraries with rdma-core package

Regards,
Vladimir



--------------060506030705000602070100
Content-Type: text/plain; charset=UTF-8;
 name="ofed.conf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ofed.conf"

Y29tcGF0LXJkbWE9eQpjb21wYXQtcmRtYS1kZXZlbD15CmxpYmlidmVyYnM9eQpsaWJpYnZl
cmJzLWRldmVsPXkKbGliaWJ2ZXJicy1kZXZlbC1zdGF0aWM9eQpsaWJpYnZlcmJzLXV0aWxz
PXkKbGliaWJ2ZXJicy1kZWJ1Z2luZm89eQpsaWJtdGhjYT15CmxpYm10aGNhLWRldmVsLXN0
YXRpYz15CmxpYm10aGNhLWRlYnVnaW5mbz15CmxpYm1seDQ9eQpsaWJtbHg0LWRldmVsPXkK
bGlibWx4NC1kZWJ1Z2luZm89eQpsaWJtbHg1PXkKbGlibWx4NS1kZXZlbD15CmxpYm1seDUt
ZGVidWdpbmZvPXkKbGliY3hnYjM9eQpsaWJjeGdiMy1kZXZlbD15CmxpYmN4Z2IzLWRlYnVn
aW5mbz15CmxpYmN4Z2I0PXkKbGliY3hnYjQtZGV2ZWw9eQpsaWJjeGdiNC1kZWJ1Z2luZm89
eQpsaWJuZXM9eQpsaWJuZXMtZGV2ZWwtc3RhdGljPXkKbGlibmVzLWRlYnVnaW5mbz15Cmxp
Ym9jcmRtYT15CmxpYm9jcmRtYS1kZXZlbD15CmxpYm9jcmRtYS1kZWJ1Z2luZm89eQpsaWJp
cGF0aHZlcmJzPXkKbGliaXBhdGh2ZXJicy1kZXZlbD15CmxpYmlwYXRodmVyYnMtZGVidWdp
bmZvPXkKbGliaWJjbT15CmxpYmliY20tZGV2ZWw9eQpsaWJpYmNtLWRlYnVnaW5mbz15Cmxp
YmlidW1hZD15CmxpYmlidW1hZC1kZXZlbD15CmxpYmlidW1hZC1zdGF0aWM9eQpsaWJpYnVt
YWQtZGVidWdpbmZvPXkKbGliaWJtYWQ9eQpsaWJpYm1hZC1kZXZlbD15CmxpYmlibWFkLXN0
YXRpYz15CmxpYmlibWFkLWRlYnVnaW5mbz15Cmlic2ltPXkKaWJzaW0tZGVidWdpbmZvPXkK
aWJhY209eQpsaWJyZG1hY209eQpsaWJyZG1hY20tdXRpbHM9eQpsaWJyZG1hY20tZGV2ZWw9
eQpsaWJyZG1hY20tZGVidWdpbmZvPXkKb3BlbnNtPXkKb3BlbnNtLWxpYnM9eQpvcGVuc20t
ZGV2ZWw9eQpvcGVuc20tZGVidWdpbmZvPXkKb3BlbnNtLXN0YXRpYz15CmRhcGw9eQpkYXBs
LWRldmVsPXkKZGFwbC1kZXZlbC1zdGF0aWM9eQpkYXBsLXV0aWxzPXkKZGFwbC1kZWJ1Z2lu
Zm89eQpwZXJmdGVzdD15Cm1zdGZsaW50PXkKbGliaXdwbT15CnNycHRvb2xzPXkKcmRzLXRv
b2xzPXkKcmRzLWRldmVsPXkKaWJ1dGlscz15CmluZmluaWJhbmQtZGlhZ3M9eQpxcGVyZj15
CnFwZXJmLWRlYnVnaW5mbz15Cm9mZWQtZG9jcz15Cm9mZWQtc2NyaXB0cz15CmxpYmZhYnJp
Yz15CmxpYmZhYnJpYy1kZXZlbD15CmxpYmZhYnJpYy1kZWJ1Z2luZm89eQpmYWJ0ZXN0cz15
CmZhYnRlc3RzLWRlYnVnaW5mbz15CmluZmluaXBhdGgtcHNtPXkKaW5maW5pcGF0aC1wc20t
ZGV2ZWw9eQpjb3JlPXkKbXRoY2E9Cm1seDQ9eQptbHg0X2VuPXkKbWx4NT0KY3hnYjM9CmN4
Z2I0PQpuZXM9CnFpYj0Kb2NyZG1hPQppcG9pYj0Kc3JwPQppc2VyPQpuZnNyZG1hPQo=
--------------060506030705000602070100--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
