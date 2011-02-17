From: Tan <fanqielee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: =?utf-8?b?SW5zdGFsbGF0aeKAi29u?= errors of =?utf-8?b?T0ZFRC0xLjUuM+KAiy5yYzQ=?= on kernel =?utf-8?b?Mi42LjM2LVVMNOKAiy14ODZfNjQ=?=
Date: Thu, 17 Feb 2011 16:01:17 +0000 (UTC)
Message-ID: <loom.20110217T170030-339@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Dear all,
 
    I try to install OFED stacks on the host. Since my kernel version is 2.6.36-
UL4-x86_64, which is not supported by OFED-1.5.2. So, I tried OFED-1.5.3-rc4. 
In the process of installation I got the error message of 
 
Build ofa_kernel RPM
Running rpmbuild --rebuild  --define '_topdir /var/tmp//OFED_topdir' --
define 'configure_options   --with-core-mod --with-user_mad-mod --with-
user_access-mod --with-addr_trans-mod --with-mthca-mod --with-mlx4-mod --with-
mlx4_en-mod --with-cxgb3-mod --with-nes-mod --with-ipoib-mod --with-sdp-mod --
with-srp-mod --with-rds-mod' --define 'build_kernel_ib 1' --
define 'build_kernel_ib_devel 1' --define      'KVERSION 2.6.36-UL4' --
define 'K_SRC /lib/modules/2.6.36-UL4/build' --
define 'network_dir /etc/sysconfig/network-scripts' --define '_prefix /usr' --
define '__arch_install_post %{nil}' /atlas/data18a/litan/OFED-1.5.3-
rc4/SRPMS/ofa_kernel-1.5.3-OFED.1.5.3.rc4.src.rpm
Failed to build ofa_kernel RPM
See /tmp/OFED.21798.logs/ofa_kernel.rpmbuild.log
 
Then, I checked the log file and search for the error info. These are the info 
at the end:
 -I/usr/src/kernels/2.6.36-UL4-x86_64/arch/x86/include \
 -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-
aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-
security -fno-delete-null-pointer-checks -Os -m64 -mtune=generic -mno-red-zone -
mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -
DCONFIG_AS_CFI_SIGNAL_FRAME=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-
tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -fno-stack-protector -fomit-frame-
pointer -g -Wdeclaration-after-statement -Wno-pointer-sign  -DMODULE  -
D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(addr)"  -
D"KBUILD_MODNAME=KBUILD_STR(ib_addr)"  -c -
o /var/tmp/OFED_topdir/BUILD/ofa_kernel-
1.5.3/drivers/infiniband/core/.tmp_addr.o /var/tmp/OFED_topdir/BUILD/ofa_kernel-
1.5.3/drivers/infiniband/core/addr.c
gcc: cannot specify -o with -c or -S with multiple files
make[4]: *** [/var/tmp/OFED_topdir/BUILD/ofa_kernel-
1.5.3/drivers/infiniband/core/addr.o] Error 1
make[3]: *** [/var/tmp/OFED_topdir/BUILD/ofa_kernel-
1.5.3/drivers/infiniband/core] Error 2
make[2]: *** [/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.3/drivers/infiniband] 
Error 2
make[1]: *** [_module_/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.3] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.36-UL4-x86_64'
make: *** [kernel] Error 2
 
Finally, I tried to git download all the source code and make install all the 
packages. But after install, everything also didn't work.
 
Failed to get IB devices list: Function not implemented
 
I guess there is some configuration that I haven't done after make install all 
the package. Following are the packs I have installed:
 
[litan@tera04 userspace]$ ls
dapl  ipoibtools  libamso  libibcm  libibverbs  libmthca  librdmacm  management
ps. : My RNIC is NetEffect NE020 10Gb Accelerated Ethernet Adapter (iWARP RNIC).
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
