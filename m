From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/5] net/mlx4_core: remove module param controlling the
 vlan table size
Date: Tue, 11 Oct 2011 09:24:40 +0200
Message-ID: <4E93EF38.5040707@mellanox.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com> <alpine.LRH.2.00.1110101055050.11243@ogerlitz.voltaire.com> <CAG4TOxNaQicA6ExuNsw8V95mJPD+AQX5Wrfg+rCoBxdr2E+2ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxNaQicA6ExuNsw8V95mJPD+AQX5Wrfg+rCoBxdr2E+2ww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/10/2011 7:00 PM, Roland Dreier wrote:
> Can we really do this? Doesn't this break anyone who has this option 
> configured in modprobe.conf? 
> This is one reason why I hate adding module parameters -- you can't 
> just delete them later like this 

Yes, I now understand even better why you hate adding module params... 
specifically here, this table relates
only to IBoE users, which is relatively new (in since 2.6.37) and didn't 
hit yet most (if not all) of the
distros,  so I don't expect anything to break, makes sense?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
