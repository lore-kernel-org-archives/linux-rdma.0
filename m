From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Fri, 18 Nov 2011 02:33:08 +0000 (GMT)
Message-ID: <1321583588.51148.YahooMailNeo@web24711.mail.ird.yahoo.com>
References: <20111117.164941.2104520709167256016.davem@davemloft.net> <CAL1RGDV_AwOOnLvWJKGqBTaptetfVN_gXNG=PcaFUXYSXrQ5AA@mail.gmail.com> <20111117.210316.83327515715765011.davem@davemloft.net> <20111117.212847.1778246801048496855.davem@davemloft.net>
Reply-To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111117.212847.1778246801048496855.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> wrote:

> Can someone with the effected hardware please test this?
>=20
> --------------------
> [PATCH] sparc: Kill custom io_remap_pfn_range().
>=20
> To handle the large physical addresses, just make a simple wrapper
> around remap_pfn_range() like MIPS does.
>=20
> Signed-off-by: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
> ---
> arch/sparc/include/asm/pgtable_32.h |=A0  20 ++++-
> arch/sparc/include/asm/pgtable_64.h |=A0  20 ++++-
> arch/sparc/mm/Makefile=A0 =A0 =A0 =A0 =A0 =A0 =A0 |=A0 =A0 1 -
> arch/sparc/mm/generic_32.c=A0 =A0 =A0 =A0 =A0 |=A0  99 --------------=
-------
> arch/sparc/mm/generic_64.c=A0 =A0 =A0 =A0 =A0 |=A0 165 --------------=
---------------------
> 5 files changed, 32 insertions(+), 273 deletions(-)
> delete mode 100644 arch/sparc/mm/generic_32.c
> delete mode 100644 arch/sparc/mm/generic_64.c
>=20
> diff --git a/arch/sparc/include/asm/pgtable_32.h=20
> b/arch/sparc/include/asm/pgtable_32.h
> index 5b31a8e..a790cc6 100644
> --- a/arch/sparc/include/asm/pgtable_32.h
> +++ b/arch/sparc/include/asm/pgtable_32.h
> @@ -431,10 +431,6 @@ extern unsigned long *sparc_valid_addr_bitmap;
> #define kern_addr_valid(addr) \
> =A0=A0=A0 (test_bit(__pa((unsigned long)(addr))>>20, sparc_valid_addr=
_bitmap))
>=20
> -extern int io_remap_pfn_range(struct vm_area_struct *vma,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 =A0 unsigned long from, unsign=
ed long pfn,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 =A0 unsigned long size, pgprot=
_t prot);
> -
> /*
> =A0 * For sparc32&64, the pfn in io_remap_pfn_range() carries <iospac=
e>=20
> in
> =A0 * its high 4 bits.=A0 These macros/functions put it there or get =
it from there.
> @@ -443,6 +439,22 @@ extern int io_remap_pfn_range(struct vm_area_str=
uct *vma,
> #define GET_IOSPACE(pfn)=A0=A0=A0 =A0=A0=A0 (pfn >> (BITS_PER_LONG - =
4))
> #define GET_PFN(pfn)=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 (pfn & 0x0fffffffUL=
)
>=20
> +extern int remap_pfn_range(struct vm_area_struct *, unsigned long, u=
nsigned=20
> long,
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  unsigned long, pgprot_t);
> +
> +static inline int io_remap_pfn_range(struct vm_area_struct *vma,
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0  unsigned long from,=
 unsigned long pfn,
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0  unsigned long size,=
 pgprot_t prot)
> +{
> +=A0=A0=A0 unsigned long long offset, space, phys_base;
> +
> +=A0=A0=A0 offset =3D ((unsigned long long) GET_PFN(pfn)) << PAGE_SHI=
=46T;
> +=A0=A0=A0 space =3D GET_IOSPACE(pfn);
> +=A0=A0=A0 phys_base =3D offset | (space << 32ULL);
> +
> +=A0=A0=A0 return remap_pfn_range(vma, from, phys_base >> PAGE_SHIFT,=
 size,=20
> prot);
> +}
> +
> #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
> #define ptep_set_access_flags(__vma, __address, __ptep, __entry, __di=
rty) \
> ({=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0=
 =A0=A0=A0 =A0=A0=A0 =A0 \
> diff --git a/arch/sparc/include/asm/pgtable_64.h=20
> b/arch/sparc/include/asm/pgtable_64.h
> index adf8932..38ebb2c 100644
> --- a/arch/sparc/include/asm/pgtable_64.h
> +++ b/arch/sparc/include/asm/pgtable_64.h
> @@ -757,10 +757,6 @@ static inline bool kern_addr_valid(unsigned long=
 addr)
>=20
> extern int page_in_phys_avail(unsigned long paddr);
>=20
> -extern int io_remap_pfn_range(struct vm_area_struct *vma, unsigned l=
ong from,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 =A0  unsigned long pfn,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 =A0  unsigned long size, pgpro=
t_t prot);
> -
> /*
> =A0 * For sparc32&64, the pfn in io_remap_pfn_range() carries <iospac=
e>=20
> in
> =A0 * its high 4 bits.=A0 These macros/functions put it there or get =
it from there.
> @@ -769,6 +765,22 @@ extern int io_remap_pfn_range(struct vm_area_str=
uct *vma,=20
> unsigned long from,
> #define GET_IOSPACE(pfn)=A0=A0=A0 =A0=A0=A0 (pfn >> (BITS_PER_LONG - =
4))
> #define GET_PFN(pfn)=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 (pfn & 0x0fffffffff=
ffffffUL)
>=20
> +extern int remap_pfn_range(struct vm_area_struct *, unsigned long, u=
nsigned=20
> long,
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  unsigned long, pgprot_t);
> +
> +static inline int io_remap_pfn_range(struct vm_area_struct *vma,
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0  unsigned long from,=
 unsigned long pfn,
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0  unsigned long size,=
 pgprot_t prot)
> +{
> +=A0=A0=A0 unsigned long offset =3D GET_PFN(pfn) << PAGE_SHIFT;
> +=A0=A0=A0 int space =3D GET_IOSPACE(pfn);
> +=A0=A0=A0 unsigned long phys_base;
> +
> +=A0=A0=A0 phys_base =3D offset | (((unsigned long) space) << 32UL);
> +
> +=A0=A0=A0 return remap_pfn_range(vma, from, phys_base >> PAGE_SHIFT,=
 size,=20
> prot);
> +}
> +
> #include <asm-generic/pgtable.h>
>=20
> /* We provide our own get_unmapped_area to cope with VA holes and
> diff --git a/arch/sparc/mm/Makefile b/arch/sparc/mm/Makefile
> index e3cda21..301421c 100644
> --- a/arch/sparc/mm/Makefile
> +++ b/arch/sparc/mm/Makefile
> @@ -8,7 +8,6 @@ obj-$(CONFIG_SPARC64)=A0  +=3D ultra.o tlb.o tsb.o gu=
p.o
> obj-y=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0  +=3D fault_$(BITS).o
> obj-y=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0  +=3D init_$(BITS).o
> obj-$(CONFIG_SPARC32)=A0  +=3D loadmmu.o
> -obj-y=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0  +=3D generic_$(BITS).o
> obj-$(CONFIG_SPARC32)=A0  +=3D extable.o btfixup.o srmmu.o iommu.o io=
-unit.o
> obj-$(CONFIG_SPARC32)=A0  +=3D hypersparc.o viking.o tsunami.o swift.=
o
> obj-$(CONFIG_SPARC_LEON)+=3D leon_mm.o
> diff --git a/arch/sparc/mm/generic_32.c b/arch/sparc/mm/generic_32.c
> deleted file mode 100644
> index 6ca39a6..0000000
> --- a/arch/sparc/mm/generic_32.c
> +++ /dev/null
> @@ -1,99 +0,0 @@
> -/*
> - * generic.c: Generic Sparc mm routines that are not dependent upon
> - *=A0 =A0 =A0 =A0 =A0 =A0 MMU type but are Sparc specific.
> - *
> - * Copyright (C) 1996 David S. Miller (davem-CVlFQpJstH5+CIkdHa1UOg@public.gmane.org)
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/mm.h>
> -#include <linux/swap.h>
> -#include <linux/pagemap.h>
> -#include <linux/export.h>
> -
> -#include <asm/pgalloc.h>
> -#include <asm/pgtable.h>
> -#include <asm/page.h>
> -#include <asm/cacheflush.h>
> -#include <asm/tlbflush.h>
> -
> -/* Remap IO memory, the same way as remap_pfn_range(), but use
> - * the obio memory space.
> - *
> - * They use a pgprot that sets PAGE_IO and does not check the
> - * mem_map table as this is independent of normal memory.
> - */
> -static inline void io_remap_pte_range(struct mm_struct *mm, pte_t * =
pte,=20
> unsigned long address, unsigned long size,
> -=A0=A0=A0 unsigned long offset, pgprot_t prot, int space)
> -{
> -=A0=A0=A0 unsigned long end;
> -
> -=A0=A0=A0 address &=3D ~PMD_MASK;
> -=A0=A0=A0 end =3D address + size;
> -=A0=A0=A0 if (end > PMD_SIZE)
> -=A0=A0=A0 =A0=A0=A0 end =3D PMD_SIZE;
> -=A0=A0=A0 do {
> -=A0=A0=A0 =A0=A0=A0 set_pte_at(mm, address, pte, mk_pte_io(offset, p=
rot, space));
> -=A0=A0=A0 =A0=A0=A0 address +=3D PAGE_SIZE;
> -=A0=A0=A0 =A0=A0=A0 offset +=3D PAGE_SIZE;
> -=A0=A0=A0 =A0=A0=A0 pte++;
> -=A0=A0=A0 } while (address < end);
> -}
> -
> -static inline int io_remap_pmd_range(struct mm_struct *mm, pmd_t * p=
md,=20
> unsigned long address, unsigned long size,
> -=A0=A0=A0 unsigned long offset, pgprot_t prot, int space)
> -{
> -=A0=A0=A0 unsigned long end;
> -
> -=A0=A0=A0 address &=3D ~PGDIR_MASK;
> -=A0=A0=A0 end =3D address + size;
> -=A0=A0=A0 if (end > PGDIR_SIZE)
> -=A0=A0=A0 =A0=A0=A0 end =3D PGDIR_SIZE;
> -=A0=A0=A0 offset -=3D address;
> -=A0=A0=A0 do {
> -=A0=A0=A0 =A0=A0=A0 pte_t *pte =3D pte_alloc_map(mm, NULL, pmd, addr=
ess);
> -=A0=A0=A0 =A0=A0=A0 if (!pte)
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return -ENOMEM;
> -=A0=A0=A0 =A0=A0=A0 io_remap_pte_range(mm, pte, address, end - addre=
ss, address + offset,=20
> prot, space);
> -=A0=A0=A0 =A0=A0=A0 address =3D (address + PMD_SIZE) & PMD_MASK;
> -=A0=A0=A0 =A0=A0=A0 pmd++;
> -=A0=A0=A0 } while (address < end);
> -=A0=A0=A0 return 0;
> -}
> -
> -int io_remap_pfn_range(struct vm_area_struct *vma, unsigned long fro=
m,
> -=A0=A0=A0 =A0=A0=A0 =A0 =A0 =A0  unsigned long pfn, unsigned long si=
ze, pgprot_t prot)
> -{
> -=A0=A0=A0 int error =3D 0;
> -=A0=A0=A0 pgd_t * dir;
> -=A0=A0=A0 unsigned long beg =3D from;
> -=A0=A0=A0 unsigned long end =3D from + size;
> -=A0=A0=A0 struct mm_struct *mm =3D vma->vm_mm;
> -=A0=A0=A0 int space =3D GET_IOSPACE(pfn);
> -=A0=A0=A0 unsigned long offset =3D GET_PFN(pfn) << PAGE_SHIFT;
> -
> -=A0=A0=A0 /* See comment in mm/memory.c remap_pfn_range */
> -=A0=A0=A0 vma->vm_flags |=3D VM_IO | VM_RESERVED | VM_PFNMAP;
> -=A0=A0=A0 vma->vm_pgoff =3D (offset >> PAGE_SHIFT) |
> -=A0=A0=A0 =A0=A0=A0 ((unsigned long)space << 28UL);
> -
> -=A0=A0=A0 offset -=3D from;
> -=A0=A0=A0 dir =3D pgd_offset(mm, from);
> -=A0=A0=A0 flush_cache_range(vma, beg, end);
> -
> -=A0=A0=A0 while (from < end) {
> -=A0=A0=A0 =A0=A0=A0 pmd_t *pmd =3D pmd_alloc(mm, dir, from);
> -=A0=A0=A0 =A0=A0=A0 error =3D -ENOMEM;
> -=A0=A0=A0 =A0=A0=A0 if (!pmd)
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
> -=A0=A0=A0 =A0=A0=A0 error =3D io_remap_pmd_range(mm, pmd, from, end =
- from, offset + from,=20
> prot, space);
> -=A0=A0=A0 =A0=A0=A0 if (error)
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
> -=A0=A0=A0 =A0=A0=A0 from =3D (from + PGDIR_SIZE) & PGDIR_MASK;
> -=A0=A0=A0 =A0=A0=A0 dir++;
> -=A0=A0=A0 }
> -
> -=A0=A0=A0 flush_tlb_range(vma, beg, end);
> -=A0=A0=A0 return error;
> -}
> -EXPORT_SYMBOL(io_remap_pfn_range);
> diff --git a/arch/sparc/mm/generic_64.c b/arch/sparc/mm/generic_64.c
> deleted file mode 100644
> index 9b357dd..0000000
> --- a/arch/sparc/mm/generic_64.c
> +++ /dev/null
> @@ -1,165 +0,0 @@
> -/*
> - * generic.c: Generic Sparc mm routines that are not dependent upon
> - *=A0 =A0 =A0 =A0 =A0 =A0 MMU type but are Sparc specific.
> - *
> - * Copyright (C) 1996 David S. Miller (davem-CVlFQpJstH5+CIkdHa1UOg@public.gmane.org)
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/mm.h>
> -#include <linux/swap.h>
> -#include <linux/export.h>
> -#include <linux/pagemap.h>
> -
> -#include <asm/pgalloc.h>
> -#include <asm/pgtable.h>
> -#include <asm/page.h>
> -#include <asm/tlbflush.h>
> -
> -/* Remap IO memory, the same way as remap_pfn_range(), but use
> - * the obio memory space.
> - *
> - * They use a pgprot that sets PAGE_IO and does not check the
> - * mem_map table as this is independent of normal memory.
> - */
> -static inline void io_remap_pte_range(struct mm_struct *mm, pte_t * =
pte,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 =A0 unsigned long ad=
dress,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 =A0 unsigned long si=
ze,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 =A0 unsigned long of=
fset, pgprot_t prot,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 =A0 int space)
> -{
> -=A0=A0=A0 unsigned long end;
> -
> -=A0=A0=A0 /* clear hack bit that was used as a write_combine side-ef=
fect flag */
> -=A0=A0=A0 offset &=3D ~0x1UL;
> -=A0=A0=A0 address &=3D ~PMD_MASK;
> -=A0=A0=A0 end =3D address + size;
> -=A0=A0=A0 if (end > PMD_SIZE)
> -=A0=A0=A0 =A0=A0=A0 end =3D PMD_SIZE;
> -=A0=A0=A0 do {
> -=A0=A0=A0 =A0=A0=A0 pte_t entry;
> -=A0=A0=A0 =A0=A0=A0 unsigned long curend =3D address + PAGE_SIZE;
> -=A0=A0=A0 =A0=A0=A0=20
> -=A0=A0=A0 =A0=A0=A0 entry =3D mk_pte_io(offset, prot, space, PAGE_SI=
ZE);
> -=A0=A0=A0 =A0=A0=A0 if (!(address & 0xffff)) {
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (PAGE_SIZE < (4 * 1024 * 1024) &&
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 !(address & 0x3fffff) &&
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 !(offset & 0x3ffffe) &&
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 =A0 end >=3D address + 0x400000) {
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 entry =3D mk_pte_io(offset, =
prot, space,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 4 * =
1024 * 1024);
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 curend =3D address + 0x40000=
0;
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 offset +=3D 0x400000;
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else if (PAGE_SIZE < (512 * 1024) &&
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  !(address & 0x7ffff) &&
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  !(offset & 0x7fffe) &&
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  end >=3D address + 0x80=
000) {
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 entry =3D mk_pte_io(offset, =
prot, space,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 512 =
* 1024 * 1024);
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 curend =3D address + 0x80000=
;
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 offset +=3D 0x80000;
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else if (PAGE_SIZE < (64 * 1024) &&
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  !(offset & 0xfffe) &&
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0  end >=3D address + 0x10=
000) {
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 entry =3D mk_pte_io(offset, =
prot, space,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 64 *=
 1024);
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 curend =3D address + 0x10000=
;
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 offset +=3D 0x10000;
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 } else
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 offset +=3D PAGE_SIZE;
> -=A0=A0=A0 =A0=A0=A0 } else
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 offset +=3D PAGE_SIZE;
> -
> -=A0=A0=A0 =A0=A0=A0 if (pte_write(entry))
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 entry =3D pte_mkdirty(entry);
> -=A0=A0=A0 =A0=A0=A0 do {
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 BUG_ON(!pte_none(*pte));
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 set_pte_at(mm, address, pte, entry);
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 address +=3D PAGE_SIZE;
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 pte_val(entry) +=3D PAGE_SIZE;
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 pte++;
> -=A0=A0=A0 =A0=A0=A0 } while (address < curend);
> -=A0=A0=A0 } while (address < end);
> -}
> -
> -static inline int io_remap_pmd_range(struct mm_struct *mm, pmd_t * p=
md,=20
> unsigned long address, unsigned long size,
> -=A0=A0=A0 unsigned long offset, pgprot_t prot, int space)
> -{
> -=A0=A0=A0 unsigned long end;
> -
> -=A0=A0=A0 address &=3D ~PGDIR_MASK;
> -=A0=A0=A0 end =3D address + size;
> -=A0=A0=A0 if (end > PGDIR_SIZE)
> -=A0=A0=A0 =A0=A0=A0 end =3D PGDIR_SIZE;
> -=A0=A0=A0 offset -=3D address;
> -=A0=A0=A0 do {
> -=A0=A0=A0 =A0=A0=A0 pte_t *pte =3D pte_alloc_map(mm, NULL, pmd, addr=
ess);
> -=A0=A0=A0 =A0=A0=A0 if (!pte)
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return -ENOMEM;
> -=A0=A0=A0 =A0=A0=A0 io_remap_pte_range(mm, pte, address, end - addre=
ss, address + offset,=20
> prot, space);
> -=A0=A0=A0 =A0=A0=A0 pte_unmap(pte);
> -=A0=A0=A0 =A0=A0=A0 address =3D (address + PMD_SIZE) & PMD_MASK;
> -=A0=A0=A0 =A0=A0=A0 pmd++;
> -=A0=A0=A0 } while (address < end);
> -=A0=A0=A0 return 0;
> -}
> -
> -static inline int io_remap_pud_range(struct mm_struct *mm, pud_t * p=
ud,=20
> unsigned long address, unsigned long size,
> -=A0=A0=A0 unsigned long offset, pgprot_t prot, int space)
> -{
> -=A0=A0=A0 unsigned long end;
> -
> -=A0=A0=A0 address &=3D ~PUD_MASK;
> -=A0=A0=A0 end =3D address + size;
> -=A0=A0=A0 if (end > PUD_SIZE)
> -=A0=A0=A0 =A0=A0=A0 end =3D PUD_SIZE;
> -=A0=A0=A0 offset -=3D address;
> -=A0=A0=A0 do {
> -=A0=A0=A0 =A0=A0=A0 pmd_t *pmd =3D pmd_alloc(mm, pud, address);
> -=A0=A0=A0 =A0=A0=A0 if (!pud)
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return -ENOMEM;
> -=A0=A0=A0 =A0=A0=A0 io_remap_pmd_range(mm, pmd, address, end - addre=
ss, address + offset,=20
> prot, space);
> -=A0=A0=A0 =A0=A0=A0 address =3D (address + PUD_SIZE) & PUD_MASK;
> -=A0=A0=A0 =A0=A0=A0 pud++;
> -=A0=A0=A0 } while (address < end);
> -=A0=A0=A0 return 0;
> -}
> -
> -int io_remap_pfn_range(struct vm_area_struct *vma, unsigned long fro=
m,
> -=A0=A0=A0 =A0=A0=A0 unsigned long pfn, unsigned long size, pgprot_t =
prot)
> -{
> -=A0=A0=A0 int error =3D 0;
> -=A0=A0=A0 pgd_t * dir;
> -=A0=A0=A0 unsigned long beg =3D from;
> -=A0=A0=A0 unsigned long end =3D from + size;
> -=A0=A0=A0 struct mm_struct *mm =3D vma->vm_mm;
> -=A0=A0=A0 int space =3D GET_IOSPACE(pfn);
> -=A0=A0=A0 unsigned long offset =3D GET_PFN(pfn) << PAGE_SHIFT;
> -=A0=A0=A0 unsigned long phys_base;
> -
> -=A0=A0=A0 phys_base =3D offset | (((unsigned long) space) << 32UL);
> -
> -=A0=A0=A0 /* See comment in mm/memory.c remap_pfn_range */
> -=A0=A0=A0 vma->vm_flags |=3D VM_IO | VM_RESERVED | VM_PFNMAP;
> -=A0=A0=A0 vma->vm_pgoff =3D phys_base >> PAGE_SHIFT;
> -
> -=A0=A0=A0 offset -=3D from;
> -=A0=A0=A0 dir =3D pgd_offset(mm, from);
> -=A0=A0=A0 flush_cache_range(vma, beg, end);
> -
> -=A0=A0=A0 while (from < end) {
> -=A0=A0=A0 =A0=A0=A0 pud_t *pud =3D pud_alloc(mm, dir, from);
> -=A0=A0=A0 =A0=A0=A0 error =3D -ENOMEM;
> -=A0=A0=A0 =A0=A0=A0 if (!pud)
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
> -=A0=A0=A0 =A0=A0=A0 error =3D io_remap_pud_range(mm, pud, from, end =
- from, offset + from,=20
> prot, space);
> -=A0=A0=A0 =A0=A0=A0 if (error)
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 break;
> -=A0=A0=A0 =A0=A0=A0 from =3D (from + PGDIR_SIZE) & PGDIR_MASK;
> -=A0=A0=A0 =A0=A0=A0 dir++;
> -=A0=A0=A0 }
> -
> -=A0=A0=A0 flush_tlb_range(vma, beg, end);
> -=A0=A0=A0 return error;
> -}
> -EXPORT_SYMBOL(io_remap_pfn_range);
> --=20
> 1.7.6.401.g6a319
>=20

I'll try them immediately and write back ASAP.
Thanks once already!

Regards,
Lukas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
