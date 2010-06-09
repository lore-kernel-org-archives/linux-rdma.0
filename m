From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa.c: In osm_sa_respond, only fill in attr
 offset if RMPP method
Date: Wed, 9 Jun 2010 15:48:48 +0300
Message-ID: <20100609124848.GE20172@me>
References: <20100603134209.GA12225@comcast.net>
 <20100609054341.GK28549@me>
 <AANLkTilkr6KYG_TVJYwvNl7sZ8XBKmFljktxg8qCA9t9@mail.gmail.com>
 <20100609121036.GC20172@me>
 <AANLkTikTxpvb-Nw2V1PrBcX4rZ1GwElXV22CBtBZx1iK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikTxpvb-Nw2V1PrBcX4rZ1GwElXV22CBtBZx1iK-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08:40 Wed 09 Jun     , Hal Rosenstock wrote:
> 
> I think the use of ib_get_attr_offset is being "overused". I'd rather
> see this patch used as it is the simplest way to address that rather
> than conditionalize ib_get_attr_offset on the SA attribute or would
> you rather see a patch along those lines ?

I just think that if the assertion is incorrect (and ib_get_attr_offset()
is generic function) we need to remove this. That is simplest.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
