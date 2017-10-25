From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Wed, 25 Oct 2017 17:58:15 +0300
Message-ID: <b003f6e5-d7ce-3775-a1dc-0fd0f507a515@dev.mellanox.co.il>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
 <20171023165118.GA18097@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023165118.GA18097-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/23/2017 7:51 PM, Jason Gunthorpe wrote:
> On Thu, Oct 19, 2017 at 05:41:42PM +0300, Yishai Hadas wrote:
> 
>> More specifically,
>> A generic interface with the following functionality is presented:
>> - An option to know per device how many counter sets it exposes by using some
>>    extension of the ib_query_device_ex() verb. (i.e. max_counter_sets).
>> - Per counter set there is an API to get its metadata by using a new verb named
>>     ib_describe_counter_set(), it gets a counter set id in range of
>>     [0,max_counter_sets - 1] and return the counter set information.
>>     Some of the metadata is IB generic (e.g. counter set type, num counters in the set, etc.)
>>     while other is some specific driver information (e.g. counters names).
>> - Introduce counter set object named 'ib_counter_set' and its create/destroy
>>    verbs. Post a successful creation the counter_set object can  be attached to
>>    an IB object based on its type. (e.g. Flow, QP, etc.)
>> - Introduce the ib_query_counter_set() verb, it enables the user to read the
>>    hardware counters which are associated with the counter set.
>> - Introduce a new steering specification from type count
>>    (i.e. ib_flow_spec_action_count) which gets a previously created counter_id.
>>    By creating a flow steering object with a counter, its counters can be read
>>    by the ib_query_counter_set() verb.
> 
> I haven't seen the uapi yet, but I don't like the direction this is
> going, this looks much too hard for applications to acutally use.
> 

Hi Jason, please go over the patches/uapi, we believe that you'll find 
it quite easy to be used by an application, however we plan to improve 
as of below.

> My suggestion for the verbs interface is:
> 

We sent an RFC few months ago, if we got your feedback by that time we 
could involve it as part of V0. However, we found few of your notes that 
can be applicable even for this kernel cycle and we plan to involve them 
as part of V1, details below.

Expected changes from V0:
-------------------------------
#Capabilities:
The first patch introduced the notion of "max_counter_sets" capability, 
basically we thought to enable few subsets of same counted type (e.g. 
Flow/QP) which will be built by the driver.

To enable your approach to let user controlling its required counters 
per IB counter object we will move to report supported_counted_types 
which will be some enum/flag per counter type. (E.g. Flow, QP, Port, 
etc.) and drop the option to have few counter sets per type that are 
built by the driver.

#The describe API:
1) We'll change the API to get the counted type as an input instead of 
returning it as an output.
2) We'll drop the num_of_cs (number of counter sets) and counted type 
from its output.

#The create API:
We found it better to stay with our suggested API with few changes, 
below notes were considered.

1) There might be a hardware that doesn't support attaching a counter 
object to an existing object, your suggested API to set sampling points 
relay on that ability.

Specifically talking, mlx5 doesn't support attaching a counter object to 
Flow post its creation, that's why we introduced a new counter_spec type 
that introduced an already created IB counter.

2) We prefer using one single system call to create the ib_counter 
object with its required counters instead of creating it with sampling 
points which might involve many system calls.

3) We don't have at the moment a customer use case to remove a sampling 
point, we expect an application to create an IB counter with its 
relevant counters and use it. This ability can be added in the future 
upon demand, on objects that support that by some modify API.

4) Currently the API introduces vendor ordering based on the describe 
output and exposes only the option to read all counters from the given 
counter type. For day one we find it enough as for now there is only one 
counted type that is supported (i.e. Flow) by mlx5 driver and it exposes
only 2 counters. However, as the API is extensible we can extend it with 
comp_mask to get some other input which may control the ordering/partial 
counters/compound objects in the future based on demand.

5) The expected change in V1 for the create API is to get counted type 
as input instead of counter set index, this can be overwritten as 
pointed by the comp_mask flag to be more complex/informative meta data 
in later stages.

#Flow spec API to enable counting:
No change is expected, motivation was mentioned above.

#Query API:
For now no change is expected, it matches also to your approach as it 
just gets an IB counter and a buffer to collect the data.

Let's please get your feedback on above so that we can be ready with V1 
soon.

Thanks,
Yishai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
