From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 01/06] opensm/perfmgr: issue ClassPortInfo as first query
 to each port.
Date: Tue, 26 Feb 2013 17:43:22 -0500
Message-ID: <512D3A8A.9020207@dev.mellanox.co.il>
References: <20130221133331.593f30977427848f4373b57a@llnl.gov> <512CCEC7.70304@dev.mellanox.co.il> <20130226105803.c3bae4bdd1d2af03bce373db@llnl.gov> <512D118A.5010503@dev.mellanox.co.il> <20130226130711.8d96c1834b47c55e2abef24e@llnl.gov> <512D25CC.3010109@dev.mellanox.co.il> <20130226132400.4ec40c660efd0c1eb0b6f69c@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130226132400.4ec40c660efd0c1eb0b6f69c-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/26/2013 4:24 PM, Ira Weiny wrote:
> On Tue, 26 Feb 2013 16:14:52 -0500
> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
>> On 2/26/2013 4:07 PM, Ira Weiny wrote:
>>> Right, BSP0 doesn't have PM counters.  So why did you ask if I had tried this with base SP0?
>>
>> I thought I answered that in the previous response:
>> "The reason I asked here is that the ClassPortInfo is being requested on
>> port 1 not 0 for BSP0."
> 
> But that is the correct thing to do, right?

I think that's legal per:

C13-29: The ClassPortInfo attribute shall be implemented for every GS
class agent supported by a node; it shall be implemented on every port
through which the GS class agent may be accessed.

-- Hal

> 
> Ira
> 
>>
>> -- Hal
>>
>>> To be clear I have tried this with both Enhanced SP0 and Base SP0 and it seems to work correctly.
>>>
>>> Ira
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
