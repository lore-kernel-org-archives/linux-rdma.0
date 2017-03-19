From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v1 for verbs counters]
Date: Sun, 19 Mar 2017 10:23:57 -0400
Message-ID: <199fa61a-4197-5a48-a827-95a8c3b89cd8@intel.com>
References: <AM5PR0502MB30578E5BC54125D013D416DCBD250@AM5PR0502MB3057.eurprd05.prod.outlook.com>
 <a2fb88b0-7538-dcbe-7c9c-35a2566818c7@intel.com>
 <HE1PR0502MB30667CF2D73927A036EE4010BD3B0@HE1PR0502MB3066.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR0502MB30667CF2D73927A036EE4010BD3B0-692Kmc8YnlInzEhYgqUDPcDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/19/2017 06:07 AM, Guy Shattah wrote:
>> On 03/13/2017 04:36 PM, Guy Shattah wrote:
>>>
>>> RFC: Verbs Counters
>>>
>>>
>>> There is a constant demand to know about connections used in verbs (and and other aspects).
>>> Some vendors have been offering hardware counters for a long time by using sysfs.
>>> Those counters, however - are not available per connection but for the whole system.
>>
>> Are you proposing to remove the system wide counters from sysfs?
>>
>>> ibv_counter_set_description is a struct to describe other structs.
>>>                 for example, we have the following struct:
>>>
>>>
>>>                 private struct guy_counter {
>>>                                 uint64_t apples_kg;
>>>                                 uint64_t apples_count;
>>>                 }
>>>
>>>
>>>
>>>                 - note that all counters are 64bit entries
>>
>> Might be a bit wasteful for some things. Could you not have an attribute which says if its 64bit or not?
>>
>> -Denny
>
> HI,
> I'm not offering to remove the system-wide counters. I'm offering another way to view counters
> in the system. My suggestion is aimed for the developer looking to know more about
> Their connections, flows or other aspects which are not system-wide statistics.
> such counters have not been exposed so far.
>
>
> Regarding counters width  - After giving it a lot of thought. I believe that 64bit counters are the best
> decision.
> a) Allowing more than one size of counters will make the memory allocation and data parsing harder.

I would agree, but I'm not sure it's that hard.

> b) 64bit is exactly the right size. It is not too small for the terabytes of data passing in the system
>       and it is not bit enough (like 128bit) so vendor may still choose to implement 128bit width
>       counters as a pair of 64bit (high + low)
>
> Guy

What about something that counts errors? I would hope 64bits isn't 
needed for that. It all depends on what you are counting really. If this 
is meant to be a generic interface I would think it should be as 
flexible as possible. However maybe the small counters are rare and it's 
just not worth the extra implementation complexity. I'm on the fence 
here and won't argue too hard one way or the other.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
