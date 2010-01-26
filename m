From: Alex Chiang <achiang@hp.com>
Subject: Re: infiniband limit of 32 cards per system?
Date: Mon, 25 Jan 2010 20:59:06 -0700
Message-ID: <20100126035906.GA23347@ldl.fc.hp.com>
References: <20100125235013.GD2828@grease.ALLEYCAT> <adaiqapplv7.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753619Ab0AZD7M@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <adaiqapplv7.fsf@roland-alpha.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

* Roland Dreier <rdreier@cisco.com>:
> 
>  > My colleague points out the following enum in uverbs_main.c:
>  > 
>  > 	enum {
>  > 		IB_UVERBS_MAJOR       = 231,
>  > 		IB_UVERBS_BASE_MINOR  = 192,
>  > 		IB_UVERBS_MAX_DEVICES = 32
>  > 	};
>  > 
>  > Experimentally, we've determined that on a system where we
>  > plugged in 40 IB cards, OFED only reports 32 cards are present.
> 
> wow, 40 HCAs in one system !

HP sell some pretty big systems. :)

>  > If that enum is indeed the limiting factor, would someone mind
>  > explaining (or pointing me at TFM ;) why it's limited to 32
>  > devices?
> 
> That dates back to when device #s had 8 bits for major and 8 bits for
> minor.  We got one major assigned for IB, and had to split up the 256
> minors that gave us among userspace verbs, management access, etc.  And
> 32 seemed like a pretty reasonable limit for most uses.

Thanks for the explanation.

> Nowadays I guess we should look into expanding that to dynamic device
> numbers on overflow, assuming you do have a realistic situation where
> someone would want to use that many adapters per system.

Think of a large scale-up ia64 box, possibly running some
virtualization stack.

I'm guessing that it's not just a simple kernel fix though since
OFED has to change too, right?

/ac
