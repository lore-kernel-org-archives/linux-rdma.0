From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH] ib_srp: Test once whether iu allocation succeeded
Date: Thu, 13 Jan 2011 14:23:47 -0500
Message-ID: <1294946627.3667.23.camel@lap75545.ornl.gov>
References: <201101132002.26052.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <201101132002.26052.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-01-13 at 20:02 +0100, Bart Van Assche wrote:
> Merge the two tests whether information unit allocation succeeded into
> one. An intended side effect of this change is that gcc 4.4.4 does no
> longer complain that the variable 'req' might be used uninitialized in
> the function srp_queuecommand() when ib_srp is built with
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y. This was reported by Roland Dreier.

Thanks Bart,
Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
