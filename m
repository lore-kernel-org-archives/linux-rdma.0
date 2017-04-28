From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH][V2] IB/rxe: fix typo: "algorithmi" -> "algorithm"
Date: Fri, 28 Apr 2017 18:14:53 +0100
Message-ID: <ee6de221-24f0-bbb5-d684-a50aef0a73dc@canonical.com>
References: <20170424092642.29862-1-colin.king@canonical.com>
 <1493055896.31620.2.camel@perches.com> <1493399309.3041.158.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493399309.3041.158.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 28/04/17 18:08, Doug Ledford wrote:
> On Mon, 2017-04-24 at 10:44 -0700, Joe Perches wrote:
>> On Mon, 2017-04-24 at 10:26 +0100, Colin King wrote:
>>>
>>> trivial fix to typo in pr_err message
>> []
>>>
>>> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c
>>> b/drivers/infiniband/sw/rxe/rxe_verbs.c
>> []
>>>
>>> @@ -1324,7 +1324,7 @@ int rxe_register_device(struct rxe_dev *rxe)
>>>  
>>>  	rxe->tfm = crypto_alloc_shash("crc32", 0, 0);
>>>  	if (IS_ERR(rxe->tfm)) {
>>> -		pr_err("failed to allocate crc algorithmi
>>> err:%ld",
>>> +		pr_err("failed to allocate crc algorithm err:%ld",
>>
>> nicer to add a newline too
> 
> I added a newline and then applied the patch.  Thanks.
> 
Thanks Doug. I overlooked replying to the earlier email.

Colin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
