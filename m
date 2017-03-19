From: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC v1 for verbs counters]
Date: Sun, 19 Mar 2017 10:07:10 +0000
Message-ID: <HE1PR0502MB30667CF2D73927A036EE4010BD3B0@HE1PR0502MB3066.eurprd05.prod.outlook.com>
References: <AM5PR0502MB30578E5BC54125D013D416DCBD250@AM5PR0502MB3057.eurprd05.prod.outlook.com>
 <a2fb88b0-7538-dcbe-7c9c-35a2566818c7@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a2fb88b0-7538-dcbe-7c9c-35a2566818c7-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>On 03/13/2017 04:36 PM, Guy Shattah wrote:
>>
>> RFC: Verbs Counters
>>
>>
>> There is a constant demand to know about connections used in verbs (and =
and other aspects).
>> Some vendors have been offering hardware counters for a long time by usi=
ng sysfs.
>> Those counters, however - are not available per connection but for the w=
hole system.
>
>Are you proposing to remove the system wide counters from sysfs?
>
>> ibv_counter_set_description is a struct to describe other structs.
>>                 for example, we have the following struct:
>>
>>
>>                 private struct guy_counter {
>>                                 uint64_t apples_kg;
>>                                 uint64_t apples_count;
>>                 }
>>
>>
>>
>>                 - note that all counters are 64bit entries
>
>Might be a bit wasteful for some things. Could you not have an attribute w=
hich says if its 64bit or not?
>
>-Denny

HI,
I'm not offering to remove the system-wide counters. I'm offering another w=
ay to view counters=20
in the system. My suggestion is aimed for the developer looking to know mor=
e about
Their connections, flows or other aspects which are not system-wide statist=
ics.
such counters have not been exposed so far.


Regarding counters width  - After giving it a lot of thought. I believe tha=
t 64bit counters are the best
decision.
a) Allowing more than one size of counters will make the memory allocation =
and data parsing harder.

b) 64bit is exactly the right size. It is not too small for the terabytes o=
f data passing in the system
      and it is not bit enough (like 128bit) so vendor may still choose to =
implement 128bit width
      counters as a pair of 64bit (high + low)

Guy

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
