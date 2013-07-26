From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Failover support in IB?
Date: Fri, 26 Jul 2013 13:41:41 -0400
Message-ID: <51F2B4D5.2090607@dev.mellanox.co.il>
References: <B78BFEBC60BCD84AABFE4C6AE4239F303639A7B2@BY2PRD0412MB622.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B78BFEBC60BCD84AABFE4C6AE4239F303639A7B2-PabevnM9DETuy2SDsQ9Xi/nBZW37Ciw+nBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liu Ginhann <Ginhann.Liu-Omk3PdybHIaN9aS15agKxg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/26/2013 12:58 PM, Liu Ginhann wrote:
> Does anyone know if IB support failover? For example, OpenSM can automatically reroute when a fault is detected in the 
> "active" path. 

Yes.

> If it does, is this support apply to multicast too?  

Yes both unicast and multicast is rerouted.

-- Hal

> 
> 
> Hank Liu
> 503 526-8144
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
