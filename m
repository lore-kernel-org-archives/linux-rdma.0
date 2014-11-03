From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs] Add MR re-registeration
Date: Mon, 3 Nov 2014 10:28:25 +0200
Message-ID: <54573CA9.8060202@mellanox.com>
References: <1414920605-18943-1-git-send-email-ogerlitz@mellanox.com> <20141103025049.GA31929@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141103025049.GA31929-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/11/2014 4:50 AM, Jason Gunthorpe wrote:
> On Sun, Nov 02, 2014 at 11:30:05AM +0200, Or Gerlitz wrote:
>
>> @@ -886,7 +887,7 @@ struct ibv_context_ops {
>>   	int			(*dealloc_pd)(struct ibv_pd *pd);
>>   	struct ibv_mr *		(*reg_mr)(struct ibv_pd *pd, void *addr, size_t length,
>>   					  int access);
>> -	struct ibv_mr *		(*rereg_mr)(struct ibv_mr *mr,
>> +	int			(*rereg_mr)(struct ibv_mr *mr,
>>   					    int flags,
>>   					    struct ibv_pd *pd, void *addr,
>>   					    size_t length,
>
> What is going on here?
>
> Signatures in the ops structure should not be changed without quite a
> bit more explanation. I'd like to see this in a dedicated patch with a
> proper discussion about why it is safe...
>
> (I admit, I'm confused how this patch is adding rereg_mr when it
>   already sort of seems to exist)
>
> Jason
>

Lets present the facts first - Neither ibv_rereg_mr nor the kernel ABI 
and command structure exist before this patch. The only thing that did 
exist was an API between libibverbs and the provider library.

As there was no way for a userspace program to ask for memory 
re-registration, AFAIK this op wasn't used by any provider.

Furthermore, re-registering a MR shouldn't change the user's MR handle!
Hence, there's no need to return information that the user already 
knows. Does ibv_modify_qp return struct ibv_qp? Both verbs should act 
similarly.

I don't mind re-spin this change into another patch, but since I don't 
consider the current state of libibverbs as having memory 
re-registration support, I don't think it's necessary.

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
