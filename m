From: Lukas Razik <linux@razik.name>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Fri, 18 Nov 2011 05:02:57 +0000 (GMT)
Message-ID: <1321592577.354.YahooMailNeo@web24712.mail.ird.yahoo.com>
References: <20111117.164941.2104520709167256016.davem@davemloft.net> <CAL1RGDV_AwOOnLvWJKGqBTaptetfVN_gXNG=PcaFUXYSXrQ5AA@mail.gmail.com> <20111117.210316.83327515715765011.davem@davemloft.net> <20111117.212847.1778246801048496855.davem@davemloft.net>
Reply-To: Lukas Razik <linux@razik.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20111117.212847.1778246801048496855.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>, "roland@purestorage.com" <roland@purestorage.com>
Cc: "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> Can someone with the effected hardware please test this?
>=20
> --------------------
> [PATCH] sparc: Kill custom io_remap_pfn_range().
>=20
> To handle the large physical addresses, just make a simple wrapper
> around remap_pfn_range() like MIPS does.
>=20
> Signed-off-by: David S. Miller <davem@davemloft.net>
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

Hello David!

After applying your patch I still get the errors:
[ 1117.556582] swap_free: Bad swap file entry 100004e000061800
[ 1117.556710] BUG: Bad page map in process ibv_devinfo=A0 pte:9c0000c3=
00104608 pmd:00f882d0
[ 1117.556827] addr:fffff80100114000 vm_flags:400844fa anon_vma:=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 (null) mapping:fffff807f623a410 index:6180082
[ 1117.557007] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x8/0x38 [ib_uv=
erbs]
[ 1117.557054] Call Trace:
[ 1117.557093]=A0 [00000000004ccff8] unmap_vmas+0x514/0x7f4
[ 1117.557143]=A0 [00000000004d0d14] unmap_region+0xb4/0x164
[ 1117.557192]=A0 [00000000004d1d60] do_munmap+0x2a8/0x31c
[ 1117.557247]=A0 [000000000042d340] SyS_64_munmap+0x88/0xa8
[ 1117.557302]=A0 [0000000000406154] linux_sparc_syscall+0x34/0x44
[ 1117.557347] Disabling lock debugging due to kernel taint


Regards,
Lukas
--
To unsubscribe from this list: send the line "unsubscribe sparclinux" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
