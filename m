From: Aaron Knister <aaron.knister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ipoib 10ge gateway
Date: Tue, 5 Jan 2010 19:27:57 -0500
Message-ID: <2B7CD63E-C426-4E24-ADD1-9866D7ABF9C9@gmail.com>
References: <e75d22a91001050706i228099d7qf6d745371d9547e9@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e75d22a91001050706i228099d7qf6d745371d9547e9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm about to set this up using a dell server, a 10 gig card and a qdr hca. Unfortunately I couldn't set up a bridge between infiniband and 10gige because brctl wouldn't add in the infiniband interface to a bridge. I had to use routing and different subnets between the two networks. I'll let you know of any performance numbers I get.

As an aside I would love to know how to pull an infiniband interface into a bridge.

On Jan 5, 2010, at 10:06 AM, Michael Di Domenico wrote:

> does anyone have any current performance metrics when using a server
> to transport data from 10G ethernet to infiniband.  i don't need
> specific vendor hero numbers, just a generalized throughput estimate
> and hw requirements.
> 
> thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
