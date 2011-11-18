From: David Miller <davem@davemloft.net>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Fri, 18 Nov 2011 01:17:08 -0500 (EST)
Message-ID: <20111118.011708.677233058349078554.davem@davemloft.net>
References: <20111117.210316.83327515715765011.davem@davemloft.net>
	<20111117.212847.1778246801048496855.davem@davemloft.net>
	<1321592577.354.YahooMailNeo@web24712.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1321592577.354.YahooMailNeo@web24712.mail.ird.yahoo.com>
Sender: sparclinux-owner@vger.kernel.org
To: linux@razik.name
Cc: roland@purestorage.com, sparclinux@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

=46rom: Lukas Razik <linux@razik.name>
Date: Fri, 18 Nov 2011 05:02:57 +0000 (GMT)

> After applying your patch I still get the errors:
> [ 1117.556582] swap_free: Bad swap file entry 100004e000061800
> [ 1117.556710] BUG: Bad page map in process ibv_devinfo=A0 pte:9c0000=
c300104608 pmd:00f882d0

This looks almost like it's actually a mapping to physical memory, or
at least it is a PTE which hasn't had pgprot_noncached() applied to
it's protections.

Another hint is that pte_mkspecial() hasn't been performed on this PTE
either.

The PTE is:			0x9c0000c300104608

which amounts to:

	_PAGE_VALID		0x8000000000000000
	_PAGE_ACCESSED_4V	0x1000000000000000
	_PAGE_READ_4V		0x0800000000000000
	_PAGE_WRITE_4V		0x0400000000000000
	physical page		0x000000c300104000
	_PAGE_CP_4V		0x0000000000000400
	_PAGE_CV_4V		0x0000000000000200
	_PAGE_RESV_4V		0x0000000000000008

That last bit is mysterious, there shouldn't be anything setting
the reserved bit 0x8.

But that just so happens to be equal to the SUN4U PTE's "side effect"
bit, _PAGE_E_4U.

Hmmm...

That explains everything.  The problem is that we don't do the sparc64
PTE handling code patching in modules.  So it's left at the default 4U
versions.

So the PTE did have pgprot_noncached() applied to it's protections,
it's just that this function is inlined into the driver module and
hasn't been patched properly by the sun4v code patcher when the module
got loaded.

I'll work on a fix for this.
--
To unsubscribe from this list: send the line "unsubscribe sparclinux" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
