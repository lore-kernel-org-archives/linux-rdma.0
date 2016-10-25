From: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/8] IB/core: Replace semaphore sm_sem with completion
Date: Tue, 25 Oct 2016 17:48:09 +0200
Message-ID: <CAD+HZHUogpW5v0fhuBTDFc4irut-RXTvm7JbyGfoNQYQ9k-NaA@mail.gmail.com>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org>
 <1477396919-27669-3-git-send-email-binoy.jayan@linaro.org>
 <CAD+HZHXQE=VptiyLfSdw4MsZR=bjEj_XAB19_=YdjzPY96EK_g@mail.gmail.com> <CAHv-k_86z3MTYePPQcs5fWSqFeoGxt7UYG_b-SyZGQ7zVW-hSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHv-k_86z3MTYePPQcs5fWSqFeoGxt7UYG_b-SyZGQ7zVW-hSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Binoy,
2016-10-25 17:08 GMT+02:00 Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>:
> On 25 October 2016 at 18:13, Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi Binoy,
>>
>> snip
>>>
>>>         port->ib_dev   = device;
>>>         port->port_num = port_num;
>>> -       sema_init(&port->sm_sem, 1);
>>> +       init_completion(&port->sm_comp);
>>> +       complete(&port->sm_comp);
>>
>> Why complete here?
>>
>>>         mutex_init(&port->file_mutex);
>>>         INIT_LIST_HEAD(&port->file_list);
>>>
>>> --
>> KR,
>> Jinpu
>
>
> Hi Jack,
>
> ib_umad_sm_open() calls wait_for_completion_interruptible() which comes before
> ib_umad_sm_close() that calls complete(). In the initial open() there
> will not be
> anybody to signal the completion, so the complete is called to mark
> the initial state.
> I am not sure if this is the right way to do it, though.
>
> -Binoy

>From Documentation/scheduler/completion.txt ,
"
117 This is not implying any temporal order on wait_for_completion() and the
118 call to complete() - if the call to complete() happened before the call
119 to wait_for_completion() then the waiting side simply will continue
120 immediately as all dependencies are satisfied if not it will block until
121 completion is signaled by complete().
"
In this case here, if sm_open/sm_close are paired, it should work.

KR
Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
