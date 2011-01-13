From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: srp warning
Date: Thu, 13 Jan 2011 14:22:31 -0500
Message-ID: <1294946551.3667.22.camel@lap75545.ornl.gov>
References: <adalj2q587i.fsf@cisco.com>
 <1294854748.15826.26.camel@lap75545.ornl.gov> <ada8vyq57bq.fsf@cisco.com>
 <1294861341.15826.38.camel@lap75545.ornl.gov> <adaoc7l52hy.fsf@cisco.com>
 <adak4i952bk.fsf@cisco.com> <1294866460.15826.41.camel@lap75545.ornl.gov>
 <AANLkTi=RP74hwT5nEr7XHyADPoE-7LKs8ECT_5QfS4pZ@mail.gmail.com>
 <1294932071.3667.5.camel@lap75545.ornl.gov>
 <AANLkTinxZ=x9uQH-r1TN003HT1aKu_KjgF8-aXDkKzTm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <AANLkTinxZ=x9uQH-r1TN003HT1aKu_KjgF8-aXDkKzTm-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-01-13 at 14:10 -0500, Bart Van Assche wrote:
> On Thu, Jan 13, 2011 at 4:21 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > Please drop the unlikely -- it isn't at all unlikely on the hardware and
> > loads I run.
[snip]
> But it surprises me that on the hardware and loads you run it
> regularly happens that iu == NULL -- a recent patch had the exact
> purpose to avoid that ("IB/srp: Reduce number of BUSY conditions").
> With that patch it should only occur that iu == NULL if the target
> violates the SRP spec by sending target-initiated information units so
> fast that there is more than one unanswered request.

Some devices return credits in batches, so we have IUs but no credits to
send them.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
