From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 16/20] IB/hfi1: Add receive fault injection feature
Date: Fri, 3 Mar 2017 12:02:39 -0500
Message-ID: <2ded92a7-27e3-f472-46f8-f0921d122f15@intel.com>
References: <20170301181719.29989.31238.stgit@scvm10.sc.intel.com>
 <20170302182610.28851.42687.stgit@scvm10.sc.intel.com>
 <20170303161508.GF14379@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170303161508.GF14379-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/03/2017 11:15 AM, Leon Romanovsky wrote:
> On Thu, Mar 02, 2017 at 10:26:17AM -0800, Dennis Dalessandro wrote:
>> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> Add fault injection capability:
>>   - Drop packets unconditionally (fault_by_packet)
>>   - Drop packets based on opcode (fault_by_opcode)
>>
>> This feature reacts to the global FAULT_INJECTION
>> config flag.
>>
>> The faulting traces have been added:
>>   - misc/fault_opcode
>>   - misc/fault_packet
>>
>> See 'Documentation/fault-injection/fault-injection.txt'
>> for details.
>>
>> Examples:
>>   - Dropping packets by opcode:
>>     /sys/kernel/debug/hfi1/hfi1_X/fault_opcode
>> 	# Enable fault
>> 	echo Y > fault_by_opcode
>> 	# Setprobability of dropping (0-100%)
>> 	# echo 25 > probability
>> 	# Set opcode
>> 	echo 0x64 > opcode
>> 	# Number of times to fault
>> 	echo 3 > times
>> 	# An optional mask allows you to fault
>> 	# a range of opcodes
>> 	echo 0xf0 > mask
>>     /sys/kernel/debug/hfi1/hfi1_X/fault_stats
>>     contains a value in parentheses to indicate
>>     number of each opcode dropped.
>>
>>   - Dropping packets unconditionally
>>     /sys/kernel/debug/hfi1/hfi1_X/fault_packet
>> 	# Enable fault
>> 	echo Y > fault_by_packet
>>     /sys/kernel/debug/hfi1/hfi1_X/fault_packet/fault_stats
>>     contains the number of packets dropped.
>
> It will be so nice to have this functionality extended to objects and
> placed in IB/core. For example, VNIC and IPoIB will be able to use
> faults by packet, while all other drivers and ULPs will use faults by
> objects.
>
> Does it make sense?

I agree. We also should think about a subsystem wide approach for things 
like this, and other forms of debugging.

-Denny


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
