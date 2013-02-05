From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: infiniband: cxgb4: GCC warnings for 32 bit
Date: Tue, 05 Feb 2013 17:36:56 +0100
Message-ID: <1360082216.14826.17.camel@x61.thuisdomein>
References: <1360059358.1343.37.camel@x61.thuisdomein>
	 <51112943.3040003@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51112943.3040003@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Vipul Pandya <vipul@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2013-02-05 at 09:46 -0600, Steve Wise wrote:
> On 2/5/2013 4:15 AM, Paul Bolle wrote:
> > And why is 'cookie' __u64? Is struct cpl_fw6_msg_ofld_connection_wr_rpl
> > used in userspace code? Can't 'cookie' be of type "struct sk_buff *"? Is
> > there a requirement for it to be 64 bits wide on both 32 bit and 64 bit?
> 
> In general, these fields are __ types to highlight the fact that they 
> define an interface between the host driver and adapter firmware.

That's something new for me. Is that a custom for infiniband drivers or
is it used throughout the tree?

> These 
> "cookie" fields are opaque to the firmware.  They are passed to firmware 
> in a work request and then reflected back to the host in the reply to 
> the work request.  Given this, I think there are two issues:
> 
> 1) no swapping is really needed.  The values are opaque to firmware, and 
> thus can stay in host byte order.
> 
> 2) to remove the warning, we need something like:
> 
> req->cookie = (unsigned long)skb;
> 
> and
>   
> rpl_skb = (struct sk_buff *)(unsigned long)req->cookie;

That's is exactly what I came up with to silence these warnings. But I
didn't dare to submit it because I was too puzzled with the current
code. Anyhow, should I submit the (trivial) patch to fix this?


Paul Bolle
