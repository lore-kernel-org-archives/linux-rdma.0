From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/srp: use IB_CQ_REPORT_MISSED_EVENTS to avoid  missed CQ callbacks
Date: Wed, 31 Mar 2010 11:18:44 -0700
Message-ID: <adazl1oiccb.fsf@roland-alpha.cisco.com>
References: <20100331175742.24522.17850.stgit@chromite.mv.qlogic.com>
	<20100331175752.24522.66519.stgit@chromite.mv.qlogic.com>
	<y2ie2e108261003311111uec1ec00g746ba0ffe3d98799@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <y2ie2e108261003311111uec1ec00g746ba0ffe3d98799-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Wed, 31 Mar 2010 20:11:40 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > The SRP initiator works fine without this patch, and this patch slows
 > down the SRP initiator.

I do agree that there are no missed callbacks without this patch, but I
don't see how it would slow things down... it seems to me it would avoid
some CQ event callbacks, especially for HCAs where
IB_CQ_REPORT_MISSED_EVENTS never returns >0 for missed events.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
