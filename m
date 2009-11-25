From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Wed, 25 Nov 2009 16:04:50 +0200
Message-ID: <4B0D3982.2040408@mellanox.co.il>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com> <20091125001136.GP6188@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091125001136.GP6188-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> On Tue, Nov 24, 2009 at 06:23:15PM -0500, Jeff Squyres wrote:
>
>   
>> 2. I am somewhat confused by the overloading of the term "transport".   
>> It appears that a device will have  
>> ibv_device.transport_type==IBV_TRANSPORT_IB for both IB and RDMAOE  
>> devices.  The only way to tell the difference is to examine the new  
>> ibv_port_attr.transport field to see if it is RDMA_TRANSPORT_IB or  
>> RDMA_TRANSPORT_RDMAOE.
>>     
>
> I haven't seen these patches but this seems poor to me. I think any
> app that isn't using rdmacm will need patching and support for RDMAOE
> (certainly all mine will). libibverbs shouldn't overload the existing
> transport_type checks for something that is not 100% compatible with
> IB.
>
>   
Good catch - I agree that the ABI should be 100% backward compatible, 
and we will fix this.
We can add a sysfs option to query the transport type, or add another verb

Note that application does not need to query the transport type, but we 
thought it can be good to know also from debug perspective.
Thus I think sysfs is the best place.

Opinions?

Tziporet

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
