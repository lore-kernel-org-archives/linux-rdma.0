From: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/28] Broadcom RoCE Driver (bnxt_re)
Date: Wed, 7 Dec 2016 18:33:50 -0500
Message-ID: <a909ae78-ed49-407a-29c7-b86729f356b8@redhat.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
Reply-To: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480919912-1079-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/05/2016 01:38 AM, Selvin Xavier wrote:
> Hi Doug,
> 
> This series introduces the RoCE driver for the Broadcom
> NetXtreme-C/E 10/25/40/50 gigabit RoCE HCAs. This driver
> is dependent on the bnxt_en NIC driver.
> 
> This patch series is based on the "bnxt_re" branch on Doug's
> repository + four pending bnxt_en NIC driver patches that are
> yet to be pulled into net-next tree.
> 
> Please review and consider applying this to linux-rdma repository.
> 
> Thanks,
> Selvin Xavier

Compiling this series seems to have problems...

The fix appears to be:

===
$ git diff
diff --git i/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
w/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
index 9f3960037931..1bd67887a23c 100644
--- i/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
+++ w/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
@@ -19,6 +19,7 @@
 #include <linux/rculist.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
+#include <net/dcbnl.h>
 #include <net/ipv6.h>
 #include <net/addrconf.h>
 ===

jtoppins@jtoppins:~/projects/linux-rhel7$ git log -1 --oneline
net-next/master
25e3e84b183a dummy: expend mtu range for dummy device
jtoppins@jtoppins:~/projects/linux-rhel7$ git merge-base net-next/master
HEAD
25e3e84b183a2c25b1e8303f815a6aa5bf78358a

jtoppins@jtoppins:~/projects/linux-rhel7$ make defconfig
*** Default configuration is based on 'x86_64_defconfig'
#
# configuration written to .config
#
jtoppins@jtoppins:~/projects/linux-rhel7$ make menuconfig
  HOSTCC  scripts/kconfig/mconf.o
  HOSTCC  scripts/kconfig/lxdialog/checklist.o
  HOSTCC  scripts/kconfig/lxdialog/util.o
  HOSTCC  scripts/kconfig/lxdialog/inputbox.o
  HOSTCC  scripts/kconfig/lxdialog/textbox.o
  HOSTCC  scripts/kconfig/lxdialog/yesno.o
  HOSTCC  scripts/kconfig/lxdialog/menubox.o
  HOSTLD  scripts/kconfig/mconf
scripts/kconfig/mconf  Kconfig
configuration written to .config

*** End of the configuration.
*** Execute 'make' to start the build or try 'make help'.

jtoppins@jtoppins:~/projects/linux-rhel7$ grep "BNXTRE" .config
CONFIG_INFINIBAND_BNXTRE=m
jtoppins@jtoppins:~/projects/linux-rhel7$ make
drivers/infiniband/hw/bnxtre/bnxt_re.ko
  SYSTBL  arch/x86/entry/syscalls/../../include/generated/asm/syscalls_32.h
  SYSHDR
arch/x86/entry/syscalls/../../include/generated/asm/unistd_32_ia32.h
  SYSHDR
arch/x86/entry/syscalls/../../include/generated/asm/unistd_64_x32.h
  SYSTBL  arch/x86/entry/syscalls/../../include/generated/asm/syscalls_64.h
  SYSHDR
arch/x86/entry/syscalls/../../include/generated/uapi/asm/unistd_32.h
  SYSHDR
arch/x86/entry/syscalls/../../include/generated/uapi/asm/unistd_64.h
  SYSHDR
arch/x86/entry/syscalls/../../include/generated/uapi/asm/unistd_x32.h
  HOSTCC  arch/x86/tools/relocs_32.o
  HOSTCC  arch/x86/tools/relocs_64.o
  HOSTCC  arch/x86/tools/relocs_common.o
  HOSTLD  arch/x86/tools/relocs
  CHK     include/config/kernel.release
  UPD     include/config/kernel.release
  WRAP    arch/x86/include/generated/asm/clkdev.h
  WRAP    arch/x86/include/generated/asm/cputime.h
  WRAP    arch/x86/include/generated/asm/dma-contiguous.h
  WRAP    arch/x86/include/generated/asm/early_ioremap.h
  WRAP    arch/x86/include/generated/asm/mcs_spinlock.h
  WRAP    arch/x86/include/generated/asm/mm-arch-hooks.h
  CHK     include/generated/uapi/linux/version.h
  UPD     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      kernel/bounds.s
  CHK     include/generated/bounds.h
  UPD     include/generated/bounds.h
  CHK     include/generated/timeconst.h
  UPD     include/generated/timeconst.h
  CC      arch/x86/kernel/asm-offsets.s
  CHK     include/generated/asm-offsets.h
  UPD     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/modpost.o
  CC      scripts/mod/devicetable-offsets.s
  GEN     scripts/mod/devicetable-offsets.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTLD  scripts/mod/modpost
  HOSTCC  scripts/selinux/genheaders/genheaders
  HOSTCC  scripts/selinux/mdp/mdp
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/pnmtologo
  HOSTCC  scripts/conmakehash
  HOSTCC  scripts/sortextable
  CC [M]  drivers/infiniband/hw/bnxtre/bnxt_re_main.o
