From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IBV_SEND_IP_CSUM not support in libibverbs?
Date: Mon, 25 Aug 2014 14:17:16 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1408251416420.28398@gentwo.org>
References: <000001422f6d6037-2925de58-d10b-4e1a-a397-eff2a8b9352c-000000@email.amazonses.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000001422f6d6037-2925de58-d10b-4e1a-a397-eff2a8b9352c-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 6 Nov 2013, Christoph Lameter wrote:

> I see that IB_SEND_IP_CSUM is provided by the kernel but IBV_SEND_IP_CSUM
> is not available via libibverbs?

We just ran again into this issue. Why is userspace not able to set this
bit? Libibverbs does not support it.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
