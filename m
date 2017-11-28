From: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc v2] IB/core: Only enforce security for InfiniBand
Date: Tue, 28 Nov 2017 15:38:16 -0500
Message-ID: <71158cbc-030c-41f7-5ee9-d930bb6c4849@redhat.com>
References: <20171127112554.29666-1-leon@kernel.org>
 <bd207403-a03f-5ced-7f44-6294c5a3ac8e@redhat.com>
 <47653af5-68af-0aa1-e811-0d6d42935648@mellanox.com>
 <16d5d4c2-ea9e-765a-b0b7-a867c6a757d6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <16d5d4c2-ea9e-765a-b0b7-a867c6a757d6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/27/2017 06:28 PM, Don Dutile wrote:
> On 11/27/2017 05:58 PM, Daniel Jurgens wrote:
>> On 11/27/2017 4:03 PM, Don Dutile wrote:
>>> On 11/27/2017 06:25 AM, Leon Romanovsky wrote:
>>>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>
>>>>
>>>> -    if (pps_change && !special_qp) {
>>>> +    if (pps_change && !special_qp && real_qp->qp_sec) {
>>>>          mutex_lock(&real_qp->qp_sec->mutex);
>>>>          new_pps = get_new_pps(real_qp,
>>>>                        qp_attr,
>>>> @@ -600,7 +627,7 @@ int ib_security_modify_qp(struct ib_qp *qp,
>>>>                           qp_attr_mask,
>>>>                           udata);
>>>>
>>>> -    if (pps_change && !special_qp) {
>>>> +    if (pps_change && !special_qp && real_qp->qp_sec) {
>>>>          /* Clean up the lists and free the appropriate
>>>>           * ports_pkeys structure.
>>>>           */
>>>>
>>> This patch breaks the kernel build on RHEL b/c it generates
>>> a warning in the second if (pps_change && !special_qp && real_qp->qp_sec) {}
>>> that new_pps may not be assigned. ... build warnings in RHEL kernel == build failure (on x86).
>>>
>>> That's b/c the patch adds real_qp->qp_sec to if's conditions,
>>> and  the compiler cannot determine if real_qp->qp_sec cannot be modified
>>> between the first check like it, above, which sets the value of new_pps,
>>> and the second check that uses it, because real_qp is passed into the device->modify()
>>> function call btwn those two if() check's.
>>>
>>> The code needs to do something like this in the first if-check:
>>>    .....
>>> bool new_pps_gotten = false;
>>>    ....
>>>
>>> if (pps_change && !special_qp && real_qp->qp_sec) {
>>>     mutex_lock(&real_qp->qp_sec->mutex);
>>>     new_pps = get_new_pps(real_qp,
>>>                   qp_attr,
>>>                   qp_attr_mask);
>>>     new_pps_gotten = true;
>>>         ....
>>> }
>>>      ....
>>>
>>> and change the second if check to be:
>>>
>>> if (new_pps_gotten) {
>>>     * Clean up the lists and free the appropriate
>>>      .....
>>>
>>
>> Thanks Don, I think it's better to initialize new_pps to NULL, vs introducing a new variable. Also, there needs to be a check of new_pps after getting it.
>>
> yup, I considered that as well.
> wasn't sure if lockdep checking code would not like the fact that a mutex_lock() could be taken,
> but if new_pps == NULL after the get call(it may always succeed, but an analyzer may not conclude the same),
> that the mutex_unlock() wouldn't be called.
>
> the double, same-condition if-check with the fcn call in btwn seems like it ought to be
> restructured differently so the mutex lock/unlock pairs are contained neatly in a single if-clause,
> and the new_pps alloc & use would be similarly containted.
>
> -dd
>
> -
Is someone doing a v3? I didn't see an email today w/another patch version.
... at least I wasn't directly cc'd on one anyhow... off to check linux-rdma folder...
nothing there... and I don't find a v3 in Leon's tree either.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
