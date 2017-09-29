From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 02/12] IB/hfi1: Convert the macro AHG_HEADER_SET
 into an inline function
Date: Fri, 29 Sep 2017 10:01:33 -0400
Message-ID: <bccfd045-5209-1781-3021-b9f6b16534b8@intel.com>
References: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
 <20170926140009.15601.38666.stgit@scvm10.sc.intel.com>
 <20170927152118.GG2297@mtr-leonro.local>
 <1506526691.33755.5.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506526691.33755.5.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/27/2017 11:38 AM, Doug Ledford wrote:
> On Wed, 2017-09-27 at 18:21 +0300, Leon Romanovsky wrote:
>> On Tue, Sep 26, 2017 at 07:00:11AM -0700, Dennis Dalessandro wrote:
>>>
>>> -		AHG_HEADER_SET(ahg, diff, 0, 0, 12,
>>> -			       cpu_to_le16(LRH2PBC(lrhlen)));
>>> +		idx = ahg_header_set(ahg, idx, array_size, 0, 0,
>>> 12,
>>> +				     (__force
>>> u16)cpu_to_le16(LRH2PBC(lrhlen)));
>>
>> This "__force" looks suspicious to me and I think you have an error
>> here by
>> using cpu_to_le16 instead of cpu_to_be16.
> 
> I took this patch as is because it simply translates from the old to
> the new method of doing things.  If there is a bug here in the use of
> le16 instead if be16, then it existed before too and should be fixed in
> a separate, incremental fix patch.
> 

We will take a look and send a follow up patch.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
