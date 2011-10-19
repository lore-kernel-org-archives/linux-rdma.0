From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: ib_srpt status
Date: Wed, 19 Oct 2011 11:42:23 -0700
Message-ID: <1319049743.18132.41.camel@haakon2.linux-iscsi.org>
References: <20111012092318.GA9405@lst.de>
	 <CAO+b5-rqc7Dq-7p1XRHrxVMP9JS5N26Ht1q8ee=KGRqpUintFQ@mail.gmail.com>
	 <1318956075.2454.10.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-oxcWM+Sh4t00SxPqbaNGj7uCJK8xgsoRaOxp-6Ac5EmQ@mail.gmail.com>
	 <1319045907.18132.15.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-pypAr6zEXY0eS8Fv06kt-FiYOLNp2PxqqTXnRTo7tfHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pypAr6zEXY0eS8Fv06kt-FiYOLNp2PxqqTXnRTo7tfHQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-10-19 at 20:09 +0200, Bart Van Assche wrote:
> On Wed, Oct 19, 2011 at 7:38 PM, Nicholas A. Bellinger
> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> > Btw, Roland asked me to take a look at the current set of module
> > parameters for ib_srpt, and see which could be removed and/or converted
> > to per SPR target endpoint configfs attributes..  So on that note, a few
> > questions for you on a couple of the module parameters:
> >
> > *) use_port_guid_in_session_name: This appears to be a legacy compat
> >   item, can this be safetly removed for mainline..?
> 
> As far as I know some people are still using this parameter.

Sure, but I think the question is if it's worth getting rid of for
mainline if it's something that the mainline code will not be using.

AFAICT it's still something we will never end up using with mainline
target infrastructure, right..?

> 
> > *) srpt_service_guid: Should this really have global scope..?
> 
> I'm afraid that having different values of this parameter for
> different HCAs would break failing over between HCAs.
> 

Ok, leaving srpt_service_guid as a single global module parameter.

> > Aside from those, i'm currently having a look to see which of the module
> > parameters are not used in the initial srpt_add_one() setup path, and
> > that using per SRP target endpoint configfs attributes would make sense.
> 
> My opinion is that the parameters used in srpt_add_one() also should
> be converted from module parameters into something that is
> configurable dynamically.

Sure, but the question is: Where can these parameters be set dynamically
if srpt_add_one() is called directly from modprobe..?

> ib_srpt users have already been asking to
> make e.g. srp_max_req_size configurable dynamically. It should be
> doable to reallocate the receive ring when there are no active
> sessions.
> 

Mmmm, I think I understand what you mean here, but will need to dig into
the code some more to make sure.  I'll try moving as much of these as
possible into per SRP target endpoint attributes, and will let you know
if I get stuck on any specific parameter.

Thanks,

--nab 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
