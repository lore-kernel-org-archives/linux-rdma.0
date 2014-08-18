From: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Subject: Re: [PATCH] infiniband: hw: cxgb3: cxio_hal.c: Cleaning up missing
 null-terminate after strncpy call
Date: Mon, 18 Aug 2014 18:25:36 +0200
Message-ID: <CAFo99gaOdTRp+aHtNJ6vigBXaeFemUWzT62QRRvFUTcF5bSopw@mail.gmail.com>
References: <1408315225-16807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <000001cfbaf0$829ba6f0$87d2f4d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000001cfbaf0$829ba6f0$87d2f4d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2014-08-18 16:27 GMT+02:00 Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>:
>
>
>> -----Original Message-----
>> From: linux-kernel-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-kernel-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]
>> On Behalf Of Rickard Strandqvist
>> Sent: Sunday, August 17, 2014 5:40 PM
>> To: Steve Wise; Roland Dreier
>> Cc: Rickard Strandqvist; Sean Hefty; Hal Rosenstock; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
>> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: [PATCH] infiniband: hw: cxgb3: cxio_hal.c: Cleaning up missing null-terminate
> after
>> strncpy call
>>
>> Added a guaranteed null-terminate after call to strncpy.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/cxgb3/cxio_hal.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c
>> b/drivers/infiniband/hw/cxgb3/cxio_hal.c
>> index de1c61b4..5fc04e4 100644
>> --- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
>> +++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
>> @@ -933,6 +933,7 @@ int cxio_rdev_open(struct cxio_rdev *rdev_p)
>>               netdev_p = rdev_p->t3cdev_p->lldev;
>>               strncpy(rdev_p->dev_name, rdev_p->t3cdev_p->name,
>>                       T3_MAX_DEV_NAME_LEN);
>> +             rdev_p->dev_name[T3_MAX_DEV_NAME_LEN - 1] = '\0';
>>       } else {
>>               PDBG("%s t3cdev_p or dev_name must be set\n", __func__);
>>               return -EINVAL;
>
> cxio_rdev_open() is called only by open_rnic_dev() which allocates the device structure by
> calling ib_alloc_device() which uses kzalloc().  So this change really isn't needed, is
> it?
>
> Steve.
>



Hi

Sure, strlcpy is preferable in many ways if we only can guarantee that
it is safe.
I have seldom received so much criticism when I start switching to
strlcpy, although much of it was justified :)
Even Linus was getting into the debate.  See more:

https://plus.google.com/111049168280159033135/posts/1amLbuhWbh5


I change to strlcpy only when I'm sure it will not cause any other problems.
But if you or anyone else can guarantee that in this case, so I'd make
a new patch with strlcpy.

And no Steve, or then you have to use:
strncpy(rdev_p->dev_name, rdev_p->t3cdev_p->name,
                        T3_MAX_DEV_NAME_LEN - 1);

But the kzalloc should mean that there will not be a problem to switch
to strlcpy ..

Do we agree, I'll make a new path with strlcpy?


I have run a static code analysis programs cppcheck, including finding
this type of problem.
But since I noticed that there were so many mistakes in addition, I
have now looked through all use of strncpy in kernel


Kind regards
Rickard Strandqvist
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
