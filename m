From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: RDMAoE verbs questions
Date: Tue, 24 Nov 2009 18:23:15 -0500
Message-ID: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I was reviewing Mellanox's Open MPI patches for RDMAoE support this  
afternoon and came up with the following general questions:

1. It looks like there is a new field on the ibv_port_attr struct:  
transport.  Is it expected that all device drivers will start filling  
in this value, or is it done in the OF core code somewhere?   
Regardless of where this value is supposed to be filled in, does the  
Mellanox patch to community OFED ensure that this value is properly  
initialized regardless of what device is used?  (this issue came up in  
the OMPI review: whether we could *always* rely on this value being  
accurate, or whether it was only accurate when Mellanox devices are  
used -- and it should be considered uninitialized when other devices  
are used)

2. I am somewhat confused by the overloading of the term "transport".   
It appears that a device will have  
ibv_device.transport_type==IBV_TRANSPORT_IB for both IB and RDMAOE  
devices.  The only way to tell the difference is to examine the new  
ibv_port_attr.transport field to see if it is RDMA_TRANSPORT_IB or  
RDMA_TRANSPORT_RDMAOE.

This disparity seems a little odd to me.  They're both called  
"transport" -- so why are they split across two fields?  Is there a  
reason for not simply creating a new ibv_transport_type enum value  
named IBV_TRANSPORT_RDMAOE and assigning that to the  
ibv_device.transport_type field?

I'm *guessing* that Mellanox wants legacy code checking for the  
ibv_device.transport_type value IBV_TRANSPORT_IB to work for RDMAOE  
devices as well...?  If that's correct:

2a. That assumption seems risky -- the Open MPI RDMAOE patch implies  
that host loopback is not supported in RDMAOE mode (but it is in IB  
mode).  To be clear, the OMPI code had to do something different for  
real IB vs. RDMAOE in at least 1 or 2 places.

2b. Can we come up with a different/better name for the  
ibv_port_attr.transport field name and enum values?  Overloading the  
term "transport" across two fields is quite confusing IMHO.  Example:  
ignoring the code, how do Mellanox engineers refer to these two  
different characteristics?  I ask because this might help come up with  
better struct names.  The existing verbs code base has a long- 
established "transport_type" field on the ibv_device struct which,  
obviously, should not be changed.  If you now distinguish  
"IBV_TRANSPORT_IB" devices as either real IB and IBoE, how do you  
refer to this 2nd characteristic in spoken/written text?

Thanks!

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
