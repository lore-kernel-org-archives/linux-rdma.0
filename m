From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: srp warning
Date: Wed, 12 Jan 2011 11:46:33 -0800
Message-ID: <adaoc7l52hy.fsf@cisco.com>
References: <adalj2q587i.fsf@cisco.com>
	<1294854748.15826.26.camel@lap75545.ornl.gov>
	<ada8vyq57bq.fsf@cisco.com>
	<1294861341.15826.38.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294861341.15826.38.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org> (David Dillow's
	message of "Wed, 12 Jan 2011 14:42:21 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--=-=-=

 > Could you send the contents of drivers/infiniband/ulp/srp/.ib_srp.o.cmd
 > from a build showing the warning? And probably the .config as well -- I
 > suspect we're using different flags as even gcc 4.1.2 seems to be happy
 > for me.

Attached -- I'm using kind of a minimal config for build testing, so
maybe I have some strange optimization enabled (CONFIG_CC_OPTIMIZE_FOR_SIZE=y?)


--=-=-=
Content-Disposition: inline; filename=ib_srp.o.cmd
Content-Transfer-Encoding: quoted-printable

cmd_drivers/infiniband/ulp/srp/ib_srp.o :=3D gcc -Wp,-MD,drivers/infiniband=
/ulp/srp/.ib_srp.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.=
5/include -I/users/rdreier/Ksrc/linux-merge.git/arch/x86/include -Iinclude =
 -I/users/rdreier/Ksrc/linux-merge.git/include -include include/generated/a=
utoconf.h  -I/users/rdreier/Ksrc/linux-merge.git/drivers/infiniband/ulp/srp=
 -Idrivers/infiniband/ulp/srp -D__KERNEL__ -Wall -Wundef -Wstrict-prototype=
s -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function=
-declaration -Wno-format-security -fno-delete-null-pointer-checks -Os -m64 =
-mtune=3Dgeneric -mno-red-zone -mcmodel=3Dkernel -funit-at-a-time -maccumul=
ate-outgoing-args -DCONFIG_AS_CFI=3D1 -DCONFIG_AS_CFI_SIGNAL_FRAME=3D1 -DCO=
NFIG_AS_CFI_SECTIONS=3D1 -DCONFIG_AS_FXSAVEQ=3D1 -pipe -Wno-sign-compare -f=
no-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -Wfram=
e-larger-than=3D2048 -fno-stack-protector -fno-omit-frame-pointer -fno-opti=
mize-sibling-calls -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-=
strict-overflow -fconserve-stack    -D"KBUILD_STR(s)=3D\#s" -D"KBUILD_BASEN=
AME=3DKBUILD_STR(ib_srp)"  -D"KBUILD_MODNAME=3DKBUILD_STR(ib_srp)" -c -o dr=
ivers/infiniband/ulp/srp/.tmp_ib_srp.o /users/rdreier/Ksrc/linux-merge.git/=
drivers/infiniband/ulp/srp/ib_srp.c

deps_drivers/infiniband/ulp/srp/ib_srp.o :=3D \
  /users/rdreier/Ksrc/linux-merge.git/drivers/infiniband/ulp/srp/ib_srp.c \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/module.h \
    $(wildcard include/config/symbol/prefix.h) \
    $(wildcard include/config/modules.h) \
    $(wildcard include/config/modversions.h) \
    $(wildcard include/config/unused/symbols.h) \
    $(wildcard include/config/generic/bug.h) \
    $(wildcard include/config/kallsyms.h) \
    $(wildcard include/config/smp.h) \
    $(wildcard include/config/tracepoints.h) \
    $(wildcard include/config/tracing.h) \
    $(wildcard include/config/event/tracing.h) \
    $(wildcard include/config/ftrace/mcount/record.h) \
    $(wildcard include/config/module/unload.h) \
    $(wildcard include/config/constructors.h) \
    $(wildcard include/config/sysfs.h) \
    $(wildcard include/config/debug/set/module/ronx.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/list.h \
    $(wildcard include/config/debug/list.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/types.h \
    $(wildcard include/config/uid16.h) \
    $(wildcard include/config/lbdaf.h) \
    $(wildcard include/config/phys/addr/t/64bit.h) \
    $(wildcard include/config/64bit.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/types.h \
    $(wildcard include/config/x86/64.h) \
    $(wildcard include/config/highmem64g.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/types.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/int-ll64.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/bitsperlong.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/bitsperlong.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/posix_types.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/stddef.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/compiler.h \
    $(wildcard include/config/sparse/rcu/pointer.h) \
    $(wildcard include/config/trace/branch/profiling.h) \
    $(wildcard include/config/profile/all/branches.h) \
    $(wildcard include/config/enable/must/check.h) \
    $(wildcard include/config/enable/warn/deprecated.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/compiler-gcc.h \
    $(wildcard include/config/arch/supports/optimized/inlining.h) \
    $(wildcard include/config/optimize/inlining.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/compiler-gcc4.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/posix_types.h \
    $(wildcard include/config/x86/32.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/posix_types_64.h=
 \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/poison.h \
    $(wildcard include/config/illegal/pointer/value.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/prefetch.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/processor.h \
    $(wildcard include/config/x86/vsmp.h) \
    $(wildcard include/config/cc/stackprotector.h) \
    $(wildcard include/config/paravirt.h) \
    $(wildcard include/config/m386.h) \
    $(wildcard include/config/m486.h) \
    $(wildcard include/config/x86/debugctlmsr.h) \
    $(wildcard include/config/cpu/sup/amd.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/processor-flags.=
h \
    $(wildcard include/config/vm86.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/vm86.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/ptrace.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/ptrace-abi.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/segment.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/cache.h \
    $(wildcard include/config/x86/l1/cache/shift.h) \
    $(wildcard include/config/x86/internode/cache/shift.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/linkage.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/linkage.h \
    $(wildcard include/config/x86/alignment/16.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/stringify.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/page_types.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/const.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/page_64_types.h \
    $(wildcard include/config/physical/start.h) \
    $(wildcard include/config/physical/align.h) \
    $(wildcard include/config/flatmem.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/init.h \
    $(wildcard include/config/hotplug.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/math_emu.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/sigcontext.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/current.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/percpu.h \
    $(wildcard include/config/x86/64/smp.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/kernel.h \
    $(wildcard include/config/preempt/voluntary.h) \
    $(wildcard include/config/debug/spinlock/sleep.h) \
    $(wildcard include/config/prove/locking.h) \
    $(wildcard include/config/ring/buffer.h) \
    $(wildcard include/config/numa.h) \
  /usr/lib/gcc/x86_64-linux-gnu/4.4.5/include/stdarg.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/bitops.h \
    $(wildcard include/config/generic/find/last/bit.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/bitops.h \
    $(wildcard include/config/x86/cmov.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/alternative.h \
    $(wildcard include/config/dynamic/ftrace.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/jump_label.h \
    $(wildcard include/config/jump/label.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/asm.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/cpufeature.h \
    $(wildcard include/config/x86/invlpg.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/required-feature=
s.h \
    $(wildcard include/config/x86/minimum/cpu/family.h) \
    $(wildcard include/config/math/emulation.h) \
    $(wildcard include/config/x86/pae.h) \
    $(wildcard include/config/x86/cmpxchg64.h) \
    $(wildcard include/config/x86/use/3dnow.h) \
    $(wildcard include/config/x86/p6/nop.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/bitops/find.h \
    $(wildcard include/config/generic/find/first/bit.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/bitops/sched.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/arch_hweight.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/bitops/const_hwei=
ght.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/bitops/fls64.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/bitops/ext2-non-a=
tomic.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/bitops/le.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/byteorder.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/byteorder/little_endian=
.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/swab.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/swab.h \
    $(wildcard include/config/x86/bswap.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/byteorder/generic.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/bitops/minix.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/log2.h \
    $(wildcard include/config/arch/has/ilog2/u32.h) \
    $(wildcard include/config/arch/has/ilog2/u64.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/typecheck.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/printk.h \
    $(wildcard include/config/printk.h) \
    $(wildcard include/config/dynamic/debug.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/dynamic_debug.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/bug.h \
    $(wildcard include/config/bug.h) \
    $(wildcard include/config/debug/bugverbose.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/bug.h \
    $(wildcard include/config/generic/bug/relative/pointers.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/percpu.h \
    $(wildcard include/config/debug/preempt.h) \
    $(wildcard include/config/have/setup/per/cpu/area.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/threads.h \
    $(wildcard include/config/nr/cpus.h) \
    $(wildcard include/config/base/small.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/percpu-defs.h \
    $(wildcard include/config/debug/force/weak/per/cpu.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/system.h \
    $(wildcard include/config/ia32/emulation.h) \
    $(wildcard include/config/x86/32/lazy/gs.h) \
    $(wildcard include/config/x86/ppro/fence.h) \
    $(wildcard include/config/x86/oostore.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/cmpxchg.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/cmpxchg_64.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/nops.h \
    $(wildcard include/config/mk7.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/irqflags.h \
    $(wildcard include/config/trace/irqflags.h) \
    $(wildcard include/config/irqsoff/tracer.h) \
    $(wildcard include/config/preempt/tracer.h) \
    $(wildcard include/config/trace/irqflags/support.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/irqflags.h \
    $(wildcard include/config/debug/lock/alloc.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/page.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/page_64.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/memory_model.h \
    $(wildcard include/config/discontigmem.h) \
    $(wildcard include/config/sparsemem/vmemmap.h) \
    $(wildcard include/config/sparsemem.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/getorder.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/pgtable_types.h \
    $(wildcard include/config/kmemcheck.h) \
    $(wildcard include/config/compat/vdso.h) \
    $(wildcard include/config/proc/fs.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/pgtable_64_types=
.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/msr.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/msr-index.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/ioctl.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/ioctl.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/ioctl.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/errno.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/errno.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/errno-base.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/cpumask.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/cpumask.h \
    $(wildcard include/config/cpumask/offstack.h) \
    $(wildcard include/config/hotplug/cpu.h) \
    $(wildcard include/config/debug/per/cpu/maps.h) \
    $(wildcard include/config/disable/obsolete/cpumask/functions.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/bitmap.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/string.h \
    $(wildcard include/config/binary/printf.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/string.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/string_64.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/errno.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/desc_defs.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/personality.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/cache.h \
    $(wildcard include/config/arch/has/cache/line/size.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/math64.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/div64.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/div64.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/err.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/stat.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/stat.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/time.h \
    $(wildcard include/config/arch/uses/gettimeoffset.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/seqlock.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/spinlock.h \
    $(wildcard include/config/debug/spinlock.h) \
    $(wildcard include/config/generic/lockbreak.h) \
    $(wildcard include/config/preempt.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/preempt.h \
    $(wildcard include/config/preempt/notifiers.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/thread_info.h \
    $(wildcard include/config/compat.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/thread_info.h \
    $(wildcard include/config/debug/stack/usage.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/ftrace.h \
    $(wildcard include/config/function/tracer.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/atomic.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/atomic64_64.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/atomic-long.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/bottom_half.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/spinlock_types.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/spinlock_types.h=
 \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/lockdep.h \
    $(wildcard include/config/lockdep.h) \
    $(wildcard include/config/lock/stat.h) \
    $(wildcard include/config/prove/rcu.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/rwlock_types.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/spinlock.h \
    $(wildcard include/config/paravirt/spinlocks.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/rwlock.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/paravirt.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/rwlock.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/spinlock_api_smp.h \
    $(wildcard include/config/inline/spin/lock.h) \
    $(wildcard include/config/inline/spin/lock/bh.h) \
    $(wildcard include/config/inline/spin/lock/irq.h) \
    $(wildcard include/config/inline/spin/lock/irqsave.h) \
    $(wildcard include/config/inline/spin/trylock.h) \
    $(wildcard include/config/inline/spin/trylock/bh.h) \
    $(wildcard include/config/inline/spin/unlock.h) \
    $(wildcard include/config/inline/spin/unlock/bh.h) \
    $(wildcard include/config/inline/spin/unlock/irq.h) \
    $(wildcard include/config/inline/spin/unlock/irqrestore.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/rwlock_api_smp.h \
    $(wildcard include/config/inline/read/lock.h) \
    $(wildcard include/config/inline/write/lock.h) \
    $(wildcard include/config/inline/read/lock/bh.h) \
    $(wildcard include/config/inline/write/lock/bh.h) \
    $(wildcard include/config/inline/read/lock/irq.h) \
    $(wildcard include/config/inline/write/lock/irq.h) \
    $(wildcard include/config/inline/read/lock/irqsave.h) \
    $(wildcard include/config/inline/write/lock/irqsave.h) \
    $(wildcard include/config/inline/read/trylock.h) \
    $(wildcard include/config/inline/write/trylock.h) \
    $(wildcard include/config/inline/read/unlock.h) \
    $(wildcard include/config/inline/write/unlock.h) \
    $(wildcard include/config/inline/read/unlock/bh.h) \
    $(wildcard include/config/inline/write/unlock/bh.h) \
    $(wildcard include/config/inline/read/unlock/irq.h) \
    $(wildcard include/config/inline/write/unlock/irq.h) \
    $(wildcard include/config/inline/read/unlock/irqrestore.h) \
    $(wildcard include/config/inline/write/unlock/irqrestore.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/kmod.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/gfp.h \
    $(wildcard include/config/highmem.h) \
    $(wildcard include/config/zone/dma.h) \
    $(wildcard include/config/zone/dma32.h) \
    $(wildcard include/config/debug/vm.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/mmzone.h \
    $(wildcard include/config/force/max/zoneorder.h) \
    $(wildcard include/config/memory/hotplug.h) \
    $(wildcard include/config/compaction.h) \
    $(wildcard include/config/arch/populates/node/map.h) \
    $(wildcard include/config/flat/node/mem/map.h) \
    $(wildcard include/config/cgroup/mem/res/ctlr.h) \
    $(wildcard include/config/no/bootmem.h) \
    $(wildcard include/config/have/memory/present.h) \
    $(wildcard include/config/have/memoryless/nodes.h) \
    $(wildcard include/config/need/node/memmap/size.h) \
    $(wildcard include/config/need/multiple/nodes.h) \
    $(wildcard include/config/have/arch/early/pfn/to/nid.h) \
    $(wildcard include/config/sparsemem/extreme.h) \
    $(wildcard include/config/nodes/span/other/nodes.h) \
    $(wildcard include/config/holes/in/zone.h) \
    $(wildcard include/config/arch/has/holes/memorymodel.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/wait.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/numa.h \
    $(wildcard include/config/nodes/shift.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/nodemask.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/pageblock-flags.h \
    $(wildcard include/config/hugetlb/page.h) \
    $(wildcard include/config/hugetlb/page/size/variable.h) \
  include/generated/bounds.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/memory_hotplug.h \
    $(wildcard include/config/memory/hotremove.h) \
    $(wildcard include/config/have/arch/nodedata/extension.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/notifier.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/mutex.h \
    $(wildcard include/config/debug/mutexes.h) \
    $(wildcard include/config/have/arch/mutex/cpu/relax.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/rwsem.h \
    $(wildcard include/config/rwsem/generic/spinlock.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/rwsem.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/srcu.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/sparsemem.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/topology.h \
    $(wildcard include/config/sched/smt.h) \
    $(wildcard include/config/sched/mc.h) \
    $(wildcard include/config/sched/book.h) \
    $(wildcard include/config/use/percpu/numa/node/id.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/smp.h \
    $(wildcard include/config/use/generic/smp/helpers.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/smp.h \
    $(wildcard include/config/x86/local/apic.h) \
    $(wildcard include/config/x86/io/apic.h) \
    $(wildcard include/config/x86/32/smp.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/mpspec.h \
    $(wildcard include/config/x86/numaq.h) \
    $(wildcard include/config/mca.h) \
    $(wildcard include/config/eisa.h) \
    $(wildcard include/config/x86/mpparse.h) \
    $(wildcard include/config/acpi.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/mpspec_def.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/x86_init.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/bootparam.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/screen_info.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/apm_bios.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/edd.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/e820.h \
    $(wildcard include/config/efi.h) \
    $(wildcard include/config/intel/txt.h) \
    $(wildcard include/config/hibernation.h) \
    $(wildcard include/config/memtest.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/ioport.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/ist.h \
  /users/rdreier/Ksrc/linux-merge.git/include/video/edid.h \
    $(wildcard include/config/x86.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/apicdef.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/apic.h \
    $(wildcard include/config/x86/x2apic.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/delay.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/delay.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/pm.h \
    $(wildcard include/config/pm.h) \
    $(wildcard include/config/pm/sleep.h) \
    $(wildcard include/config/pm/runtime.h) \
    $(wildcard include/config/pm/ops.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/workqueue.h \
    $(wildcard include/config/debug/objects/work.h) \
    $(wildcard include/config/freezer.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/timer.h \
    $(wildcard include/config/timer/stats.h) \
    $(wildcard include/config/debug/objects/timers.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/ktime.h \
    $(wildcard include/config/ktime/scalar.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/jiffies.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/timex.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/param.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/param.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/param.h \
    $(wildcard include/config/hz.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/timex.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/tsc.h \
    $(wildcard include/config/x86/tsc.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/debugobjects.h \
    $(wildcard include/config/debug/objects.h) \
    $(wildcard include/config/debug/objects/free.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/completion.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/fixmap.h \
    $(wildcard include/config/provide/ohci1394/dma/init.h) \
    $(wildcard include/config/x86/visws/apic.h) \
    $(wildcard include/config/x86/f00f/bug.h) \
    $(wildcard include/config/x86/cyclone/timer.h) \
    $(wildcard include/config/pci/mmconfig.h) \
    $(wildcard include/config/x86/mrst.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/acpi.h \
    $(wildcard include/config/acpi/numa.h) \
    $(wildcard include/config/numa/emu.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/acpi/pdc_intel.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/numa.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/numa_64.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/mmu.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/vsyscall.h \
    $(wildcard include/config/generic/time.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/io_apic.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/irq_vectors.h \
    $(wildcard include/config/sparse/irq.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/percpu.h \
    $(wildcard include/config/need/per/cpu/embed/first/chunk.h) \
    $(wildcard include/config/need/per/cpu/page/first/chunk.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/pfn.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/topology.h \
    $(wildcard include/config/x86/ht.h) \
    $(wildcard include/config/x86/64/acpi/numa.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/topology.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/mmdebug.h \
    $(wildcard include/config/debug/virtual.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/elf.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/elf-em.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/elf.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/user.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/user_64.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/auxvec.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/vdso.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/kobject.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/sysfs.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/kobject_ns.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/kref.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/moduleparam.h \
    $(wildcard include/config/alpha.h) \
    $(wildcard include/config/ia64.h) \
    $(wildcard include/config/ppc64.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/tracepoint.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/rcupdate.h \
    $(wildcard include/config/rcu/torture/test.h) \
    $(wildcard include/config/preempt/rcu.h) \
    $(wildcard include/config/no/hz.h) \
    $(wildcard include/config/tree/rcu.h) \
    $(wildcard include/config/tree/preempt/rcu.h) \
    $(wildcard include/config/tiny/rcu.h) \
    $(wildcard include/config/tiny/preempt/rcu.h) \
    $(wildcard include/config/debug/objects/rcu/head.h) \
    $(wildcard include/config/preempt/rt.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/rcutree.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/module.h \
    $(wildcard include/config/m586.h) \
    $(wildcard include/config/m586tsc.h) \
    $(wildcard include/config/m586mmx.h) \
    $(wildcard include/config/mcore2.h) \
    $(wildcard include/config/matom.h) \
    $(wildcard include/config/m686.h) \
    $(wildcard include/config/mpentiumii.h) \
    $(wildcard include/config/mpentiumiii.h) \
    $(wildcard include/config/mpentiumm.h) \
    $(wildcard include/config/mpentium4.h) \
    $(wildcard include/config/mk6.h) \
    $(wildcard include/config/mk8.h) \
    $(wildcard include/config/x86/elan.h) \
    $(wildcard include/config/mcrusoe.h) \
    $(wildcard include/config/mefficeon.h) \
    $(wildcard include/config/mwinchipc6.h) \
    $(wildcard include/config/mwinchip3d.h) \
    $(wildcard include/config/mcyrixiii.h) \
    $(wildcard include/config/mviac3/2.h) \
    $(wildcard include/config/mviac7.h) \
    $(wildcard include/config/mgeodegx1.h) \
    $(wildcard include/config/mgeode/lx.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/module.h \
  /users/rdreier/Ksrc/linux-merge.git/include/trace/events/module.h \
  /users/rdreier/Ksrc/linux-merge.git/include/trace/define_trace.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/slab.h \
    $(wildcard include/config/slab/debug.h) \
    $(wildcard include/config/failslab.h) \
    $(wildcard include/config/slub.h) \
    $(wildcard include/config/slob.h) \
    $(wildcard include/config/debug/slab.h) \
    $(wildcard include/config/slab.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/slub_def.h \
    $(wildcard include/config/slub/stats.h) \
    $(wildcard include/config/slub/debug.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/kmemleak.h \
    $(wildcard include/config/debug/kmemleak.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/parser.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/random.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/irqnr.h \
    $(wildcard include/config/generic/hardirqs.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/scsi/scsi.h \
  /users/rdreier/Ksrc/linux-merge.git/include/scsi/scsi_device.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/device.h \
    $(wildcard include/config/of.h) \
    $(wildcard include/config/debug/devres.h) \
    $(wildcard include/config/devtmpfs.h) \
    $(wildcard include/config/sysfs/deprecated.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/klist.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/device.h \
    $(wildcard include/config/dmar.h) \
    $(wildcard include/config/amd/iommu.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/pm_wakeup.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/blkdev.h \
    $(wildcard include/config/block.h) \
    $(wildcard include/config/blk/cgroup.h) \
    $(wildcard include/config/blk/dev/integrity.h) \
    $(wildcard include/config/blk/dev/io/trace.h) \
    $(wildcard include/config/blk/dev/bsg.h) \
    $(wildcard include/config/blk/dev/throttling.h) \
    $(wildcard include/config/bounce.h) \
    $(wildcard include/config/mmu.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/sched.h \
    $(wildcard include/config/sched/debug.h) \
    $(wildcard include/config/lockup/detector.h) \
    $(wildcard include/config/detect/hung/task.h) \
    $(wildcard include/config/core/dump/default/elf/headers.h) \
    $(wildcard include/config/sched/autogroup.h) \
    $(wildcard include/config/virt/cpu/accounting.h) \
    $(wildcard include/config/bsd/process/acct.h) \
    $(wildcard include/config/taskstats.h) \
    $(wildcard include/config/audit.h) \
    $(wildcard include/config/inotify/user.h) \
    $(wildcard include/config/fanotify.h) \
    $(wildcard include/config/epoll.h) \
    $(wildcard include/config/posix/mqueue.h) \
    $(wildcard include/config/keys.h) \
    $(wildcard include/config/perf/events.h) \
    $(wildcard include/config/schedstats.h) \
    $(wildcard include/config/task/delay/acct.h) \
    $(wildcard include/config/fair/group/sched.h) \
    $(wildcard include/config/rt/group/sched.h) \
    $(wildcard include/config/rcu/boost.h) \
    $(wildcard include/config/sysvipc.h) \
    $(wildcard include/config/auditsyscall.h) \
    $(wildcard include/config/rt/mutexes.h) \
    $(wildcard include/config/task/xacct.h) \
    $(wildcard include/config/cpusets.h) \
    $(wildcard include/config/cgroups.h) \
    $(wildcard include/config/futex.h) \
    $(wildcard include/config/fault/injection.h) \
    $(wildcard include/config/latencytop.h) \
    $(wildcard include/config/function/graph/tracer.h) \
    $(wildcard include/config/have/unstable/sched/clock.h) \
    $(wildcard include/config/irq/time/accounting.h) \
    $(wildcard include/config/stack/growsup.h) \
    $(wildcard include/config/cgroup/sched.h) \
    $(wildcard include/config/mm/owner.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/capability.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/rbtree.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/mm_types.h \
    $(wildcard include/config/split/ptlock/cpus.h) \
    $(wildcard include/config/want/page/debug/flags.h) \
    $(wildcard include/config/aio.h) \
    $(wildcard include/config/mmu/notifier.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/auxvec.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/prio_tree.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/page-debug-flags.h \
    $(wildcard include/config/page/poisoning.h) \
    $(wildcard include/config/page/debug/something/else.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/cputime.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/cputime.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/sem.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/ipc.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/ipcbuf.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/ipcbuf.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/sembuf.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/signal.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/signal.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/signal-defs.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/siginfo.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/siginfo.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/pid.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/proportions.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/percpu_counter.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/seccomp.h \
    $(wildcard include/config/seccomp.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/rculist.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/rtmutex.h \
    $(wildcard include/config/debug/rt/mutexes.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/plist.h \
    $(wildcard include/config/debug/pi/list.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/resource.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/resource.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/resource.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/hrtimer.h \
    $(wildcard include/config/high/res/timers.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/timerqueue.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/task_io_accounting.h \
    $(wildcard include/config/task/io/accounting.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/latencytop.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/cred.h \
    $(wildcard include/config/debug/credentials.h) \
    $(wildcard include/config/security.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/key.h \
    $(wildcard include/config/sysctl.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/sysctl.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/selinux.h \
    $(wildcard include/config/security/selinux.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/aio.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/aio_abi.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/uio.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/major.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/genhd.h \
    $(wildcard include/config/fail/make/request.h) \
    $(wildcard include/config/solaris/x86/partition.h) \
    $(wildcard include/config/bsd/disklabel.h) \
    $(wildcard include/config/unixware/disklabel.h) \
    $(wildcard include/config/minix/subpartition.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/kdev_t.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/fs.h \
    $(wildcard include/config/quota.h) \
    $(wildcard include/config/fsnotify.h) \
    $(wildcard include/config/ima.h) \
    $(wildcard include/config/fs/posix/acl.h) \
    $(wildcard include/config/debug/writecount.h) \
    $(wildcard include/config/file/locking.h) \
    $(wildcard include/config/fs/xip.h) \
    $(wildcard include/config/migration.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/limits.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/blk_types.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/dcache.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/rculist_bl.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/list_bl.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/path.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/radix-tree.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/semaphore.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/fiemap.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/quota.h \
    $(wildcard include/config/quota/netlink/interface.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/dqblk_xfs.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/dqblk_v1.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/dqblk_v2.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/dqblk_qtree.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/nfs_fs_i.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/nfs.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/sunrpc/msg_prot.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/inet.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/fcntl.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/fcntl.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/fcntl.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/pagemap.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/mm.h \
    $(wildcard include/config/ksm.h) \
    $(wildcard include/config/debug/pagealloc.h) \
    $(wildcard include/config/memory/failure.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/debug_locks.h \
    $(wildcard include/config/debug/locking/api/selftests.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/range.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/pgtable.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/pgtable_64.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/pgtable_64_types=
.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/pgtable.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/page-flags.h \
    $(wildcard include/config/pageflags/extended.h) \
    $(wildcard include/config/arch/uses/pg/uncached.h) \
    $(wildcard include/config/swap.h) \
    $(wildcard include/config/s390.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/vmstat.h \
    $(wildcard include/config/vm/event/counters.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/highmem.h \
    $(wildcard include/config/debug/highmem.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/uaccess.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/uaccess.h \
    $(wildcard include/config/x86/wp/works/ok.h) \
    $(wildcard include/config/x86/intel/usercopy.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/uaccess_64.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/hardirq.h \
    $(wildcard include/config/bkl.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/ftrace_irq.h \
    $(wildcard include/config/ftrace/nmi/enter.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/hardirq.h \
    $(wildcard include/config/x86/thermal/vector.h) \
    $(wildcard include/config/x86/mce/threshold.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/irq.h \
    $(wildcard include/config/irq/per/cpu.h) \
    $(wildcard include/config/generic/hardirqs/no/deprecated.h) \
    $(wildcard include/config/irq/release/method.h) \
    $(wildcard include/config/generic/pending/irq.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/irqreturn.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/irq.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/irq_regs.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/irqdesc.h \
    $(wildcard include/config/generic/hardirqs/no//do/irq.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/hw_irq.h \
    $(wildcard include/config/intr/remap.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/profile.h \
    $(wildcard include/config/profiling.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/sections.h \
    $(wildcard include/config/debug/rodata.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/sections.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/cacheflush.h \
    $(wildcard include/config/x86/pat.h) \
    $(wildcard include/config/debug/rodata/test.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/kmap_types.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/kmap_types.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/hugetlb_inline.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/backing-dev.h \
    $(wildcard include/config/debug/fs.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/writeback.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/mempool.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/bio.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/ioprio.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/iocontext.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/io.h \
    $(wildcard include/config/xen.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/xen/xen.h \
    $(wildcard include/config/xen/dom0.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/iomap.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/vmalloc.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/bsg.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/scatterlist.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/scatterlist.h \
    $(wildcard include/config/debug/sg.h) \
    $(wildcard include/config/need/sg/dma/length.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/elevator.h \
  /users/rdreier/Ksrc/linux-merge.git/include/scsi/scsi_dbg.h \
  /users/rdreier/Ksrc/linux-merge.git/include/scsi/srp.h \
  /users/rdreier/Ksrc/linux-merge.git/include/scsi/scsi_transport_srp.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/transport_class.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/attribute_container.h \
  /users/rdreier/Ksrc/linux-merge.git/drivers/infiniband/ulp/srp/ib_srp.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/scatterlist.h \
  /users/rdreier/Ksrc/linux-merge.git/include/scsi/scsi_host.h \
  /users/rdreier/Ksrc/linux-merge.git/include/scsi/scsi_cmnd.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/dma-mapping.h \
    $(wildcard include/config/has/dma.h) \
    $(wildcard include/config/have/dma/attrs.h) \
    $(wildcard include/config/need/dma/map/state.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/dma-attrs.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/bug.h \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/dma-mapping.h \
    $(wildcard include/config/isa.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/kmemcheck.h \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/dma-debug.h \
    $(wildcard include/config/dma/api/debug.h) \
  /users/rdreier/Ksrc/linux-merge.git/arch/x86/include/asm/swiotlb.h \
    $(wildcard include/config/swiotlb.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/linux/swiotlb.h \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/dma-coherent.h \
    $(wildcard include/config/have/generic/dma/coherent.h) \
  /users/rdreier/Ksrc/linux-merge.git/include/asm-generic/dma-mapping-commo=
n.h \
  /users/rdreier/Ksrc/linux-merge.git/include/rdma/ib_verbs.h \
  /users/rdreier/Ksrc/linux-merge.git/include/rdma/ib_sa.h \
  /users/rdreier/Ksrc/linux-merge.git/include/rdma/ib_mad.h \
  /users/rdreier/Ksrc/linux-merge.git/include/rdma/ib_cm.h \
  /users/rdreier/Ksrc/linux-merge.git/include/rdma/ib_fmr_pool.h \

drivers/infiniband/ulp/srp/ib_srp.o: $(deps_drivers/infiniband/ulp/srp/ib_s=
rp.o)

$(deps_drivers/infiniband/ulp/srp/ib_srp.o):

--=-=-=
Content-Disposition: inline; filename=.config

#
# Automatically generated make config: don't edit
# Linux/x86_64 2.6.37 Kernel Configuration
# Wed Jan 12 09:27:03 2011
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
# CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED is not set
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
# CONFIG_AUTO_IRQ_AFFINITY is not set
# CONFIG_IRQ_PER_CPU is not set
# CONFIG_HARDIRQS_SW_RESEND is not set
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_SRCU_SYNCHRONIZE_DELAY=10
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=15
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y

#
# GCOV-based kernel profiling
#
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_INLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
# CONFIG_ACPI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
# CONFIG_BINFMT_ELF is not set
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
# CONFIG_UNIX is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
CONFIG_RDS=y
CONFIG_RDS_RDMA=y
CONFIG_RDS_TCP=y
CONFIG_RDS_DEBUG=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=y
CONFIG_XPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
CONFIG_SCSI_CXGB3_ISCSI=m
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_ARCNET is not set
# CONFIG_MII is not set
# CONFIG_PHYLIB is not set
# CONFIG_NET_ETHERNET is not set
# CONFIG_NETDEV_1000 is not set
CONFIG_NETDEV_10000=y
CONFIG_MDIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3_DEPENDS=y
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4_DEPENDS=y
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF_DEPENDS=y
CONFIG_CHELSIO_T4VF=y
CONFIG_ENIC=y
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
CONFIG_MLX4_EN=y
CONFIG_MLX4_CORE=y
# CONFIG_MLX4_DEBUG is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_BNA is not set
# CONFIG_SFC is not set
# CONFIG_BE2NET is not set
# CONFIG_TR is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set

#
# CAIF transport drivers
#
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
# CONFIG_I2C is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
# CONFIG_MFD_SUPPORT is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
# CONFIG_HID is not set
# CONFIG_HID_PID is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set

#
# Enable Host or Gadget support to see Inventra options
#

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=y
CONFIG_INFINIBAND_QIB=y
CONFIG_INFINIBAND_AMSO1100=y
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_INFINIBAND_CXGB3=y
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_INFINIBAND_CXGB4=y
CONFIG_MLX4_INFINIBAND=y
CONFIG_INFINIBAND_NES=y
CONFIG_INFINIBAND_NES_DEBUG=y
CONFIG_INFINIBAND_IPOIB=y
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=y
CONFIG_INFINIBAND_ISER=y
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_IBM_RTL is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
CONFIG_NFSD=y
CONFIG_NFSD_DEPRECATED=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_XPRT_RDMA=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_NLS is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
CONFIG_BKL=y
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_ENABLE_DEFAULT_TRACERS is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_VHOST_NET is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
# CONFIG_CRC32 is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--=-=-=--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
