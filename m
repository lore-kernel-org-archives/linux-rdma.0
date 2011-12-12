From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 06/14] ib_srp: Micro-optimize completion handlers
Date: Mon, 12 Dec 2011 18:12:29 -0500
Message-ID: <1323731549.8787.1.camel@lap75545.ornl.gov>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012002.17829.bvanassche@acm.org>
	 <20111201163539.572ca669@thirdoffive.cmf.nrl.navy.mil>
	 <1322782369.11664.5.camel@lap75545.ornl.gov>
	 <CAO+b5-pFBEQybN+01heAzr=_dNCb7Sr7ri_o_hF1MnOeX4_idQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pFBEQybN+01heAzr=_dNCb7Sr7ri_o_hF1MnOeX4_idQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2011-12-12 at 06:41 -0500, Bart Van Assche wrote:
> On Fri, Dec 2, 2011 at 12:32 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > On Thu, 2011-12-01 at 16:35 -0500, chas williams - CONTRACTOR wrote:
> >> perhaps this should use the unlikely() macro instead:
> >>
> >>       if (unlikely(wc.status)) {
> >>               ...
> >>       }
> >
> > If it needs to change at all, this is the direction it should take.
> 
> Hi Dave,
> 
> Prepatch 3.2-rc5 has been released which means that the 3.3 merge
> window is coming closer. Do you have any other comments about this
> patch series than those already posted to the list ?

I do; I'm sorry to keep you waiting, but other pressures at work have
kept me occupied. I'll have feedback for you this week, or will do it
over the weekend if necessary.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
