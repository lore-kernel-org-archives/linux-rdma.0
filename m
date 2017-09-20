From: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/bnxt_re: Fix frame stack compilation warning
Date: Wed, 20 Sep 2017 11:27:44 -0400
Message-ID: <ebce1f47-c277-3987-2638-57071461a14c@redhat.com>
References: <20170919102213.30911-1-leon@kernel.org>
 <b73b905c-baa2-0cb6-bccc-5f259ccedc48@redhat.com>
 <20170919205647.GN5788@mtr-leonro.local>
 <CA+sbYW3JEwCUb5bcQBK6-8MF=EtQSU+KxQOw3m3srFOOOK8W=g@mail.gmail.com>
Reply-To: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+sbYW3JEwCUb5bcQBK6-8MF=EtQSU+KxQOw3m3srFOOOK8W=g@mail.gmail.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/20/2017 02:31 AM, Selvin Xavier wrote:
> On Wed, Sep 20, 2017 at 2:26 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> On Tue, Sep 19, 2017 at 02:24:19PM -0400, Jonathan Toppins wrote:
>>> On 09/19/2017 06:22 AM, Leon Romanovsky wrote:
>>>> Reduce stack size by dynamically allocating memory instead
>>>> of declaring large struct on the stack:
>>>>
>>>> drivers/infiniband/hw/bnxt_re/ib_verbs.c: In function ‘bnxt_re_query_qp’:
>>>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:1600:1: warning: the frame size of 1216 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>>>  }
>>>>  ^
>>>>
> 
>>>> -   memset(&qplib_qp, 0, sizeof(struct bnxt_qplib_qp));
>>>> -   qplib_qp.id = qp->qplib_qp.id;
>>>> -   qplib_qp.ah.host_sgid_index = qp->qplib_qp.ah.host_sgid_index;
>>>> +   qplib_qp = kzalloc(sizeof(*qplib_qp), GFP_KERNEL);
>>>                                                 ^^^^
>>> Can this process block? Further down in the code I see a call to kzalloc
>>> and they specifically use GFP_ATOMIC.
>>>
>>>     bnxt_qplib_query_qp() ->
>>>         bnxt_qplib_rcfw_alloc_sbuf()
>>>
>>> Looking through the rest of the function and what it calls I am thinking
>>> this function is assumed to not block so I think GFP_ATOMIC should be
>>> used here.
>>
>> bnxt_re_query_qp() is called as callback of ibdev->query_qp and it is
>> unlikely that this function will be called in non-blocking context.
>>
>> For me, It looks like an error to use GFP_ATOMIC down the call stack.
>>
>> P.S. Our mlx4/mlx5 use GFP_KERNEL in query_qp callbacks.
>>
> Thanks Leon and Jonathan for your comments.
> Agree that bnxt_qplib_rcfw_alloc_sbuf implementation can use GFP_KERNEL.
> GFP_ATOMIC was used because  this is a generic function. But none of the
> current callers of this function are in atomic context. I will post a
> patch to correct it.
> 
> Thanks Leon for taking care of this.
> 
> Acked-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> 

With Broadcom's response I am good with the changes.

Reviewed-by: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
