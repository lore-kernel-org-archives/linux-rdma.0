From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] RDMA/cma: Remove netlink interface of CMA statistics
Date: Wed, 15 Nov 2017 09:50:22 +0200
Message-ID: <CAJ3xEMjrTvY+hq=1Q3tmPk_QiZtpO8dLMmCtrPjJgbtOeiU=6Q@mail.gmail.com>
References: <20171113144024.26655-1-leon@kernel.org> <20171113192432.GL6918@ziepe.ca>
 <20171114080550.GR18825@mtr-leonro.local> <CAJ3xEMhfdXz8zQFetjQPfe7HZiCi+N0z6r9XSucuTzQo1--PBg@mail.gmail.com>
 <20171114095605.GU18825@mtr-leonro.local> <CAJ3xEMhM0xfNxRU+37oWKq_w=MGtE3sUXy38bARgX5-3G9zhvw@mail.gmail.com>
 <20171114173516.GZ18825@mtr-leonro.local> <CAJ3xEMgJJX0FXMK9Rj=kGmNGkF14tBe03zfwzKHnEEp=cEDVxw@mail.gmail.com>
 <20171115052926.GN18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115052926.GN18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 15, 2017 at 7:29 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Tue, Nov 14, 2017 at 11:05:51PM +0200, Or Gerlitz wrote:
>> On Tue, Nov 14, 2017 at 7:35 PM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> > Can you help me to find an answer to my initial question?
>> > Are you using this CMA netlink interface?
>> > Do you know anyone who is using this interface?
>>
>> The rdma netlink code existed way before you got there and it has
>> various UAPIs that were/are used by multiple vendors..
>>
>> AFAIK we had @ Voltaire some management/provisioning SW that used these
>> CMA UAPIs and I am not sure where did it go after the V-acquisition
>
> I got my answers, you are not using this CMA netlink part and don't know
> anyone real with real code who uses.

This is UAPI, and you want to delete it, so your job is to go through
all the required
procedures for that.

But before that, you ignored my question asking what is broken in the
current code, please don't.

You can't come to someone's code say it's broken without providing the data
and ask to revert it.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
