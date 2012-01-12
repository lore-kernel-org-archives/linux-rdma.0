From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/qib: detour pcie_caps for certain chip sets
Date: Thu, 12 Jan 2012 15:23:28 -0700
Message-ID: <20120112222328.GI31021@obsidianresearch.com>
References: <20120112030049.31831.62692.stgit@kop-dev-sles11-04.qlogic.org>
 <CAL1RGDXOO6baaET_fCFT3YUsK9aqGkODoHnd1FNwOp_szZO4Gw@mail.gmail.com>
 <35AAF1E4A771E142979F27B51793A4888885A5E3AE@AVEXMB1.qlogic.org>
 <CAL1RGDW2DcU_kp46BfRJjQjkEYxcCqRzqdgOC-AAhUsXsDb8gQ@mail.gmail.com>
 <35AAF1E4A771E142979F27B51793A4888885A5E45C@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <35AAF1E4A771E142979F27B51793A4888885A5E45C-HolNjIBXvBOXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 12, 2012 at 02:14:12PM -0800, Mike Marciniszyn wrote:

> Actually, Jason is right.  The vendor check you reference here is in
> qib_tune_pcie_coalesce() and not the routine being patched.
> 
> A bit of background here is that the issue was noted with the
> indicated Harpertown root complex chip sets as follows:
> - The BIOS set the root complex MaxPayLoad to 128, but rc capabilities indicate 256 is possible
> - To get the best performance we tried going to 256 on the rc and
> our card and noted the Poisoned TLP

I don't think it is appropriate for a driver to modify the pci
configuration of the root complex.. What if other drivers also try and
modify this configuration? Chaos.

It doesn't seem to me like this has any place in the quirks thing
either. Things seem to be working properly, the MaxPayLoad of 128 is
clearly the highest the system will support correctly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
