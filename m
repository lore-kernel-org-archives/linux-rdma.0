From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Wed, 25 Nov 2009 09:30:40 -0500
Message-ID: <7127F20E-2307-492D-B929-A6ACA5A74D14@cisco.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com> <20091125001136.GP6188@obsidianresearch.com> <4B0D3982.2040408@mellanox.co.il>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B0D3982.2040408-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Nov 25, 2009, at 9:04 AM, Tziporet Koren wrote:

> Note that application does not need to query the transport type, but  
> we
> thought it can be good to know also from debug perspective.
> Thus I think sysfs is the best place.
>


In practice, we have seen that applications *do* need to query the  
transport type -- at least (real) IB vs. iWARP.  It is your  
expectation that IB and IBoE will function identically?

Can you discuss the "transport" vs. "transport_type" questions?

Thanks!

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
