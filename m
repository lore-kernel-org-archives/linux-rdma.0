From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] IB/qib: detour pcie_caps for certain chip sets
Date: Thu, 12 Jan 2012 14:35:31 -0800
Message-ID: <35AAF1E4A771E142979F27B51793A4888885A5E46B@AVEXMB1.qlogic.org>
References: <20120112030049.31831.62692.stgit@kop-dev-sles11-04.qlogic.org>
 <CAL1RGDXOO6baaET_fCFT3YUsK9aqGkODoHnd1FNwOp_szZO4Gw@mail.gmail.com>
 <35AAF1E4A771E142979F27B51793A4888885A5E3AE@AVEXMB1.qlogic.org>
 <CAL1RGDW2DcU_kp46BfRJjQjkEYxcCqRzqdgOC-AAhUsXsDb8gQ@mail.gmail.com>
 <35AAF1E4A771E142979F27B51793A4888885A5E45C@AVEXMB1.qlogic.org>
 <20120112222328.GI31021@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120112222328.GI31021-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> It doesn't seem to me like this has any place in the quirks thing
> either. Things seem to be working properly, the MaxPayLoad of 128 is
> clearly the highest the system will support correctly.
>
> Jason

Probably the best thing to do unwind the module parameter default in 8d4548f2b which would change the initial value back to 0.

That's the way the file has always been and that won't change the rc.

Mike

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
