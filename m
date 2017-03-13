From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/core: Restore I/O MMU, s390 and powerpc support
Date: Mon, 13 Mar 2017 17:04:06 +0000
Message-ID: <1489424634.2658.3.camel@sandisk.com>
References: <1D08B61A9CF0974AA09887BE32D889DA0DBFCB@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1D08B61A9CF0974AA09887BE32D889DA0DBFCB-fxMRTlsoH6pS59oDqloDyoaX4dThiank9m7AsFVS2+l8Oh6FZyoiAQ@public.gmane.org>
Content-Language: en-US
Content-ID: <0889ECC21DBFE4468791B4D1A4FD3275-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-03-07 at 22:56 +0000, Bart Van Assche wrote:
> [ ... ]
> Ensure that DMA mapping operations that use to_pci_dev() to
> access to struct pci_dev see the correct PCI device. E.g. the s390
> and powerpc DMA mapping operations use to_pci_dev() even with I/O
> MMU support disabled.
> [ ... ]

Hello Sebastian,

Have you already been able to test this patch?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
