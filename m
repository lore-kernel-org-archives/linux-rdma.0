From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Sun, 03 Jan 2010 20:34:06 -0500
Message-ID: <1262568846.13289.4.camel@obelisk.thedillows.org>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261001020419l36319156hb9d625edc2e15d06-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2010-01-02 at 13:19 +0100, Bart Van Assche wrote:
> This patch fixes this issue by adding support for SRP_CRED_REQ information
> units in the SRP initiator. Additionally, this patch makes the per-session
> variable req_lim visible through sysfs, which makes observing the initiator
> state easier.

I agree that we should add support for SRP_CRED_REQ, but I'm not
thrilled with the mix of changes in the patch, as well as the general
aesthetics of the result. How about something like the following series
-- posted as a follow up to this message -- with proper credit for Bart?
I'll sign off on them once we're happy with a direction and Bart acks.

Also, these are all compile tested only, so they need some testing. I
don't have anything that uses these messages, so some help would be
appreciated.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
