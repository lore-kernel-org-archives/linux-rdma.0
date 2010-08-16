From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: RDMA tutorial feedback
Date: Sun, 15 Aug 2010 23:00:57 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9708393@orsmsx501.amr.corp.intel.com>
References: <AANLkTimDVeCu1ZTZTr1TvZF2vkSQ0keDVs4eheriywNN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimDVeCu1ZTZTr1TvZF2vkSQ0keDVs4eheriywNN-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tarick Bedeir <tarick.lists-LDovhz+uhNHQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> When I started working on an IB-aware app last year, I couldn't find
> much in the way of an RDMA/verbs/IB tutorial on the web.  This doesn't
> seem to have changed, so I put together a few posts on my blog that I
> hope will be of use to the next guy who's got to start from scratch:
> 
> http://thegeekinthecorner.wordpress.com/
> 
> I'm very interested in the community's feedback.

I think having something like this is great.

Since you've started this work, additional APIs and functionality have been added to the librdmacm which are intended to simplify connection establishment.  Notable changes include the addition of an rdma_getaddrinfo() call and support for synchronous operation.  If you download the latest librdmacm package from the OFA site, you can take a look at the new samples, rdma_server and rdma_client, which show how to make use of the new functionality.

A few wrapper functions around libibverbs calls were also added, but as those are inline calls, their use is limited.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
