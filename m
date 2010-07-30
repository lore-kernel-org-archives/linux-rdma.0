From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH] IB/srp: introduce print_hex_dump()
Date: Thu, 29 Jul 2010 20:57:10 -0400
Message-ID: <1280451430.31468.32.camel@obelisk.thedillows.org>
References: <201007291756.37672.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201007291756.37672.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-07-29 at 17:56 +0200, Bart Van Assche wrote:
> Reduces the number of source code lines in ib_srp.c by replacing an explicit
> loop by a call to print_hex_dump().

I like the idea, minor nit in that we loose the SCSI prefix that tells
use which host device printed it. Then again it's a debugging aid, so I
don't know that it matters all that much.

Easily solvable with s/""/dev_name(target->scsi_host.shost_gendev)/

Hmm, that may be more ugly than it is worth.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
