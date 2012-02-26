From: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Subject: RE: [PATCH] IB: Fix potential mem leak in schedule_nes_timer()
Date: Sun, 26 Feb 2012 22:43:06 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202262242290.6089@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202202153230.20998@swampdragon.chaosbits.net> <1EEBC91386407A4A8D1EBE1DD5AA5212D36E22@FMSMSX105.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1EEBC91386407A4A8D1EBE1DD5AA5212D36E22-AtyAts71sc9qS6EAlXoojrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 24 Feb 2012, Latif, Faisal wrote:

> I do not approve this patch. 
> 
> The type field is always set to either NES_TIMER_TYPE_SEND or 
> NES_TIMER_TYPE_CLOSE when schedule_nes_timer() is called. Even if we 
> wanted to make sure the value of type is one or the other, proper patch 
> can be just a if stmt to check the type before new_send allocation.
> 
Makes sense. I'll drop the patch for now.

-- 
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
