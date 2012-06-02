From: =?utf-8?Q?Xavier_Gu=C3=A9rin?= <guerinx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: HCA concurrency
Date: Fri, 1 Jun 2012 22:03:07 -0400
Message-ID: <D399033B-B7B6-4105-B355-5143A65D760F@gmail.com>
References: <117D8742-93E9-4877-AEF3-6440888317E3@gmail.com> <1828884A29C6694DAF28B7E6B8A8237346A25998@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A25998-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Sean,

Thanks for your answer.

Im my case, SGE == 0 so I don't think I can go any lighter. It really looks like I am hitting some kind of barrier (I am still in PCIe 2.0, I should be able to run my test on PCIe 3.0 -enabled system next week, I'll send an update then) and from my analysis it looks like the barrier is the HW.

I would like to understand and make sure that I am exploiting the best parallelism out of the controller.

Thanks,

- Xavier

On Jun 1, 2012, at 7:48 PM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> In my test case to evaluate fetch-and-add, I spawn multiple threads, each
>> owning its own QP inside the same PD and context and sending fetch-and-add
>> requests without any inner contention (no lock, etc.). I quickly reach a
>> ceiling of about 900KOPS with 5/6 threads, and I have a hard time figuring out
>> why.
> 
> If you're setting inline data, try reducing it to 16 bytes or less.  We've seen small message rates drop drastically when using a larger inline data size.
> 
> - Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
