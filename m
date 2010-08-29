From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2.6.36] RDMA/cxgb3: Don't exceed the max HW CQ depth.
Date: Sun, 29 Aug 2010 11:33:37 -0700
Message-ID: <ada8w3p2rr2.fsf@cisco.com>
References: <20100828133505.14439.81049.stgit@build.ogc.int>
	<4C7911B4.9070904@opengridcomputing.com>
	<AANLkTim96=HGH_WBaPAUV2zMG0HDgFmixtHE2xQaJMyS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim96=HGH_WBaPAUV2zMG0HDgFmixtHE2xQaJMyS-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Sun, 29 Aug 2010 09:16:44 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > The easiest way is to add "CC: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>" when submitting a
 > patch. An alternative is after the patch has been accepted in Linus'
 > tree to submit it to stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org with a reference to the commit
 > ID in Linus' tree. More information can be found in
 > Documentation/stable_kernel_rules.txt.

Yep, this is exactly right.  In this case I'll add the cc to the commit
message so you don't need to do anything more.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
