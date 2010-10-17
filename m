From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 0/5] IB/srp: Add SRP_CRED_REQ support
Date: Sun, 17 Oct 2010 11:30:25 -0400
Message-ID: <1287329425.3105.17.camel@obelisk.thedillows.org>
References: <1287285925-11710-1-git-send-email-dillowda@ornl.gov>
	 <AANLkTinVRj4kQ5L1Bwmdo4Wcae6btA+kaSV8a=UE9rBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinVRj4kQ5L1Bwmdo4Wcae6btA+kaSV8a=UE9rBQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2010-10-17 at 10:51 +0200, Bart Van Assche wrote:
> Information about why part of the implementation has been reworked is
> missing. Information about whether or not the reworked implementation
> has been tested is missing too.

Bart,

This series has been tested as thoroughly as I possibly can. I've tried
to analyze it for races for the months we've gone back and forth. I have
run it against hardware RAIDs that don't use SRP_CRED_REQ, and against
the SCST SRP target, which probes for it, but currently seems to only
use it on reset. Feeling that both were insufficient, I then wrote an
SRP test target that solely uses SRP_CRED_REQ to return credits, and ran
against that.

None of this guarantees freedom from bugs, of course, but I'm
comfortable with the series.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
