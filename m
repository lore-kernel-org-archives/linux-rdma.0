From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V4 for-next 02/10] IB/core: Introduce Work Queue object
 and its verbs
Date: Tue, 31 May 2016 19:22:52 +0300
Message-ID: <5caa687f-31c8-34c1-eeae-3cbdaca80133@dev.mellanox.co.il>
References: <CAJ3xEMgVQaNdLhMZWQOaMcmgJ7WEWuL4C79r1eJ7f9ue9d6rGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgVQaNdLhMZWQOaMcmgJ7WEWuL4C79r1eJ7f9ue9d6rGw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Vainman <alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/30/2016 11:09 PM, Or Gerlitz wrote:
> On Mon, May 23, 2016 at 3:20 PM, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
>> +int ib_destroy_wq(struct ib_wq *wq)
>> +{
>> +       int err;
>> +       struct ib_cq *cq = wq->cq;
>> +       struct ib_pd *pd = wq->pd;
>> +
>> +       if (atomic_read(&wq->usecnt))
>> +               return -EBUSY;
>> +
>> +       err = wq->device->destroy_wq(wq);
>> +       if (!err) {
>> +               atomic_dec(&pd->usecnt);
>> +               atomic_dec(&cq->usecnt);
>> +       }
>> +       return err;
>
> by the reverse unwinding principle
>
>> +               atomic_inc(&pd->usecnt);
>> +               atomic_inc(&wq_attr->cq->usecnt);
>
> -->
>
>> +               atomic_dec(&cq->usecnt);
>> +               atomic_dec(&pd->usecnt);

The PD and the CQ are two unrelated objects, we are not dealing with 
locking order so the reverse principle is not required. Look also at 
ib_create/destroy QP for PD/CQ usage, behavior is the same.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
