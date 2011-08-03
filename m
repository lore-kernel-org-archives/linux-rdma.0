From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [libibmad] field name cleanup
Date: Wed, 03 Aug 2011 11:44:22 -0400
Message-ID: <4E396CD6.80904@dev.mellanox.co.il>
References: <1312330213.5759.82.camel@auk59.llnl.gov>	<4E38F9A8.6060200@dev.mellanox.co.il> <20110803083937.533c5227.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110803083937.533c5227.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/3/2011 11:39 AM, Ira Weiny wrote:
> On Wed, 3 Aug 2011 00:32:56 -0700
> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
>> Hi Al,
>>
>> On 8/2/2011 8:10 PM, Albert Chu wrote:
>>> I noticed that a number of field names did not have the "_F" suffix on
>>> them. The patch below cleans this up and makes things consistent.
>>
>> I think the ship has sailed on this due to backward compatibility. IMO
>> the best that could be done now is to add the _F suffixes to be the same
>> as the ones without them.
>>
>> For example,
>> ...
>> 	IB_PC_PORT_VL_OP_PACKETS1,
>> 	IB_PC_PORT_VL_OP_PACKETS1_F = IB_PC_PORT_VL_OP_PACKETS1,
>> 	IB_PC_PORT_VL_OP_PACKETS2,
>> 	IB_PC_PORT_VL_OP_PACKETS2_F = IB_PC_PORT_VL_OP_PACKETS2,
>> ...
> 
> 
> I don't think so.  The last version (tag 1.3.7, released 2/14/2011) does not include IB_PC_PORT_VL_OP_PACKETS1.  So I think we can still change them before the release.
> 
> I think that is true of all the fields in the patch but I will check again.

Sure, if they're all "new" enums then it's OK to fix those. I thought
there were some older ones in that list but maybe I'm wrong...

-- Hal

> Ira
> 
>>
>> -- Hal
>>
>>> Al
>>>
>>
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
