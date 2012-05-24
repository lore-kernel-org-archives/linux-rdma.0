From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: size of queue pair number
Date: Thu, 24 May 2012 01:41:11 -0700
Message-ID: <CAL1RGDVdvb1q66YMDuaE2KKpnD6agvk8OhZ8HMJZQCznOn_5rw@mail.gmail.com>
References: <1337846845.20236.8.camel@br9gv9yg.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337846845.20236.8.camel-EWOwsnNsUwS5SqV9CvDRx0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 24, 2012 at 1:07 AM, Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> we want to make use of Infiniband communication and I am working on the
> Linux part. The peer can be a non-Linux system. Now we see a mismatch in
> the size of the queue pair number in Linux (32 bits) and the Infiniband
> Architecture Specification (24 bits). Will the additional 8 highest
> order bits ever be used in Linux? And if yes, for which purpose? Is the
> maximum queue pair number 0xFFFFFF?

The reason the queue pair number type is 32 bits in the Linux stack is
that there is no u24 or uint24_t and very few processors have support
for 24-bit integer types :)

The queue pair numbers are allocated by the hardware drivers, and
modulo bugs they should always return a QPN that complies with the IB
architecture.  So in other words, yes, you can safely assume that QPNs
are in the range 0 ... 0xffffff.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
