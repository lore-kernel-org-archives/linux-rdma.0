From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next 13/22] RDMA/hns: Remove empty functions
Date: Tue, 15 Aug 2017 11:36:49 +0800
Message-ID: <53ea1ede-848a-25b1-5fac-bd1594a2e143@huawei.com>
References: <20170811105003.7661-1-leon@kernel.org>
 <20170811105003.7661-14-leon@kernel.org>
 <fe444f34-ec1e-a5bb-34cb-0c34499d1e21@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fe444f34-ec1e-a5bb-34cb-0c34499d1e21-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

在 2017/8/11 20:26, Dennis Dalessandro 写道:
> On 8/11/2017 6:49 AM, Leon Romanovsky wrote:
>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> The functions which are not implemented can be simply ignored
>> instead of defining empty function. This patch removes such functions
>> from hns driver.
>>
>> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> I thought I replied about this or a very similar patch, but can't find the link. Regardless, I think these sort of work-in-progress stubs are OK as incremental development, part of  "showing your work" but I would have expected to see them implemented in the same series, or at least soon there-after. So the fact that these are still empty after this much time. I agree, get rid of them.
>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> .
>
Hi, Dennis Dalessandro

  I have tested it on D05 board and the result is fail. The detail anlaysis refer to my reply email for

[rdma-next v1 13/22] patch.


Thanks

Lijun Ou


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
