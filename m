From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: infiniband: cxgb4: GCC warnings for 32 bit
Date: Tue, 05 Feb 2013 10:45:55 -0600
Message-ID: <51113743.6050403@opengridcomputing.com>
References: <1360059358.1343.37.camel@x61.thuisdomein>  <51112943.3040003@opengridcomputing.com> <1360082216.14826.17.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360082216.14826.17.camel-uMdlDhfIn7prKue/0VVhAg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/5/2013 10:36 AM, Paul Bolle wrote:
> On Tue, 2013-02-05 at 09:46 -0600, Steve Wise wrote:
>> On 2/5/2013 4:15 AM, Paul Bolle wrote:
>>> And why is 'cookie' __u64? Is struct cpl_fw6_msg_ofld_connection_wr_rpl
>>> used in userspace code? Can't 'cookie' be of type "struct sk_buff *"? Is
>>> there a requirement for it to be 64 bits wide on both 32 bit and 64 bit?
>> In general, these fields are __ types to highlight the fact that they
>> define an interface between the host driver and adapter firmware.
> That's something new for me. Is that a custom for infiniband drivers or
> is it used throughout the tree?

I'm not too sure how standardized this is.  I think its SOP for Chelsio 
drivers. :)

>> These
>> "cookie" fields are opaque to the firmware.  They are passed to firmware
>> in a work request and then reflected back to the host in the reply to
>> the work request.  Given this, I think there are two issues:
>>
>> 1) no swapping is really needed.  The values are opaque to firmware, and
>> thus can stay in host byte order.
>>
>> 2) to remove the warning, we need something like:
>>
>> req->cookie = (unsigned long)skb;
>>
>> and
>>    
>> rpl_skb = (struct sk_buff *)(unsigned long)req->cookie;
> That's is exactly what I came up with to silence these warnings. But I
> didn't dare to submit it because I was too puzzled with the current
> code. Anyhow, should I submit the (trivial) patch to fix this?

Sure.  Thanks.

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
