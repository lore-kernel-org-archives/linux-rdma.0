From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Tue, 22 Feb 2011 20:23:34 -0500
Message-ID: <1298424214.4765.11.camel@obelisk.thedillows.org>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
	 <aday66hxxwe.fsf@cisco.com> <1298074037.15679.17.camel@lap75545.ornl.gov>
	 <4D635974.10807@mellanox.com>
	 <1298386190.18945.1.camel@obelisk.thedillows.org>
	 <AANLkTikxDu5b=p4fXHMm8W+tF3Lru4vB7xRZEF+HDpyu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikxDu5b=p4fXHMm8W+tF3Lru4vB7xRZEF+HDpyu-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2011-02-22 at 15:38 -0800, Roland Dreier wrote:
> On Tue, Feb 22, 2011 at 6:49 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > Thanks for the note Or -- you confirmed my suspensions after testing
> > last night. Looks like multiple MRs per request, then.
> 
> Multiple MRs per request, or one fast reg MR per request?

Multiple fast reg MRs per request -- on mlx4, they max out at 511
entries, so I'd need 5 FRMRs to get to 8 MB requests. I'm scaling based
on max_sect and the device attributes, so if one doesn't want more than
1 MB requests, they don't pay for the extra MRs -- or if other cards
support larger/smaller fast reg MRs, then the code does the right thing.

> This really should be roughly the same as old-style FMRs -- in both
> cases, we need one "registration" per request that might be in flight.
> Old-style FMRs and new IB-spec fast reg MRs should be roughly
> the same in terms of resources consumed...

Yeah, it seems pretty close overall. Fast reg MRs put more of it in view
of SRP, where as old-style FMRs hid the bookkeeping in ib_pool_fmr.

As an aside, is there any guarantee that ib_post_send() will not modify
the list of work requests? I currently make no assumptions about that,
but it would avoid some work if I could re-use a work request, and just
change the fields I need instead of fully re-initializing it every time.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
