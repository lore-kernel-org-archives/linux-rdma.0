From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 2/6] IB/uverbs: Enable QP creation which is
 associated to underlay QP
Date: Wed, 31 May 2017 20:05:55 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB13DC53@ORSMSX109.amr.corp.intel.com>
References: <20170530071602.8139-1-leon@kernel.org>
 <20170530071602.8139-3-leon@kernel.org> <20170530073352.GA1838@nanopsycho>
 <20170530075845.GA5406@mtr-leonro.local> <20170530081514.GB1838@nanopsycho>
 <20170530172259.GD5406@mtr-leonro.local> <20170530180357.GB24898@nanopsycho>
 <20170531042031.GG5406@mtr-leonro.local> <20170531053711.GA1882@nanopsycho>
 <20170531083955.GJ5406@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170531083955.GJ5406-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > How do you know? I might have one in my drawer :)
> 
> Because, we had this brave man [1] who wanted to implement libibverbs
> by
> himself in GO language and Jason gave a very good explanation [2, 3]
> why it
> is not likely to happen in near future.
> 
> [1] http://marc.info/?l=linux-rdma&m=149302796407374&w=2
> [2] http://marc.info/?l=linux-rdma&m=149305872017354&w=2
> [3] http://marc.info/?l=linux-rdma&m=149314196207011&w=2

I agree with Jiri.  This breaks uapi, and you can't assume that it's not being used, possibly by a forked version of libibverbs.

You could introduce an unnamed union.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
