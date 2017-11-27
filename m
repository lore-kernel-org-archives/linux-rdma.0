From: Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH rdma-rc v2] IB/core: Only enforce security for InfiniBand
Date: Mon, 27 Nov 2017 16:58:21 -0600
Message-ID: <47653af5-68af-0aa1-e811-0d6d42935648@mellanox.com>
References: <20171127112554.29666-1-leon@kernel.org>
 <bd207403-a03f-5ced-7f44-6294c5a3ac8e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <bd207403-a03f-5ced-7f44-6294c5a3ac8e@redhat.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Don Dutile <ddutile@redhat.com>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: linux-rdma@vger.kernel.org, Paul Moore <paul@paul-moore.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 11/27/2017 4:03 PM, Don Dutile wrote:
> On 11/27/2017 06:25 AM, Leon Romanovsky wrote:
>> From: Daniel Jurgens <danielj@mellanox.com>
>>
>>
>> -    if (pps_change && !special_qp) {
>> +    if (pps_change && !special_qp && real_qp->qp_sec) {
>>          mutex_lock(&real_qp->qp_sec->mutex);
>>          new_pps = get_new_pps(real_qp,
>>                        qp_attr,
>> @@ -600,7 +627,7 @@ int ib_security_modify_qp(struct ib_qp *qp,
>>                           qp_attr_mask,
>>                           udata);
>>
>> -    if (pps_change && !special_qp) {
>> +    if (pps_change && !special_qp && real_qp->qp_sec) {
>>          /* Clean up the lists and free the appropriate
>>           * ports_pkeys structure.
>>           */
>>
> This patch breaks the kernel build on RHEL b/c it generates
> a warning in the second if (pps_change && !special_qp && real_qp->qp_sec) {}
> that new_pps may not be assigned. ... build warnings in RHEL kernel == build failure (on x86).
>
> That's b/c the patch adds real_qp->qp_sec to if's conditions,
> and  the compiler cannot determine if real_qp->qp_sec cannot be modified
> between the first check like it, above, which sets the value of new_pps,
> and the second check that uses it, because real_qp is passed into the device->modify()
> function call btwn those two if() check's.
>
> The code needs to do something like this in the first if-check:
>    .....
> bool new_pps_gotten = false;
>    ....
>
> if (pps_change && !special_qp && real_qp->qp_sec) {
>     mutex_lock(&real_qp->qp_sec->mutex);
>     new_pps = get_new_pps(real_qp,
>                   qp_attr,
>                   qp_attr_mask);
>     new_pps_gotten = true;
>         ....
> }
>      ....
>
> and change the second if check to be:
>
> if (new_pps_gotten) {
>     * Clean up the lists and free the appropriate
>      .....
>

Thanks Don, I think it's better to initialize new_pps to NULL, vs introducing a new variable. Also, there needs to be a check of new_pps after getting it.
