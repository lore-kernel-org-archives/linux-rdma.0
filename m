From: Andrew Robbie (OFED) <andrew_ofed-320cqWz7bdeOFMEK3gwZYA@public.gmane.org>
Subject: Building OFED 1.5.4.1 on SLES11SP1 + updates kernel 2.6.32.54-0.3
Date: Wed, 15 Feb 2012 10:32:29 +1100
Message-ID: <F77CE6DA-FCE7-433B-A3AA-16D2045E0738@poodlefaker.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=WINDOWS-1252;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I'm trying to build the recent OFED release on a SLES11SP1 box with =20
the latest kernel, had to upgrade to fix security and other problems. =20
However, the OFED build is dying... does anyone have any patches to =20
make this work? Can I pull fixes from some dev tree?

The problem seems to be that the SLES kernel has backports for some of =
=20
the definitions OFED itself defines backports for:
ofa_kernel-1.5.4.1/kernel_addons/backport/2.6.32/include/linux/err.h:8
/usr/src/linux-2.6.32.54-0.3/include/linux/err.h:38
		IS_ERR_OR_NULL

Previous decl with conflicting types:
ofa_kernel-1.5.4.1/kernel_addons/backport/2.6.32/include/linux/=20
netdevice.h:32
	extern void netif_set_real_num_tx_queues(struct net_device *dev, =20
unsigned int txq);

/usr/src/linux-2.6.32.54-0.3/include/linux/netdevice.h:1459
	static inline int netif_set_real_num_tx_queues(struct net_device =20
*dev, unsigned int rxq)

Can someone suggest what the right course of action is? That is, =20
fixing these two may just expose more later... can I build the =20
2.6.32.xx from the OFED kernel tree?

Regards,
Andrew




make -f /usr/src/linux-2.6.32.54-0.3/scripts/Makefile.build obj=3D/var/=
=20
tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/drivers/infiniband/core
   gcc -Wp,-MD,/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/drivers/=20
infiniband/core/.addr.o.d  -nostdinc -isystem /usr/lib64/gcc/x86_64-=20
suse-linux/4.3/include \
-D__OFED_BUILD__ \
-include /lib/modules/2.6.32.54-0.3-default/build/include/linux/=20
autoconf.h \
-include /var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/include/linux/=20
autoconf.h \
-I/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/kernel_addons/backport/=
=20
2.6.32/include/ \
  \
  \
  \
-I/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/include \
-I/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/drivers/infiniband/=20
debug \
-I/usr/local/include/scst \
-I/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/drivers/infiniband/ulp/=
=20
srpt \
  \
  \
-I/usr/src/linux-2.6.32.54-0.3/arch//include \
-Iinclude \
-Iinclude2 -I/usr/src/linux-2.6.32.54-0.3/include \
-I/usr/src/linux-2.6.32.54-0.3/arch/x86/include \
    -I/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/drivers/infiniband/=
=20
core -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -=20
fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -=
=20
Wno-format-security -fno-delete-null-pointer-checks -O2 -m64 -=20
mtune=3Dgeneric -mno-red-zone -mcmodel=3Dkernel -funit-at-a-time -=20
maccumulate-outgoing-args -DCONFIG_AS_CFI=3D1 -=20
DCONFIG_AS_CFI_SIGNAL_FRAME=3D1 -pipe -Wno-sign-compare -mno-sse -mno-=20
mmx -mno-sse2 -mno-3dnow -fno-stack-protector -fomit-frame-pointer -=20
fasynchronous-unwind-tables -g -Wdeclaration-after-statement -Wno-=20
pointer-sign -fno-strict-overflow  -DMODULE -D"KBUILD_STR(s)=3D#s" -=20
D"KBUILD_BASENAME=3DKBUILD_STR(addr)"  -=20
D"KBUILD_MODNAME=3DKBUILD_STR(ib_addr)" -D"DEBUG_HASH=3D45" -=20
D"DEBUG_HASH2=3D52" -c -o /var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1=
/=20
drivers/infiniband/core/.tmp_addr.o /var/tmp/OFED_topdir/BUILD/=20
ofa_kernel-1.5.4.1/drivers/infiniband/core/addr.c
In file included from include2/asm/ds.h:28,
                  from include2/asm/processor.h:24,
                  from /usr/src/linux-2.6.32.54-0.3/include/linux/=20
prefetch.h:14,
                  from /usr/src/linux-2.6.32.54-0.3/include/linux/=20
list.h:6,
                  from /usr/src/linux-2.6.32.54-0.3/include/linux/=20
mutex.h:13,
                  from /var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/=20
drivers/infiniband/core/addr.c:36:
/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/kernel_addons/backport/=20
2.6.32/include/linux/err.h:8: error: redefinition of =20
=82=C4=F2IS_ERR_OR_NULL=82=C4=F4
/usr/src/linux-2.6.32.54-0.3/include/linux/err.h:38: error: previous =20
definition of =82=C4=F2IS_ERR_OR_NULL=82=C4=F4 was here
In file included from /usr/src/linux-2.6.32.54-0.3/include/linux/=20
inetdevice.h:8,
                  from /var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/=20
drivers/infiniband/core/addr.c:37:
/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/kernel_addons/backport/=20
2.6.32/include/linux/netdevice.h:32: error: conflicting types for =20
=82=C4=F2netif_set_real_num_tx_queues=82=C4=F4
/usr/src/linux-2.6.32.54-0.3/include/linux/netdevice.h:1459: error: =20
previous declaration of =82=C4=F2netif_set_real_num_tx_queues=82=C4=F4 =
was here
make[6]: *** [/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/drivers/=20
infiniband/core/addr.o] Error 1
make[5]: *** [/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/drivers/=20
infiniband/core] Error 2
make[4]: *** [/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1/drivers/=20
infiniband] Error 2
make[3]: *** [_module_/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4.1] =20
Error 2
make[2]: *** [sub-make] Error 2
make[1]: *** [all] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.32.54-0.3-obj/x86_64/=20
default'
make: *** [kernel] Error 2
error: Bad exit status from /var/tmp/rpm-tmp.33546 (%build)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
