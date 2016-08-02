From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/uverbs: Fix race between uverbs_close and remove_one
Date: Tue, 2 Aug 2016 21:50:14 +0300
Message-ID: <CALq1K=LUb+bvx5+3JYLQw+OnhzP5MuqmuydMS8G7eS8Kvyb9Ow@mail.gmail.com>
References: <1467548899-21923-1-git-send-email-leon@kernel.org>
 <1467548899-21923-2-git-send-email-leon@kernel.org> <1470162706.18081.27.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470162706.18081.27.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 2, 2016 at 9:31 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Sun, 2016-07-03 at 15:28 +0300, Leon Romanovsky wrote:
>> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>>
>> Fixes an oops that might happen if uverbs_close races with
>> remove_one.
>>
>> Both contexts may run ib_uverbs_cleanup_ucontext, it depends
>> on the flow.
>>
>> Currently, there is no protection for a case that remove_one
>> didn't make the cleanup it runs to its end, the underlying
>> ib_device was freed then uverbs_close will call
>> ib_uverbs_cleanup_ucontext and OOPs.
>>
>> Above might happen if uverbs_close deleted the file from the list
>> then remove_one didn't find it and runs to its end.
>>
>> Fixes to protect against that case by a new cleanup lock so that
>> ib_uverbs_cleanup_ucontext will be called always before that
>> remove_one is ended.
>>
>> Fixes: 35d4a0b63dc0 ("IB/uverbs: Fix race between ib_uverbs_open and
>> remove_one")
>> Reported-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> The only reason I hadn't taken this patch before is because Jason said
> it was totally untested and someone (Devesh in this case) needed to
> test it to make sure it resolved their problem.  I don't see a test-by
> line here, so has this happened?

I can't say about Devesh, but we verified it as part of our verification phase.
Do you need anything special except Yishai's SOB?

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
