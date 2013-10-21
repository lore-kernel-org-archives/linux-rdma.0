From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Xen-devel] BUG: bad page map under Xen
Date: Mon, 21 Oct 2013 15:20:44 +0100
Message-ID: <5265545C02000078000FC725@nat28.tlf.novell.com>
References: <20131021115740.GN20913@ics.muni.cz>
 <52652534.2040303@oracle.com>
 <526545E002000078000FC5F1@nat28.tlf.novell.com>
 <52652E95.3020305@oracle.com> <20131021140607.GQ20913@ics.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131021140607.GQ20913-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Hejtmanek <xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>, konrad wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>>> On 21.10.13 at 16:06, Lukas Hejtmanek <xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org> wrote:
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

Which confirms what Konrad said regarding MMIO above 4Gb.

Jan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
