From: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Enable pkey and device name decoupling
Date: Wed, 27 Sep 2017 12:03:40 -0700
Message-ID: <c98fc5c0-cb34-c960-4bbf-34422bbacd0e@oracle.com>
References: <20170927093248.3819-1-yuval.shaia@oracle.com>
 <20170927150140.GF2297@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170927150140.GF2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernel-6AxghH7DbtA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/27/2017 08:01 AM, Leon Romanovsky wrote:
> On Wed, Sep 27, 2017 at 12:32:48PM +0300, Yuval Shaia wrote:
>> The sysfs "create_child" interface creates pkey based child interface but
>> derives the name from parent device name and pkey value.
>> This makes administration difficult where pkey values can change but
>> policies encoded with device names do not.
>>
>> We add ability to create a child interface with a user specified name and a
>> specified pkey with a new sysfs "create_named_child" interface (and also
>> add a corresponding "delete_named_child" interface).
>>
>> We also add a new module api interface to query pkey from a netdevice so
>> any kernel users of pkey based child interfaces can query it - since with
>> device name decoupled from pkey, it can no longer be deduced from parsing
>> the device name by other kernel users.
>>
>> Signed-off-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Reviewed-by: Chien-Hua Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>   Documentation/infiniband/ipoib.txt        |  12 ++
>>   drivers/infiniband/ulp/ipoib/ipoib.h      |   3 +
>>   drivers/infiniband/ulp/ipoib/ipoib_main.c | 187 ++++++++++++++++++++++++++++++
>>   drivers/infiniband/ulp/ipoib/ipoib_vlan.c |  76 +++++++++++-
>>   4 files changed, 272 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/infiniband/ipoib.txt b/Documentation/infiniband/ipoib.txt
>> index 47c1dd9818f2..1db53c9b2906 100644
>> --- a/Documentation/infiniband/ipoib.txt
>> +++ b/Documentation/infiniband/ipoib.txt
>> @@ -21,6 +21,18 @@ Partitions and P_Keys
>>
>>       echo 0x8001 > /sys/class/net/ib0/delete_child
>>
>> +  Interfaces with a user chosen name can be created in a similar
>> +  manner with a different name and P_Key, by writing them into the
>> +  main interface's /sys/class/net/<intf name>/create_named_child
>> +  For example:
>> +     echo "epart2 0x8002" > /sys/class/net/ib1/create_named_child
>> +
>> +   This will create an interfaces named epart2 with P_Key 0x8002 and
>> +   parent ib1. To remove a named subinterface, use the
>> +   "delete_named_child" file:
>> +
>> +     echo epart2 > /sys/class/net/ib1/delete_named_child
> 
> I doubt that delete_named_child is actually needed. You can use delete_child
> on the pkey, which you used to create named child.
> 
> Maybe better to add support to rename child instead of introducing named
> child concept?
> 
> Thanks
> 


I can offer a slightly indirect answer to justify the current interface 
by providing the background behind the requirements for this change.

The requirement for this change had come from the desire for ease of 
writing management tools and facilitate "renumbering" of pkeys as IB 
network clouds are reconfigured.

The renumbering still requires the name-value pair (e.g. PKEY_ID=<n>) to 
be propagated to hosts configurations, but having the pkey embeded in 
device name was introducing complexity as various sysadmin scripts and 
other things need to pick it up.

Having devices with names like ib0.datanet, ib1.cellnet or any other 
ib<N>.<string> simplifies that life of people designing the management 
tools for networks and integrating them for the use case of renumbering 
of pkeys.

Probably many future redesigns are possible, but for this tweak of the 
existing sysfs "create_child" interface, a rename child may not be the 
best variant if it requires using device name with pkey values at any 
stage in the use case. Same for delete_named_child.

Also, some related trivia - which I would not use to justify this design 
but can explain why certain things were done.

In ancient kernels like 2.6.39 (still widely used by our customers :-) ) 
where this was implemented first, it was possible to create multiple 
child interfaces with same pkey value through variants, so a delete 
interface just using pkey would have been ambiguous (probably not true 
in current kernels!).

Another trivia: We also have an accompanying change diffs to the script 
usually installed as /etc/sysconfig/network-scripts/ifup-ib and part of 
startup scripts (usually in RHEL and related distributions) which uses 
"create_child" and was enhanced to allow both "create_child" and 
"create_named_child" - if these changes are accepted, those changes 
should also be presented to the appropriate upstream for those scripts.

-Mukesh Kacker
mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
