From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: OpenSM plugin patch request
Date: Mon, 17 Oct 2011 18:28:52 -0400
Message-ID: <4E9CAC24.1010101@dev.mellanox.co.il>
References: <6F2B8AE5-D38D-41B3-A237-CBC26680C4FF@tacc.utexas.edu> <20111012151359.f1876bd3.weiny2@llnl.gov> <18FD0A9E-4227-4CC9-B6EB-D451B80920F1@tacc.utexas.edu> <4E96DE86.109@mellanox.co.il> <60C1A845-5973-45E1-B78C-BE816F86BEEF@tacc.utexas.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <60C1A845-5973-45E1-B78C-BE816F86BEEF-Tmo6s3XX3Xr5xfTjtVVUew@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karl Schulz <karl-Tmo6s3XX3Xr5xfTjtVVUew@public.gmane.org>
Cc: "<kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>" <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Karl,

On 10/17/2011 5:43 PM, Karl Schulz wrote:
> Thanks for explaining the enum convention - quite logical indeed.  Also, thanks for some 
> of the off-list discussion where we tried to see if any of the current event callbacks 
> could be used to achieve the desired support.  As it stands, it still sounds like including 
> light sweep events is the simplest solution and I'm attaching an updated patch for consideration which honors the MAX convention.

A couple of minor comments:

1. Why not move the OSM_EVENT_ID_LIGHT_SWEEP_DONE event to where "LIGHT
SWEEP COMPLETE" is indicated in osm_state_mgr.c ? That's actually more
accurate as all the transactions have completed.

2. The new events should be added to osmeventplugin/src/osmeventplugin.c
example.

Thanks.

-- Hal

> Thanks,
> 
> Karl
> 
> 
> On Oct 13, 2011, at 7:50 AM, Yevgeny Kliteynik wrote:
> 
>> Hi Karl,
>>
>>
>> The idea in that if the received event is >= OSM_EVENT_ID_MAX,
>>
>> then the plug-in knows that something went wrong (wrong version,
>>
>> something changed in API, etc).
>>
>>
>> Also, you might want to know about more stuff if you're pulling
>> topology/routing info from SM, such as when SM became stand-by
>> and when it became master, and when re-route was done.
>>
>> Please see this patch for reference:
>>
>>
>> http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg02206.html
>>
>>
>> It wasn't applied as is back then, but you might want it now.
>>
>>
>> -- YK
>>
>>
>>
>> On 13-Oct-11 4:50 AM, Karl Schulz wrote:
>>
>>> Thanks Ira,
>>>
>>> My apologies for not following the conventional standard.  Should I generate a new patch?
>>>
>>> -k
>>>
>>> On Oct 12, 2011, at 5:13 PM, Ira Weiny wrote:
>>>
>>>> I think this is a reasonable idea.
>>>>
>>>> Comment on the patch.
>>>>
>>>> -   OSM_EVENT_ID_MAX
>>>> +   OSM_EVENT_ID_MAX,
>>>> +   OSM_EVENT_ID_LIGHT_SWEEP_START, 
>>>> +   OSM_EVENT_ID_LIGHT_SWEEP_DONE,  
>>>>
>>>> Traditionally the "MAX" value in the enum is kept at the end.
>>>>
>>>> Ira
>>>>
>>>>
>>>> On Wed, 12 Oct 2011 14:31:07 -0700
>>>> Karl Schulz<karl-Tmo6s3XX3Xr5xfTjtVVUew@public.gmane.org>  wrote:
>>>>
>>>>> Hello,
>>>>>
>>>>> Would it be possible to consider exposing light-sweep events to the current OpenSM plugin interface?  Something along the lines of the attached patch is what we are using locally against opensm-3.3.9.
>>>>>
>>>>> The motivation is to support a plugin module we have written to expose topology information to a query service which can be used by MPI stacks (in user-space) for topology-aware optimization and for topology-aware scheduling via batch systems.
>>>>>
>>>>> Thanks for the consideration,
>>>>>
>>>>> Karl
>>>>>
>>>>
>>>> -- 
>>>> Ira Weiny
>>>> Member of Technical Staff
>>>> Lawrence Livermore National Lab
>>>> 925-423-8008
>>>> weiny2-i2BcT+NCU+M@public.gmane.org
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
