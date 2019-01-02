From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Wed, 2 Jan 2019 09:43:56 +0800
Message-ID: <61230e99-9b16-e1f2-93cf-637f0280f4df@oracle.com>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180112163247.GB15974@ziepe.ca> <1515775567.131759.42.camel@gmail.com>
 <a40e44f4-106b-1075-8f92-f7741508372c@oracle.com>
 <af562737-4a3e-0429-1fd6-fc25c3e3f867@mellanox.com>
 <fea0aa1c-b68e-9485-3826-2dfad7824911@oracle.com>
 <53b1ac4d-a294-eb98-149e-65d7954243da@oracle.com>
 <1516376999.3606.39.camel@gmail.com>
 <dfc02a48-7d2a-56da-dc4e-d90a9fcc559c@mellanox.com>
 <339a7156-9ef1-1f3c-30b8-3cc3558d124e@mellanox.com>
 <c8b0955b-a3fc-afe2-2c67-e655ca2ee6f6@oracle.com>
 <532b4d71-e2eb-35f3-894e-1c3288e7bc3f@oracle.com>
 <1516852543.3715.43.camel@gmail.com>
 <89066a75-43db-0f62-f171-70b0abaa8ea0@oracle.com>
 <918db4ec-8c3c-aafa-4be6-0e00a99632e2@mellanox.com>
 <c60ee78e-3cee-c188-7259-e7ad393e6bae@oracle.com>
 <d9883261-e93e-400a-757c-3a81d8b6aca1@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d9883261-e93e-400a-757c-3a81d8b6aca1@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, Eric Dumazet <eric.dumazet@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: "junxiao.bi@oracle.com" <junxiao.bi@oracle.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



On 12/31/18 12:27 AM, Tariq Toukan wrote:
> 
> 
> On 1/27/2018 2:41 PM, jianchao.wang wrote:
>> Hi Tariq
>>
>> Thanks for your kindly response.
>> That's really appreciated.
>>
>> On 01/25/2018 05:54 PM, Tariq Toukan wrote:
>>>
>>>
>>> On 25/01/2018 8:25 AM, jianchao.wang wrote:
>>>> Hi Eric
>>>>
>>>> Thanks for you kindly response and suggestion.
>>>> That's really appreciated.
>>>>
>>>> Jianchao
>>>>
>>>> On 01/25/2018 11:55 AM, Eric Dumazet wrote:
>>>>> On Thu, 2018-01-25 at 11:27 +0800, jianchao.wang wrote:
>>>>>> Hi Tariq
>>>>>>
>>>>>> On 01/22/2018 10:12 AM, jianchao.wang wrote:
>>>>>>>>> On 19/01/2018 5:49 PM, Eric Dumazet wrote:
>>>>>>>>>> On Fri, 2018-01-19 at 23:16 +0800, jianchao.wang wrote:
>>>>>>>>>>> Hi Tariq
>>>>>>>>>>>
>>>>>>>>>>> Very sad that the crash was reproduced again after applied the patch.
>>>>>>>>
>>>>>>>> Memory barriers vary for different Archs, can you please share more details regarding arch and repro steps?
>>>>>>> The hardware is HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 12/27/2015
>>>>>>> The xen is installed. The crash occurred in DOM0.
>>>>>>> Regarding to the repro steps, it is a customer's test which does heavy disk I/O over NFS storage without any guest.
>>>>>>>
>>>>>>
>>>>>> What is the finial suggestion on this ?
>>>>>> If use wmb there, is the performance pulled down ?
>>>
>>> I want to evaluate this effect.
>>> I agree with Eric, expected impact is restricted, especially after batching the allocations.>
>>>>>
>>>>> Since https://urldefense.proofpoint.com/v2/url?u=https-3A__git.kernel.org_pub_scm_linux_kernel_git_davem_net-2Dnext.git_commit_-3Fid-3Ddad42c3038a59d27fced28ee4ec1d4a891b28155&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=7WdAxUBeiTUTCy8v-7zXyr4qk7sx26ATvfo6QSTvZyQ&m=c0oI8duFkyFBILMQYDsqRApHQrOlLY_2uGiz_utcd7s&s=E4_XKmSI0B63qB0DLQ1EX_fj1bOP78ZdeYADBf33B-k&e=
>>>>>
>>>>> we batch allocations, so mlx4_en_refill_rx_buffers() is not called that often.
>>>>>
>>>>> I doubt the additional wmb() will have serious impact there.
>>>>>
>>>
>>> I will test the effect (it'll be beginning of next week).
>>> I'll update so we can make a more confident decision.
>>>
>> I have also sent patches with wmb and batching allocations to customer and let them check whether the performance is impacted.
>> And update here asap when get feedback.
>>
>>> Thanks,
>>> Tariq
>>>
> 
> Hi Jianchao,
> 
> I am interested to push this bug fix.
> Do you want me to submit, or do it yourself?
> Can you elaborate regarding the arch with the repro?
> 
> This is the patch I suggest:
> 
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -161,6 +161,8 @@ static bool mlx4_en_is_ring_empty(const struct 
> mlx4_en_rx_ring *ring)
> 
>   static inline void mlx4_en_update_rx_prod_db(struct mlx4_en_rx_ring *ring)
>   {
> +       /* ensure rx_desc updating reaches HW before prod db updating */
> +       wmb();
>          *ring->wqres.db.db = cpu_to_be32(ring->prod & 0xffff);
>   }
> 

Hi Tariq

Happy new year !

The customer provided confused test result for us.
The fix cannot fix their issue.

And we finally find a upstream fix
5d70bd5c98d0e655bde2aae2b5251bdd44df5e71
(net/mlx4_en: fix potential use-after-free with dma_unmap_page)
and killed the issue during Oct 2018. That's really a long way.

Please go ahead with this patch.

Thanks
Jianchao
