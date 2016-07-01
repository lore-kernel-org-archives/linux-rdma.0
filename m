From: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Subject: Re: [PATCH 04/12] selinux: Allocate and free infiniband security
 hooks
Date: Fri, 1 Jul 2016 14:16:14 -0700
Message-ID: <b3ddd8ac-3917-ddf5-6c57-979a24dcbd20@schaufler-ca.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-5-git-send-email-danielj@mellanox.com>
 <CAGH-KgvtN8T7e5bKq0jJZvSzrGfFwA2VpmPf5gJuqdLZi6odEw@mail.gmail.com>
 <6662b3b0-6897-8775-dc30-2757387428e4@schaufler-ca.com>
 <AM4PR0501MB2257ADAB527392547179F779C4240@AM4PR0501MB2257.eurprd05.prod.outlook.com>
 <CAGH-KgtKkCvynjRJKAvVxdQdCj727bH0eaHBLj3RJY2=GW=D9g@mail.gmail.com>
 <DB6PR0501MB2261A2F4D095F672A814388DC4250@DB6PR0501MB2261.eurprd05.prod.outlook.com>
 <CAGH-Kgtz7pXNJrcc-OOwGyefzm5MpsVqjyZ+UaR9pefoNMWiwg@mail.gmail.com>
 <4bdbd27c-ff4a-db87-a550-cd187cbc07c6@schaufler-ca.com>
 <DB6PR0501MB226138FF74D031F6BD1C48C6C4250@DB6PR0501MB2261.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB6PR0501MB226138FF74D031F6BD1C48C6C4250-wTfl6qNNZ1NK98U9gK7MJ8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/1/2016 1:46 PM, Daniel Jurgens wrote:
> On 7/1/2016 3:13 PM, Casey Schaufler wrote:
>> On 7/1/2016 12:17 PM, Paul Moore wrote:
>>> On Fri, Jul 1, 2016 at 2:59 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>> On 7/1/2016 1:54 PM, Paul Moore wrote:
>>>>> On Thu, Jun 30, 2016 at 5:48 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>>>> On 6/30/2016 4:06 PM, Casey Schaufler wrote:
>>>>>>> On 6/30/2016 1:42 PM, Paul Moore wrote:
>>>>>>>>>  };
>>>>>>>>>
>>>>>>>>>  /**
>>>>>>>>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>>>>>>>>> index 3f6780b..e522acb 100644
>>>>>>>>> --- a/include/rdma/ib_verbs.h
>>>>>>>>> +++ b/include/rdma/ib_verbs.h
>>>>>>>>> @@ -1454,6 +1454,7 @@ struct ib_qp {
>>>>>>>>>         void                   *qp_context;
>>>>>>>>>         u32                     qp_num;
>>>>>>>>>         enum ib_qp_type         qp_type;
>>>>>>>>> +       struct ib_qp_security  *qp_sec;
>>>>>>>> See my earlier question/comment about just using a void pointer here.
>>>>>>> I think that this is in response to my comments to the
>>>>>>> effect that I would like to see the LSM infrastructure
>>>>>>> using the inode like (inode->i_security) to the xfrm
>>>>>>> (void *) approach. I haven't been looking at the IB patches
>>>>>>> too carefully to date. It's possible I have not been clear.
>>>>>> My understanding at the time was that by using something other than a void * different security modules could maintain their own opaque blobs with in and keep the same prototype for the hook.  It's possible I misunderstood you, but it made sense to me.  I don't know of any plans for other security modules to support Infiniband, but this leaves the door open.
>>>>> All of what you describe above can still happen with a void pointer;
>>>>> in some ways it is even easier with a void pointer.
>>>> If multiple security modules register an alloc_security hook for example, how would you coordinate between them to allocate the memory?
>>> You worry about that in the LSM framework and hide the details behind
>>> the void pointer.  For example, you create an array/list of LSM
>>> specific blobs and just stash a pointer to the head of the data in the
>>> void pointer.
>> Don't worry about it at this point. Patches pending.
>> If I have to change modules to accommodate the
>> infrastructure I'm not afraid to do so.
> So I should revert to void* blobs?  I just want to be clear before making the change.
>
Whichever you're really comfortable with.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
