From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 for-next 7/7] IB/core: Change completion channel to use
 the reworked objects schema
Date: Thu, 6 Apr 2017 17:14:10 +0300
Message-ID: <CAAKD3BDZ5zrcVJq8zPnjWYN6sASjkGMQXSHq=06ep1b1RDf9YA@mail.gmail.com>
References: <1491301907-32290-1-git-send-email-matanb@mellanox.com>
 <1491301907-32290-8-git-send-email-matanb@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373AB10FBBF@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB10FBBF-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 6, 2017 at 2:30 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> I need to study this more.  Just a couple of minor comments below.
>
>> diff --git a/drivers/infiniband/core/uverbs.h
>> b/drivers/infiniband/core/uverbs.h
>> index 5f8a7f2..826f827 100644
>> --- a/drivers/infiniband/core/uverbs.h
>> +++ b/drivers/infiniband/core/uverbs.h
>> @@ -102,17 +102,25 @@ struct ib_uverbs_device {
>>  };
>>
>>  struct ib_uverbs_event_file {
>> -     struct kref                             ref;
>> -     int                                     is_async;
>> -     struct ib_uverbs_file                  *uverbs_file;
>>       spinlock_t                              lock;
>>       int                                     is_closed;
>>       wait_queue_head_t                       poll_wait;
>>       struct fasync_struct                   *async_queue;
>>       struct list_head                        event_list;
>> +};
>
> I would rename this structure to something like ib_uverbs_event_queue, since the file aspect has been removed, with corresponding name changes where it is used.

Sure, the base structure could be renamed to ib_uverbs_event_queue.

>
>> +
>> +struct ib_uverbs_async_event_file {
>> +     struct ib_uverbs_event_file             ev_file;
>> +     struct ib_uverbs_file                  *uverbs_file;
>> +     struct kref                             ref;
>>       struct list_head                        list;
>>  };
>>
>> +struct ib_uverbs_completion_event_file {
>> +     struct ib_uobject_file                  uobj_file;
>> +     struct ib_uverbs_event_file             ev_file;
>> +};
>> +
>>  struct ib_uverbs_file {
>>       struct kref                             ref;
>>       struct mutex                            mutex;
>> @@ -120,7 +128,7 @@ struct ib_uverbs_file {
>>       struct ib_uverbs_device                *device;
>>       struct ib_ucontext                     *ucontext;
>>       struct ib_event_handler                 event_handler;
>> -     struct ib_uverbs_event_file            *async_file;
>> +     struct ib_uverbs_async_event_file       *async_file;
>>       struct list_head                        list;
>>       int                                     is_closed;
>>
>
>> @@ -253,10 +253,12 @@ void ib_uverbs_release_file(struct kref *ref)
>>       kfree(file);
>>  }
>>
>> -static ssize_t ib_uverbs_event_read(struct file *filp, char __user
>> *buf,
>> -                                 size_t count, loff_t *pos)
>> +static ssize_t ib_uverbs_event_read(struct ib_uverbs_event_file
>> *file,
>> +                                 struct ib_uverbs_file *uverbs_file,
>> +                                 struct file *filp, char __user *buf,
>> +                                 size_t count, loff_t *pos,
>> +                                 bool is_async)
>>  {
>> -     struct ib_uverbs_event_file *file = filp->private_data;
>>       struct ib_uverbs_event *event;
>>       int eventsz;
>>       int ret = 0;
>> @@ -275,12 +277,12 @@ static ssize_t ib_uverbs_event_read(struct file
>> *filp, char __user *buf,
>>                        * and wake_up() guarentee this will see the null
>> set
>>                        * without using RCU
>>                        */
>> -                                          !file->uverbs_file->device-
>> >ib_dev)))
>> +                                          !uverbs_file->device->ib_dev)))
>>                       return -ERESTARTSYS;
>>
>>               /* If device was disassociated and no event exists set an
>> error */
>>               if (list_empty(&file->event_list) &&
>> -                 !file->uverbs_file->device->ib_dev)
>> +                 !uverbs_file->device->ib_dev)
>>                       return -EIO;
>>
>>               spin_lock_irq(&file->lock);
>> @@ -288,7 +290,7 @@ static ssize_t ib_uverbs_event_read(struct file
>> *filp, char __user *buf,
>>
>>       event = list_entry(file->event_list.next, struct
>> ib_uverbs_event, list);
>>
>> -     if (file->is_async)
>> +     if (is_async)
>>               eventsz = sizeof (struct ib_uverbs_async_event_desc);
>>       else
>>               eventsz = sizeof (struct ib_uverbs_comp_event_desc);
>
> Consider adding an event size to ib_uverbs_event_file rather than assuming the size based on is_async.
>

Ok

>> @@ -318,11 +320,31 @@ static ssize_t ib_uverbs_event_read(struct file
>> *filp, char __user *buf,
>>       return ret;
>>  }
>>
>> -static unsigned int ib_uverbs_event_poll(struct file *filp,
>> +static ssize_t ib_uverbs_async_event_read(struct file *filp, char
>> __user *buf,
>> +                                       size_t count, loff_t *pos)
>> +{
>> +     struct ib_uverbs_async_event_file *file = filp->private_data;
>> +
>> +     return ib_uverbs_event_read(&file->ev_file, file->uverbs_file,
>> filp,
>> +                                 buf, count, pos, true);
>> +}
>> +
>> +static ssize_t ib_uverbs_comp_event_read(struct file *filp, char
>> __user *buf,
>> +                                      size_t count, loff_t *pos)
>> +{
>> +     struct ib_uverbs_completion_event_file *comp_ev_file =
>> +             filp->private_data;
>> +
>> +     return ib_uverbs_event_read(&comp_ev_file->ev_file,
>> +                                 comp_ev_file->uobj_file.ufile, filp,
>> +                                 buf, count, pos, false);
>> +}
>
> - Sean

Thanks for the review.

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
