From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] IB/qib: Prevent driver hang with unprogrammed boards
Date: Tue, 12 Apr 2011 09:58:22 -0700
Message-ID: <35AAF1E4A771E142979F27B51793A4888838902DCE@AVEXMB1.qlogic.org>
References: <20110411134517.3720.3633.stgit@kop-dev-sles11-04.qlogic.org>
 <BANLkTikuO=uKCxkvuSfx1UBQuDxLtWCacg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikuO=uKCxkvuSfx1UBQuDxLtWCacg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I would like to keep the patch as is for now, since the Serdes code is using the 64 bit jiffies consistently throughout.  The fix solves a real issue (modprobe hang) with boards that haven't been QA'ed properly.

Is there a reason to avoid the 64 bit jiffies stuff that should cause us to look at a more global effort beyond the scope of this patch?

Mike

-----Original Message-----
From: Roland Dreier [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org]
Sent: Monday, April 11, 2011 4:25 PM
To: Mike Marciniszyn
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH] IB/qib: Prevent driver hang with unprogrammed boards

On Mon, Apr 11, 2011 at 6:45 AM, Mike Marciniszyn
<mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> -              !time_after64(tstart, tstart + msecs_to_jiffies(500))) {
> +              !time_after64(get_jiffies_64(),
> +                       tstart + msecs_to_jiffies(500))) {

By the way, is there any need to use 64-bit jiffies stuff here?

Couldn't this be more cleanly written with just time_is_before_jiffies()?


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
