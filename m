From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] MAINTAINERS: update from QLogic to Intel
Date: Tue, 15 May 2012 17:27:17 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0D42AD9B@FMSMSX108.amr.corp.intel.com>
References: <20120510132520.15127.79238.stgit@kop-dev-sles11-04.qlogic.org>
 <CAL1RGDWVZi=Ekg1z1kZn21yb+Tncksc6KDS_C2eYwRcmj5_kqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWVZi=Ekg1z1kZn21yb+Tncksc6KDS_C2eYwRcmj5_kqQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Upon further checking, the following patches are not yet present:

IB/qib: MADs should return failure with misset mkeys				http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11588.html
IB/qib: Display correct value for number of contexts				http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11615.html
IB/qib: Fix QLE734X link cycling							http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11614.html
IB/qib: Fix qib driver mkey lease timeout handling				http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11586.html
IB/qib: correct ordering of reregister vs. port active event			http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11585.html
IB/qib: optimize pio ack buffer allocation					http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11613.html
IB/qib: add cache line awareness to qib_qp and qib_devdata structures	http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11612.html
IB/qib: compile qib_verbs.c for optimal memcpy performance			http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11583.html
										http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11584.html

Thanks!
Mike


> -----Original Message-----
> From: Roland Dreier [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org]
> Sent: Monday, May 14, 2012 3:49 PM
> To: Marciniszyn, Mike
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] MAINTAINERS: update from QLogic to Intel
> 
> Thanks, applied (I think) all pending qib patches
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
