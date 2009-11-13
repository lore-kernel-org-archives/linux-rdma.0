From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/1] opensm/main.c: opensm cannot be killed while
 asking for port guid
Date: Fri, 13 Nov 2009 22:04:55 +0200
Message-ID: <20091113200455.GR7192@me>
References: <4AF46DEB.7090105@sgi.com>
 <20091113025527.GE7192@me>
 <20091112192422.E16537@viper.engr.sgi.com>
 <20091113130308.GM7192@me>
 <4AFDAB9F.6020900@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AFDAB9F.6020900-sJ/iWh9BUns@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Reed <mdr-sJ/iWh9BUns@public.gmane.org>
Cc: Sammy Wilborn <samm-sJ/iWh9BUns@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Higdon <jeremy-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12:55 Fri 13 Nov     , Michael Reed wrote:
> 
> > This works too. Would you care about the patch?
> 
> I think the point is to not upset the customer by suggesting that
> they are "lame".

I don't think that our customers can be upset so easily :). Seriously
the original phrase is here for many many years and was introduced by
Mellanox OpenSM production branch merging back, likely they didn't
have a lot of complains about this. On my memory it is the first one.
OTOH it is really minor and IMO feel free to change this.

> OFED, meet customer spending LOTS of money.  Customer,
> meet OFED!  :)

EWG list is a better place to discuss OFED and customer's money.

> Do you need a patch submitted making that change?

I don't care about this. If you are please submit the patch, this is a
normal procedure. Alternatively you can open bug in OFED bugzilla and
wait that somebody will do it for you or do nothing.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
