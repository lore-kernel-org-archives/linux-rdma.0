From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 08/10] i40iw: Control debug error prints using env
 variable
Date: Sun, 25 Dec 2016 18:16:33 +0200
Message-ID: <5dddda29-735a-1721-4bda-e2af6bbb9d32@dev.mellanox.co.il>
References: <20161214171111.GA4521@mtr-leonro.local>
 <20161214212103.GA6947@obsidianresearch.com>
 <20161215064807.GB811@mtr-leonro.local>
 <20161215165420.GA3264@obsidianresearch.com>
 <20161215183537.GH811@mtr-leonro.local>
 <20161215185034.GB16552@obsidianresearch.com>
 <20161215191751.GJ811@mtr-leonro.local>
 <13AA599688F47243B14FCFCCC2C803BB10AC7E53@fmsmsx104.amr.corp.intel.com>
 <20161215201917.GL811@mtr-leonro.local>
 <20161216042632.GC3797@obsidianresearch.com>
 <20161218081915.GC1074@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161218081915.GC1074-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/18/2016 10:19 AM, Leon Romanovsky wrote:
> On Thu, Dec 15, 2016 at 09:26:32PM -0700, Jason Gunthorpe wrote:
>> On Thu, Dec 15, 2016 at 10:19:17PM +0200, Leon Romanovsky wrote:
>>
>>>> Jason gave an example with "
>>>> VERBS_PROVIDER_DEBUG=qp,ah,blah". Should all of the environment
>>>> variables, enabling other features in rdma-core use a similar
>>>> approach?
>>>
>>> I think that Jason is over designing it, but it is better to ask him
>>> about it.
>>
>> Well, this is what mlx5 does for debugging and I want to see it move
>> to the common API. Are you saying we can get rid of the classifications??
>
> This is my personal opinion and Yishai can provide official opinion.
>

Useful debug mode should have classification and granularity, let's 
preserve this ability.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
