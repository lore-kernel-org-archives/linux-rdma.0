From: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] IB/core: Restore I/O MMU, s390 and powerpc support
Date: Mon, 13 Mar 2017 18:15:26 +0100 (CET)
Message-ID: <alpine.LFD.2.20.1703131810060.2714@schleppi>
References: <1D08B61A9CF0974AA09887BE32D889DA0DBFCB@ULS-OP-MBXIP03.sdcorp.global.sandisk.com> <1489424634.2658.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489424634.2658.3.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

On Mon, 13 Mar 2017, Bart Van Assche wrote:
> On Tue, 2017-03-07 at 22:56 +0000, Bart Van Assche wrote:
> > [ ... ]
> > Ensure that DMA mapping operations that use to_pci_dev() to
> > access to struct pci_dev see the correct PCI device. E.g. the s390
> > and powerpc DMA mapping operations use to_pci_dev() even with I/O
> > MMU support disabled.
> > [ ... ]
> 
> Have you already been able to test this patch?

Yes. I've tested this one this morning on top of v4.11-rc2 and can confirm
that everything works as expected.

Thanks!

Sebastian

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
