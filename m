From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 06/14] ib_srp: Micro-optimize completion handlers
Date: Thu, 01 Dec 2011 18:32:49 -0500
Message-ID: <1322782369.11664.5.camel@lap75545.ornl.gov>
References: <201112011954.25811.bvanassche@acm.org>
 <201112012002.17829.bvanassche@acm.org>
 <20111201163539.572ca669@thirdoffive.cmf.nrl.navy.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20111201163539.572ca669-KCdNrDJlFBBhNwqIksvPR6qiWZVw4kCD+aIohriVLy8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chas williams - CONTRACTOR <chas-vT06rRrALxcmhCb6mdbn6A@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-12-01 at 16:35 -0500, chas williams - CONTRACTOR wrote:
> perhaps this should use the unlikely() macro instead:
> 
> 	if (unlikely(wc.status)) {
> 		...
> 	}

If it needs to change at all, this is the direction it should take.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
