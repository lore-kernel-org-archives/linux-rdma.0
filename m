From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] vmw_pvrdma: Fix SRQN returned to library
Date: Mon, 12 Feb 2018 14:23:18 -0800
Message-ID: <ab90a493-3680-d776-e52b-3918b2bd1a6a@vmware.com>
References: <1518460956-4629-1-git-send-email-aditr@vmware.com>
 <20180212185906.GE5005@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180212185906.GE5005-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/12/18 10:59 AM, Jason Gunthorpe wrote:
> On Mon, Feb 12, 2018 at 10:42:36AM -0800, Adit Ranadive wrote:
>> From: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>>
>> Here's a fix for the vmw_pvrdma library. It needs to go into the
>> stable branch for 16.0 as well since we can then add it to OFED-4.8-2.
>>

<snip>

> 
> I can't make sense of this.
> 
> Why doesn't grep turn up anything for struct pvrdma_create_srq_resp in
> the kernel?

Do you mean user_pvrdma_create_srq_resp? There isn’t one. 
Its part of our ABI fix up in rdma-core.

> 
> And why do we have two things called srqn in this struct?

It looks like the uverbs in the kernel reports the XRC SRQN in the one of
these while the other gets populated by the driver in the udata here. The SRQN
for a regular SRQ only gets reported in this second srqn field.
I'm not sure why that's the case but we need to report the one from the
driver here then.

> 
> Jason
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
