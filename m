From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v5 5/9] IB/isert: Replace semaphore sem with completion
Date: Mon, 21 Nov 2016 14:33:02 +0200
Message-ID: <5489f4ef-02fb-5207-6261-c08ee805acae@grimberg.me>
References: <1479708496-9828-1-git-send-email-binoy.jayan@linaro.org>
 <1479708496-9828-6-git-send-email-binoy.jayan@linaro.org>
 <e1e4788d-9250-d4c3-937f-262bd9264a76@grimberg.me>
 <2625189.HB0S3sfnY7@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2625189.HB0S3sfnY7@wuerfel>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tatyana E Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma@vg
List-Id: linux-rdma@vger.kernel.org


>>> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
>>> index 6dd43f6..de80f56 100644
>>> --- a/drivers/infiniband/ulp/isert/ib_isert.c
>>> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
>>> @@ -619,7 +619,7 @@
>>>       mutex_unlock(&isert_np->mutex);
>>>
>>>       isert_info("np %p: Allow accept_np to continue\n", isert_np);
>>> -     up(&isert_np->sem);
>>> +     complete(&isert_np->comp);
>>>  }
>>>
>>>  static void
>>> @@ -2311,7 +2311,7 @@ struct rdma_cm_id *
>>>               isert_err("Unable to allocate struct isert_np\n");
>>>               return -ENOMEM;
>>>       }
>>> -     sema_init(&isert_np->sem, 0);
>>> +     init_completion(&isert_np->comp);
>>
>> This is still racy, a connect event can complete just before we
>> init the completion and *will* get lost...
>>
>> This code started off with a waitqueue which exposes the same
>> problem, see:
>> 531b7bf4bd79 Target/iser: Fix iscsit_accept_np and rdma_cm racy flow
>>
>> So, still NAK from me...
>
> I don't see what you mean here. The code using a waitqueue had no
> counter but the completion does.

The problem here is that init_completion sets the counter to zero
and between this thread wakes up and until it initializes comp->done
we might have another connect event completing it and I fail to
see how this is handled correctly.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
