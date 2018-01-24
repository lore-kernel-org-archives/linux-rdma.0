From: Rohit Zambre <rzambre-sXc7qaQca9o@public.gmane.org>
Subject: Re: 2x difference between multi-thread and multi-process for same
 number of CTXs
Date: Wed, 24 Jan 2018 17:04:45 -0600
Message-ID: <CAJ84Q-b_NR9cbFLvKO0WVDL4VqetVX1DoQkL6mFgBD6v+6dnRA@mail.gmail.com>
References: <CAJ84Q-aFfcXxaJS5rApcoow6SBjfZAvt71_OKo1ORorXAOZKbw@mail.gmail.com>
 <20180124170830.GD16845@ziepe.ca> <CAJ84Q-aMW7PXFFuODm6RN=SO342=tJ4_eSJ2TB0b8DLrxgwtGQ@mail.gmail.com>
 <20180124222240.GA10706@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180124222240.GA10706-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Balaji, Pavan" <balaji-uKDnm65ik8M@public.gmane.org>, Aparna Chandramowlishwaran <amowli-sXc7qaQca9o@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Anuj and Jason, thank you for your tips! Looking into it them right
now. Will update here.

Thanks
Rohit Zambre
Ph.D. Student, Computer Engineering
University of California, Irvine
rohitzambre dot com


On Wed, Jan 24, 2018 at 4:22 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> On Wed, Jan 24, 2018 at 02:53:13PM -0600, Rohit Zambre wrote:
>
>> Yes, that's correct. My concern was that during resource creation, the
>> kernel was maybe sharing some resource for a process or that some sort
>> of multiplexing was occurring to hardware contexts through control
>> groups. Is it safe for me to conclude that separate, independent
>> contexts/bfregs are being assigned when a process calls
>> ibv_open_device multiple times?
>
> I believe that is true.
>
> There is no obvious point of contention if you use multiple contexts
> and set the single threading flag..
>
> Is it possible your benchmark is actually working differently in the
> two modes? In a more broad sense, like the cluster network traffic
> pattern is detrimental in the thread case for some reason?
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