drivers/infiniband/hw/bnxtre/bnxt_re_main.c: In function
‘bnxt_re_get_priority_mask’:
drivers/infiniband/hw/bnxtre/bnxt_re_main.c:850:17: error: storage size
of ‘app’ isn’t known
  struct dcb_app app;
                 ^
drivers/infiniband/hw/bnxtre/bnxt_re_main.c:855:17: error:
‘IEEE_8021QAZ_APP_SEL_ETHERTYPE’ undeclared (first use in this function)
  app.selector = IEEE_8021QAZ_APP_SEL_ETHERTYPE;
                 ^
drivers/infiniband/hw/bnxtre/bnxt_re_main.c:855:17: note: each
undeclared identifier is reported only once for each function it appears in
drivers/infiniband/hw/bnxtre/bnxt_re_main.c:857:2: error: implicit
declaration of function ‘dcb_ieee_getapp_mask’
[-Werror=implicit-function-declaration]
  tmp_map = dcb_ieee_getapp_mask(netdev, &app);
  ^
drivers/infiniband/hw/bnxtre/bnxt_re_main.c:860:17: error:
‘IEEE_8021QAZ_APP_SEL_DGRAM’ undeclared (first use in this function)
  app.selector = IEEE_8021QAZ_APP_SEL_DGRAM;
                 ^
drivers/infiniband/hw/bnxtre/bnxt_re_main.c:850:17: warning: unused
variable ‘app’ [-Wunused-variable]
  struct dcb_app app;
                 ^
cc1: some warnings being treated as errors
make[1]: *** [drivers/infiniband/hw/bnxtre/bnxt_re_main.o] Error 1
make: *** [drivers/infiniband/hw/bnxtre/bnxt_re.ko] Error 2
jtoppins@jtoppins:~/projects/linux-rhel7$


It seems this is the patch that has the problem:
Author: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Date:   Sun Dec 4 22:38:29 2016 -0800

    bnxt_re: Support for DCB

    This patch queries the configured RoCE APP Priority on the host
    using the dcbnl API and programs the RoCE FW with the corresponding
    Traffic Class(es) for the priority.

Running this also fails:
$ make M=drivers/infiniband/hw/bnxtre bnxt_re.ko
  CC [M]  drivers/infiniband/hw/bnxtre/bnxt_re_main.o
drivers/infiniband/hw/bnxtre/bnxt_re_main.c: In function
‘bnxt_re_get_priority_mask’:
drivers/infiniband/hw/bnxtre/bnxt_re_main.c:850:17: error: storage size
of ‘app’ isn’t known
  struct dcb_app app;
                 ^
drivers/infiniband/hw/bnxtre/bnxt_re_main.c:855:17: error:
‘IEEE_8021QAZ_APP_SEL_ETHERTYPE’ undeclared (first use in this function)
  app.selector = IEEE_8021QAZ_APP_SEL_ETHERTYPE;
                 ^
drivers/infiniband/hw/bnxtre/bnxt_re_main.c:855:17: note: each
undeclared identifier is reported only once for each function it appears in
drivers/infiniband/hw/bnxtre/bnxt_re_main.c:857:2: error: implicit
declaration of function ‘dcb_ieee_getapp_mask’
[-Werror=implicit-function-declaration]
  tmp_map = dcb_ieee_getapp_mask(netdev, &app);
  ^
drivers/infiniband/hw/bnxtre/bnxt_re_main.c:860:17: error:
‘IEEE_8021QAZ_APP_SEL_DGRAM’ undeclared (first use in this function)
  app.selector = IEEE_8021QAZ_APP_SEL_DGRAM;
                 ^
drivers/infiniband/hw/bnxtre/bnxt_re_main.c:850:17: warning: unused
variable ‘app’ [-Wunused-variable]
  struct dcb_app app;
                 ^
cc1: some warnings being treated as errors
make[1]: *** [drivers/infiniband/hw/bnxtre/bnxt_re_main.o] Error 1
make: *** [bnxt_re.ko] Error 2

v2?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
