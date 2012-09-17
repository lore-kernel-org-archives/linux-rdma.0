From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH] ib_srp: Fix use-after-free in srp_reset_req()
Date: Mon, 17 Sep 2012 16:28:55 -0400
Message-ID: <1347913735.12412.6.camel@frustration.ornl.gov>
References: <5037572A.4040006@acm.org>
	 <1347910310.12412.5.camel@frustration.ornl.gov>
	 <CAL1RGDUA-bFbiiy7uvUBLRM7NpfNW6TPqF34yFo19+Z3=CNZGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUA-bFbiiy7uvUBLRM7NpfNW6TPqF34yFo19+Z3=CNZGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2012-09-17 at 15:50 -0400, Roland Dreier wrote:
> On Mon, Sep 17, 2012 at 12:31 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > Roland, are you planning to apply this one and the one Bart has that
> > fixes the error handling (srp_aport)? I didn't see them in your pull
> > request.
> 
> Sorry, I guess I missed them.
> 
> I think I'll probably just put it into 3.7 with a stable tag at this point.

Ok, as long as they make it to stable, I'm happy. Should you happen to
have reason for another push for 3.6, please consider them.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
