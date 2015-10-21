From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Use inner P_Key to determine netdev
Date: Wed, 21 Oct 2015 13:51:24 +0300
Message-ID: <56276E2C.2080903@mellanox.com>
References: <56252F7B.4000300@mellanox.com>
 <1445278165-18442-1-git-send-email-haggaie@mellanox.com>
 <20151019181953.GA19665@obsidianresearch.com>
 <5625E307.4090105@mellanox.com> <20151020164445.GB24608@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151020164445.GB24608-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/10/2015 19:44, Jason Gunthorpe wrote:
> On Tue, Oct 20, 2015 at 09:45:27AM +0300, Haggai Eran wrote:
>> On 19/10/2015 21:19, Jason Gunthorpe wrote:
>>> On Mon, Oct 19, 2015 at 09:09:25PM +0300, Haggai Eran wrote:
>>>> When discussing the patches to demux ids in rdma_cm instead of ib_cm, it
>>>> was decided that it is best to use the P_Key value in the packet headers
>>>> [1]. However, some drivers are currently unable to send correct P_Key in
>>>> GMP headers.
>>>
>>> You should explicitly describe the broken drivers in the commit text.
>> These are mlx5 and ipath. I'll add them to the commit message.
> 
> And ipath is actually ipath, the obsolete driver being removed, not
> qib? (ie we don't care about it?)
Right. qib is fine.

>> The remaining issue is that it doesn't respect the
>> ib_send_wr.ud.pkey_index field when sending.
> 
> But this is a very serious bug, to the point the mis-labeled packets
> may not even be delivered in some cases - you really care about the
> sub case where mis-labeled packets happen to be deliverable but don't
> parse right?
I understand the issue in mlx5 is serious but we've lived with it a long
time. In this patch I only wanted to work around it for the purpose of
fixing the regression introduced in 4.3.

> Well, don't forget to undo this patch when the mlx5 driver is fixed..
Of course.

Thanks,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
