From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Wed, 25 Nov 2009 09:25:32 +0200
Message-ID: <4B0CDBEC.1030203@voltaire.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <209ECE49-3AB9-4E62-B825-54E474321FA6-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Jeff Squyres wrote:
> I was reviewing Mellanox's Open MPI patches for RDMAoE support
Hi Jeff,

Can you send us point to the patch series (mail thread or some 
repository where they sit)?

> 1. It looks like there is a new field on the ibv_port_attr struct: 
> transport. Is it expected that all device drivers will start filling 
> in this value, or is it done in the OF core code somewhere?
Please note that this field isn't present in the distro provided IB 
stack and hence it is highly recommended to avoid referring it in your 
code, as least some of us (...) are for decoupling ompi from ofed, so 
lets not put sticks in the wheels of that process.

> the Open MPI RDMAOE patch implies that host loopback is not supported 
> in RDMAOE mode (but it is in IB mode).  To be clear, the OMPI code had 
> to do something different for real IB vs. RDMAOE in at least 1 or 2 places
Liran, where this limitation comes from? isn't the HCA supporting 
bridging (loopback connections) for RDMAoE? if this is the case maybe 
you should add a device capability to mark that.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
