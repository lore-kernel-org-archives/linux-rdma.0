From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] IB/qib: detour pcie_caps for certain chip sets
Date: Thu, 12 Jan 2012 13:57:18 -0800
Message-ID: <CAL1RGDW2DcU_kp46BfRJjQjkEYxcCqRzqdgOC-AAhUsXsDb8gQ@mail.gmail.com>
References: <20120112030049.31831.62692.stgit@kop-dev-sles11-04.qlogic.org>
 <CAL1RGDXOO6baaET_fCFT3YUsK9aqGkODoHnd1FNwOp_szZO4Gw@mail.gmail.com> <35AAF1E4A771E142979F27B51793A4888885A5E3AE@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35AAF1E4A771E142979F27B51793A4888885A5E3AE-HolNjIBXvBOXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 12, 2012 at 9:17 AM, Mike Marciniszyn
<mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
>> Does this work on systems where the broken chipset might
>> not be the immediate parent of the qib device (ie there are
>> some PCIe switches in between)?

> The code figures this out at the top of routine and returns, changing nothing.

OIC.

Also I see

       if (parent->vendor != 0x8086)
                return 1;

so I guess you don't need another vendor check.

Although this might be better written as PCI_VENDOR_ID_INTEL instead of 0x8086.

I guess this is OK, although as Jason said it would be much better
if the PCI core knew about these chipset errata.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
