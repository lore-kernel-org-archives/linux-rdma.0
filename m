From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [pull request][rdma-rc 00/11] IPoIB fixes for 4.13
Date: Thu, 27 Jul 2017 11:06:56 -0400
Message-ID: <3eb7d0e3-b1ef-533e-56ae-9cc6b65ddfc5@intel.com>
References: <20170726181232.7363-1-leon@kernel.org>
 <2679977c-6258-ed15-a234-3682b8be65f3@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2679977c-6258-ed15-a234-3682b8be65f3-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/27/2017 11:05 AM, Dennis Dalessandro wrote:
> On 7/26/2017 2:12 PM, Leon Romanovsky wrote:
>> The following changes since commit 
>> a62ab66b13a0f9bcb17b7b761f6670941ed5cd62:
>>
>>    RDMA/core: Initialize port_num in qp_attr (2017-07-20 11:24:13 -0400)
>>
>> are available in the git repository at:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git 
>> tags/rdma-rc-2017-07-26
>>
>> for you to fetch changes up to 5dc78ad1904db597bdb4427f3ead437aae86f54c:
>>
>>    IB/ipoib: Notify on modify QP failure only when relevant 
>> (2017-07-23 10:52:00 +0300)
>>
>> ----------------------------------------------------------------
>> IPoIB fixes for 4.13
>>
>> The patchset provides various fixes for IPoIB. It is combination of
>> fixes to various issues discovered during verification along with
>> static checkers cleanup patches.
>>
>> Most of the patches are from pre-git era and hence lack of Fixes lines.
> 
> I'm not sure that patches 4,6,7,8, and 11 really should go in the RC. I 
> think those should go to for-next. My opinion anyway.

Ugh, one of those days, hands move faster than brain. That should have 
said 9 instead of 11.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
