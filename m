From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] IB/srp: use multiple CPU cores more effectively
Date: Wed, 04 Aug 2010 13:40:12 -0700
Message-ID: <adak4o66rir.fsf@roland-alpha.cisco.com>
References: <201008031602.37294.bvanassche@acm.org>
	<4C59C34F.2000400@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C59C34F.2000400-d+Crzxg7Rs0@public.gmane.org> (Vladislav Bolkhovitin's message of
	"Wed, 04 Aug 2010 23:45:19 +0400")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I believe this is a wrong approach for this problem. You are
 > workarounding it, not solving, and introducing a bad side effect of
 > additional context switch per command, so increasing its processing
 > latency. It doesn't matter that it can be switched off. Linux already
 > has too many magic knobs where average user for long ago get lost.

agree ... how do we expect users to know what value to set for the
thread parameter?

 > If you want to spread requests post processing among several CPUs, you
 > should consider real approaches for that:

And furthermore, as far as I can see, the subject line of this patch is
quite misleading.  It does not use multiple CPUs at all for the numbers
posted, since it creates a single kthread and moves completion
processing there (although maybe this would help with multiple targets).

It seems the real improvement comes exactly from the increased latency:
by waiting a little while (overhead of going from completion interrupt
to kthread scheduling) before processing completions, we take fewer
interrupts because we process completions in bigger batches.

So maybe a better solution would be something NAPI-like -- ie when a
completion occurs, schedule a tasklet that polls the CQ some number of
times, and if the CQ is not empty at the end, reschedule to tasklet to
poll the CQ again without reenabling the CQ notification... ie
adaptively go into a polling mode when the interrupt load goes up.

But maybe this should be done higher in the block stack?

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
