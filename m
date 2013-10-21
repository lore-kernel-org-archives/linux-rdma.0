From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: BUG: bad page map under Xen
Date: Mon, 21 Oct 2013 10:18:55 -0400
Message-ID: <20131021141855.GA4211@phenom.dumpdata.com>
References: <20131021115740.GN20913@ics.muni.cz> <52652534.2040303@oracle.com>
	<526545E002000078000FC5F1@nat28.tlf.novell.com>
	<52652E95.3020305@oracle.com> <20131021140607.GQ20913@ics.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
Content-Disposition: inline
In-Reply-To: <20131021140607.GQ20913@ics.muni.cz>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: roland@kernel.org, linux-rdma@vger.kernel.org, Jan Beulich <JBeulich@suse.com>, xen-devel@lists.xen.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 21, 2013 at 04:06:07PM +0200, Lukas Hejtmanek wrote:
> On Mon, Oct 21, 2013 at 09:39:33AM -0400, konrad wilk wrote:
> > Anyhow, one easy thing to figure out is to get the lspci -v output
> > from the InfiniBand card
> > to see where its BARs are, and also the start of the kernel. You
> > should see an E820 map (please also boot with
> > "debug" on the Linux command line).
> 
> note, adding _PAGE_IO as Jan suggested fixed those mem errors.

<nods> Right.
> 
> here is lspci from the card and its virtual functions.
> 
> 06:00.0 Network controller: Mellanox Technologies MT27500 Family [ConnectX-3]
>         Subsystem: Mellanox Technologies Device 0017
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 42
>         Region 0: Memory at dfa00000 (64-bit, non-prefetchable) [size=1M]
>         Region 2: Memory at 380fff000000 (64-bit, prefetchable) [size=8M]

Wow.

> 06:00.1 Network controller: Mellanox Technologies MT27500 Family [ConnectX-3 Virtual Function]
>         Subsystem: Mellanox Technologies Device 61b0
>         Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Region 2: [virtual] Memory at 380fdf000000 (64-bit, prefetchable) [size=8M]

Wow again.

.. snip..
> and this is from dmesg:
> 
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] Xen: [mem 0x0000000000000000-0x0000000000090fff] usable
> [    0.000000] Xen: [mem 0x0000000000091800-0x00000000000fffff] reserved
> [    0.000000] Xen: [mem 0x0000000000100000-0x000000007dd76fff] usable
> [    0.000000] Xen: [mem 0x000000007dd77000-0x000000007ddb5fff] reserved
> [    0.000000] Xen: [mem 0x000000007ddb6000-0x000000007debefff] ACPI data
> [    0.000000] Xen: [mem 0x000000007debf000-0x000000007e0dafff] ACPI NVS
> [    0.000000] Xen: [mem 0x000000007e0db000-0x000000007f357fff] reserved
> [    0.000000] Xen: [mem 0x000000007f358000-0x000000007f7fffff] ACPI NVS
> [    0.000000] Xen: [mem 0x0000000080000000-0x000000008fffffff] reserved
> [    0.000000] Xen: [mem 0x00000000fec00000-0x00000000fec01fff] reserved
> [    0.000000] Xen: [mem 0x00000000fec40000-0x00000000fec40fff] reserved
> [    0.000000] Xen: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
> [    0.000000] Xen: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] Xen: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] Xen: [mem 0x0000000100000000-0x000000107fffffff] usable

Odd, there should be messages about 1-1 mapping when you use 'debug'.

But either way - the problem (bug) is what I suspected - we treat any region
past the E820 as INVALID_P2M_ENTRY and hence doing any set_pte(..) operations
will fetch an 0 value, which in turn means that the PTE is zero (with the
0x200 _PAGE_SPECIAL b/c of VMA tracking).

Now the fix is to determine _where_ the end of real memory is so that we
can make sure that ballooning will work (in case of dom0_mem_max parameter).
And then anything past that PFN can be treated as IDENTITY_FRAME.

Naively, I think this patch would do it:

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 09f3059..3871554 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -92,6 +92,9 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
 
                __set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
        }
+       /* Anything past the balloon area is marked as identity. */
+       for (pfn = xen_max_p2m_pfn; pfn < MAX_DOMAIN_PAGES; pfn++)
+               __set_phys_to_machine(pfn, IDENTITY_FRAME(pfn));
 }
 
 static unsigned long __init xen_do_chunk(unsigned long start,

But this is not even compile tested :-(
