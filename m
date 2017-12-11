From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 6/8] verbs: Fill in the libibverbs.map file
Date: Mon, 11 Dec 2017 18:22:37 +0200
Message-ID: <56bb7926-5179-376d-a353-3d02fbd3b463@dev.mellanox.co.il>
References: <20171205231721.19410-1-jgg@ziepe.ca>
 <20171205231721.19410-7-jgg@ziepe.ca>
 <38cbce8e-d177-b4eb-efec-c54951b1cb29@dev.mellanox.co.il>
 <20171211154811.GA6162@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171211154811.GA6162-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/11/2017 5:48 PM, Jason Gunthorpe wrote:
> On Sun, Dec 10, 2017 at 07:01:52PM +0200, Yishai Hadas wrote:
>> On 12/6/2017 1:17 AM, Jason Gunthorpe wrote:
>>> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> Several of the 'latest' verbs are missing from the map file.
>>
>> Which 'latest' verbs are you referring to ? quite hard to follow post the
>> sort.
> 
> Pretty much all the ones listed as '+' in - 'latest' means they are
> using LATEST_SYMVER_FUNC
> 
>>> The linker does the right thing anyhow since they are tagged with the
>>> .symver assembler directive, but let us list them anyhow so that the
>>> map file is a complete list of symbols.
>>
>> If the linker does the work why do we really need to maintain it now and in
>> the future ?
> 
> Technicaly all symbols should be in the map file. I would view the
> linker exposing symbols not in the map file as some weird behavior we
> shouldn't rely on.

You have added the extra symbols under 'IBVERBS_1.1', but this section 
already includes 'IBVERBS_1.0' at part of its definition in the map 
file. For example 'ibv_destroy_srq' now appears twice in both 1.0 and 1.1.
Why current map file is not well-defined without this patch ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
