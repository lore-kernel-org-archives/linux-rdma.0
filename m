From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH for-next V1 03/11] IB/core: Add CQ creation time-stamping
 flag
Date: Fri, 29 May 2015 14:16:03 -0500
Message-ID: <5568BAF3.7030703@opengridcomputing.com>
References: <1432220202-9834-1-git-send-email-ogerlitz@mellanox.com>	 <1432220202-9834-4-git-send-email-ogerlitz@mellanox.com> <1432918022.114391.102.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432918022.114391.102.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/29/2015 11:47 AM, Doug Ledford wrote:
> On Thu, 2015-05-21 at 17:56 +0300, Or Gerlitz wrote:
>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Add CQ creation flag which dictates that the created CQ will report
>> completion time-stamp value in the WC.
>>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>   include/rdma/ib_verbs.h |    4 ++++
>>   1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 4f6b397..28ec073 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -166,6 +166,10 @@ struct ib_odp_caps {
>>   	} per_transport_caps;
>>   };
>
> This needs documentation, and quite possibly a different flag name.  In
> this case, you are timestamping the completion events.  That's fine, but
> that's not the only thing that would be a reasonable timestamp event in
> a complete API.  Maybe someone wants to timestamp the start of the
> transfer instead, so they can order packets not on who finished first,
> but who had their first byte arrive first.  A note detailing this
> possibility, and then stating that this particular option is for
> completion timestamping, and maybe change the name to
> TIMESTAMP_COMPLETION.

As an example of your point, iw_cxgb4 uses similar HW timestamps to 
track work request submission and completion.   Only for debug of kernel 
mode rdma users at this point.  Extending this all into user space would 
allow tracking these timings from user applications.

See:

commit 7730b4c7e32c0ab4d7db746a9c3a84cf715161fa
Author: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Date:   Mon Jul 14 21:34:54 2014 +0530

     cxgb4/iw_cxgb4: work request logging feature


>   
>> +enum ib_cq_creation_flags {
>> +	IB_CQ_FLAGS_TIMESTAMP   = 1 << 0,
>> +};
>> +
>>   struct ib_cq_init_attr {
>>   	unsigned int	cqe;
>>   	int		comp_vector;
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
