From: Jeremy Enos <jenos-R3uSp7q5utt4piUD7e9S/g@public.gmane.org>
Subject: fc13 ofed-1.5.2rc5 build error
Date: Tue, 31 Aug 2010 00:40:06 -0500
Message-ID: <4C7C95B6.3020800@ncsa.uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  I don't know if fc13 is being targeted for support or not, but just 
for the sake of looking ahead maybe someone could check this failure 
out.  Early in the build process (ofa_kernel), I get this error:

gcc: cannot specify -o with -c or -S with multiple files

thx-

     Jeremy

In context:
<snip>
-I/usr/src/kernels/2.6.33.8-149.fc13.x86_64/arch/x86/include \
-include 
/lib/modules/2.6.33.8-149.fc13.x86_64/build/include/generated/autoconf.h 
/lib/modules/2.6.33.8-149.fc13.x86_64/build/include/linux/autoconf.h \
  -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs 
-fno-strict-aliasing -fno-common -Werror-implicit-function-declaration 
-Wno-format-security -fno-delete-null-pointer-checks -Os -m64 
-mtune=generic -mno-red-zone -mcmodel=kernel -funit-at-a-time 
-maccumulate-outgoing-args -fstack-protector -DCONFIG_AS_CFI=1 
-DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -pipe 
-Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx 
-mno-sse2 -mno-3dnow -Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(addr)"  
-D"KBUILD_MODNAME=KBUILD_STR(ib_addr)" -D"DEBUG_HASH=44" 
-D"DEBUG_HASH2=11" -c -o 
/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.2/drivers/infiniband/core/addr.o 
/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.2/drivers/infiniband/core/addr.c
gcc: cannot specify -o with -c or -S with multiple files
make[4]: *** 
[/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.2/drivers/infiniband/core/addr.o] 
Error 1
make[3]: *** 
[/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.2/drivers/infiniband/core] 
Error 2
make[2]: *** 
[/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.2/drivers/infiniband] Error 2
make[1]: *** [_module_/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.2] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.33.8-149.fc13.x86_64'
make: *** [kernel] Error 2
error: Bad exit status from /var/tmp/rpm-tmp.aFBxK0 (%build)
</snip>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
