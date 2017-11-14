From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] RDMA/cma: Remove netlink interface of CMA statistics
Date: Tue, 14 Nov 2017 23:05:51 +0200
Message-ID: <CAJ3xEMgJJX0FXMK9Rj=kGmNGkF14tBe03zfwzKHnEEp=cEDVxw@mail.gmail.com>
References: <20171113144024.26655-1-leon@kernel.org> <20171113192432.GL6918@ziepe.ca>
 <20171114080550.GR18825@mtr-leonro.local> <CAJ3xEMhfdXz8zQFetjQPfe7HZiCi+N0z6r9XSucuTzQo1--PBg@mail.gmail.com>
 <20171114095605.GU18825@mtr-leonro.local> <CAJ3xEMhM0xfNxRU+37oWKq_w=MGtE3sUXy38bARgX5-3G9zhvw@mail.gmail.com>
 <20171114173516.GZ18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114173516.GZ18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 7:35 PM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Tue, Nov 14, 2017 at 06:04:07PM +0200, Or Gerlitz wrote:
>> On Tue, Nov 14, 2017 at 11:56 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> > On Tue, Nov 14, 2017 at 10:51:31AM +0200, Or Gerlitz wrote:
>>
>> >> what didn't work exactly?
>>
>> > Started from compilation, continued to wrong data presented.
>> > There is no need to carry 7-years old code, which no one cares about it.
>>
>> The cma kernel code doesn't compile for seven years, impossible.. you
>> are referring maybe to some user-space code. Re presenting wrong data,
>> again, you mean the user-space code or the kernel code sending wrong
>> data to user-space? please be precise.

> User-space application didn't compile and kernel sent wrong data.

Can you answer my question and point out the code that provides wrong
data to user-space?!

> Can you help me to find an answer to my initial question?
> Are you using this CMA netlink interface?
> Do you know anyone who is using this interface?

The rdma netlink code existed way before you got there and it has
various UAPIs that were/are used by multiple vendors..

AFAIK we had @ Voltaire some management/provisioning SW that used these
CMA UAPIs and I am not sure where did it go after the V-acquisition
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
