From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 5/8] IB/srp: reduce local coverage for command submission
 and EH
Date: Mon, 03 Jan 2011 03:45:30 -0500
Message-ID: <1294044330.2600.2.camel@obelisk.thedillows.org>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
	 <1293139893-11678-6-git-send-email-dillowda@ornl.gov>
	 <AANLkTi=pRdoMWw4ZNy4JK9CoNGB=wyrThTNuDH+LUW0Y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=pRdoMWw4ZNy4JK9CoNGB=wyrThTNuDH+LUW0Y-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2011-01-02 at 18:16 +0100, Bart Van Assche wrote:
> On Thu, Dec 23, 2010 at 10:31 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> >
> > We only need locks to protect our lists and number of credits available.
> > By pre-consuming the credit for the request, we can reduce our lock
> > coverage to just those areas. If we don't actually send the request,
> > we'll need to put the credit back into the pool.
> >
> > [ ... ]
> >
> > -       iu->type = iu_type;
> > +       list_del_init(&iu->list);
> 
> Hello Dave,
> 
> As far as I can see the above call of list_del_init() can be modified
> into a list_del() call. The same holds for the other list_del_init()
> call introduced by this patch.

Most likely; there are several such instances that I've corrected from
by misinterpretation of the list debug code.

Thanks,

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
