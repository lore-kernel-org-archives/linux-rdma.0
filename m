From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] IB/qib: detour pcie_caps for certain chip sets
Date: Thu, 12 Jan 2012 14:14:12 -0800
Message-ID: <35AAF1E4A771E142979F27B51793A4888885A5E45C@AVEXMB1.qlogic.org>
References: <20120112030049.31831.62692.stgit@kop-dev-sles11-04.qlogic.org>
 <CAL1RGDXOO6baaET_fCFT3YUsK9aqGkODoHnd1FNwOp_szZO4Gw@mail.gmail.com>
 <35AAF1E4A771E142979F27B51793A4888885A5E3AE@AVEXMB1.qlogic.org>
 <CAL1RGDW2DcU_kp46BfRJjQjkEYxcCqRzqdgOC-AAhUsXsDb8gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDW2DcU_kp46BfRJjQjkEYxcCqRzqdgOC-AAhUsXsDb8gQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
>        if (parent->vendor != 0x8086)
>                 return 1;
>
> so I guess you don't need another vendor check.

Actually, Jason is right.  The vendor check you reference here is in qib_tune_pcie_coalesce() and not the routine being patched.

A bit of background here is that the issue was noted with the indicated Harpertown root complex chip sets as follows:
- The BIOS set the root complex MaxPayLoad to 128, but rc capabilities indicate 256 is possible
- To get the best performance we tried going to 256 on the rc and our card and noted the Poisoned TLP
- The patch is an effort to avoid having to use set pcie_caps at all as well as avoiding issues with the problematic chip sets
- The module parameter can still be used to experiment

We have never the issue with AMD or other Intel chipsets.  The problematic device ids are not in fixup.c in lib.

I can reissue a v2 with:
- the vendor check
- define use when available

We probably need to do something, since the current 3.2 rc has the above risk.

Mike


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
