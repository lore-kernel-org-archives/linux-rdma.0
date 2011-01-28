From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] infiniband: hw: amso1100: Fixed compile warning.
Date: Fri, 28 Jan 2011 15:41:42 -0800
Message-ID: <AANLkTimapHEPRcHDYuyksORHdRkEFVKyEyM=BM_0iZr4@mail.gmail.com>
References: <1295800203-9552-1-git-send-email-ralf.thielow@googlemail.com> <AANLkTimLbkqmkijkLk+kALOUK6TVB0AJA3Ca+X-wcjpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimLbkqmkijkLk+kALOUK6TVB0AJA3Ca+X-wcjpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Ralf Thielow <ralf.thielow-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Have you considered using "0" instead of "(u64) NULL" or "(unsigned
> long) NULL" ?

I applied a new version of the patch with 0 instead of (unsigned long)
NULL, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
