From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [BUG]kworker blocked for more than 120 seconds in IB_CM/RDMA_CM
Date: Fri, 11 Nov 2016 08:41:42 -0800
Message-ID: <47429de9-d3ad-2a1f-744a-3a2d3ac4aecf@sandisk.com>
References: <CAD+HZHUF=tdeJo0bQUD8iCc+V40W1wrAPupFRFq3-VYrEuY7cA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAD+HZHUF=tdeJo0bQUD8iCc+V40W1wrAPupFRFq3-VYrEuY7cA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/11/2016 05:32 AM, Jack Wang wrote:
> Note: we're using 4.4.28 + MLNXOFED 3.3

Hello Jack,

How was MOFED built? Are you using the MOFED or the upstream RDMA kernel 
drivers? If you are using the MOFED RDMA kernel drivers you will have to 
contact Mellanox. Otherwise I propose to try to reproduce this with 
lockdep enabled in the kernel config. Maybe this lockup is triggered by 
lock inversion.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
