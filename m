From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH] RDMA/core: reduce IB_POLL_BATCH constant
Date: Thu, 1 Mar 2018 11:36:50 +0200
Message-ID: <efc0302c-90e2-2e09-7525-dc9b9e247e73@mellanox.com>
References: <20180220205924.2035765-1-arnd@arndb.de>
 <1519161268.3737.12.camel@wdc.com>
 <F2FB1034-BFB6-45ED-878E-6FADD756157D@oracle.com>
 <c3eab137-1c37-0e6c-a53a-df2cf80653d2@grimberg.me>
 <0f90134c-3d40-1d24-711f-e4ab32802bd8@mellanox.com>
 <c1bcd5cc-381d-2d94-1278-f9fb5c9c0b14@grimberg.me>
 <20180227220958.GA21714@ziepe.ca>
 <193aaf91-c9d1-38b1-a89f-45f129ca5798@mellanox.com>
 <d2875648-20d9-43b9-abf1-8ecbf049c4bf@wdc.com>
 <1e7c373f-21bd-4d45-3dd6-68467bf09d0d@mellanox.com>
 <1519844114.28560.216.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519844114.28560.216.camel@redhat.com>
Content-Language: he
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, Jason Gunthorpe <jgg@ziepe.ca>, Sagi Grimberg <sagi@grimberg.me>
Cc: Chuck Lever <chuck.lever@oracle.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leonro@mellanox.com" <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 2/28/2018 8:55 PM, Doug Ledford wrote:
> On Wed, 2018-02-28 at 11:50 +0200, Max Gurtovoy wrote:
>>
>> On 2/28/2018 2:21 AM, Bart Van Assche wrote:
>>> On 02/27/18 14:15, Max Gurtovoy wrote:
>>>> -static int __ib_process_cq(struct ib_cq *cq, int budget, struct ib_wc
>>>> *poll_wc)
>>>> +static int __ib_process_cq(struct ib_cq *cq, int budget, struct ib_wc
>>>> *poll_wc,
>>>> +                          int batch)
>>>>    {
>>>> -       int i, n, completed = 0;
>>>> -       struct ib_wc *wcs = poll_wc ? : cq->wc;
>>>> +       int i, n, ib_poll_batch, completed = 0;
>>>> +       struct ib_wc *wcs;
>>>> +
>>>> +       if (poll_wc) {
>>>> +               wcs = poll_wc;
>>>> +               ib_poll_batch = batch;
>>>> +       } else {
>>>> +               wcs = cq->wc;
>>>> +               ib_poll_batch = IB_POLL_BATCH;
>>>> +       }
>>>
>>> Since this code has to be touched I think that we can use this
>>> opportunity to get rid of the "poll_wc ? : cq->wc" conditional and
>>> instead use what the caller passes. That will require to update all
>>> __ib_process_cq(..., ..., NULL) calls. I also propose to let the caller
>>> pass ib_poll_batch instead of figuring it out in this function.
>>> Otherwise the approach of this patch looks fine to me.
>>
>> Thanks Bart.
>> I'll make these changes and submit.
> 
> That sounds reasonable to me too, thanks for reworking and resubmitting.
> 

Sure, NP.
We've run NVMe-oF and SRP with the new patch.
I'll send it through Mellanox maintainers pull request.

Thanks for reporting and reviewing.

-Max.
