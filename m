From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] IB/ipoib: Prevent hung task or softlockup processing
 multicast response
Date: Tue, 29 Nov 2011 13:24:39 -0800
Message-ID: <35AAF1E4A771E142979F27B51793A4888847B8C52E@AVEXMB1.qlogic.org>
References: <20111121134354.26386.85093.stgit@kop-dev-sles11-04.qlogic.org>
 <CAL1RGDUE2+HRhue+i=AVGuChe4FkY1Y=E7REGtadGrQ5uavWSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUE2+HRhue+i=AVGuChe4FkY1Y=E7REGtadGrQ5uavWSQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  > The test that induced the failure is associated with a host SM on
> the same
>  > server during a shutdown.

There was a bug unrelated to this that made is more reproducible.   So another bug lead to this one.

Mike

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
