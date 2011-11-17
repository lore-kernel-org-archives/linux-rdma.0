From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Thu, 17 Nov 2011 16:49:41 -0500 (EST)
Message-ID: <20111117.164941.2104520709167256016.davem@davemloft.net>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com>
	<CAL1RGDXnzQTQuMica3ZsRYbGNhT7GcySQvcAnJ+-5E2P0xw4Ag@mail.gmail.com>
	<1321471354.5493.YahooMailNeo@web24714.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321471354.5493.YahooMailNeo-tOYT8urs2cbyX4RqAA4FmIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org
Cc: sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

=46rom: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Date: Wed, 16 Nov 2011 19:22:34 +0000 (GMT)

> I'm wondering if the bug is in the mlx4 code or in the sparc
> io_remap_pfn_range()
> code.=A0 From the "Bad page map" pte value, if I understand sparc mm =
correctly,
> the PTE is seen as not present.

The not-present test is essentially testing the PTE against zero.

This bug check is making sure that there are not already existing mappi=
ngs
at that address when the io_remap_pfn_range() call occurs.

x86 uses remap_pfn_range() as the implementation of it's
io_remap_pfn_range() and it also has the same exact assertion
check, in remap_pte_range().

I can't see any obvious bug in the mlx4 mmap method.

The only thing I can come up with is that perhaps there is an assumptio=
n
hiding around somewhere that PAGE_SIZE is 4096.  Such an assumption wou=
ld
go undetected on both 32-bit and 64-bit x86 platforms since PAGE_SIZE i=
s
4096 there.  Whereas on sparc64 it is 8192.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
