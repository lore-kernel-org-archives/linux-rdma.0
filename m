From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] IB/qib: Prevent driver hang with unprogrammed boards
Date: Mon, 11 Apr 2011 13:29:54 -0700
Message-ID: <35AAF1E4A771E142979F27B51793A4888838902C31@AVEXMB1.qlogic.org>
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

I saw that, but wanted to replicate the patch as we authored it internally.

I agree that 32 bit jiffies (given the 500ms timeout), would be sufficient and that the time_is_before_jiffies() macro would be a better solution.

I will work with Mitko to get a revision with your suggestions.

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
