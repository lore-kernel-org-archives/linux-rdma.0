From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: [PATCH V2 2/2] mlx4/IB: Add support for enhanced atomic operations
Date: Sun, 28 Feb 2010 11:55:02 +0200
Message-ID: <4B8A3D76.4040701@mellanox.co.il>
References: <20100214135426.GA7666@vlad-laptop> <adahbp4x4me.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adahbp4x4me.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/26/2010 1:44 AM, Roland Dreier wrote:
> Is there no firmware dependency here?  If this really should be set
> unconditionally, then please just roll it into the other flags that get
> set for all devices.
>    
There is no FW dependency here and it's working from first FW release of 
ConnectX.
We have added it to the driver just now since there was no request 
before and now RDS wish to use it.

Tziporet
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
