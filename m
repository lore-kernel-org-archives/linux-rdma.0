From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V3 0/2] Add support for enhanced atomic operations
Date: Wed, 17 Mar 2010 17:32:51 +0200
Message-ID: <4BA0F623.1050606@dev.mellanox.co.il>
References: <20100310155749.GA25964@vlad-laptop>	<A27E2E88-63A0-45EE-9A70-F95B2A0C25AD@Sun.com>	<adaaaueelby.fsf@roland-alpha.cisco.com>	<BA082DF0-B3C6-4405-B480-F69B0193BF17@Sun.COM>	<adavdd1a64g.fsf@roland-alpha.cisco.com> <adaeijj96a6.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaeijj96a6.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: =?ISO-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > Hence, I think it would be cleaner if a new capability,
>  > masked_atomic_cap, were introduced, using the original definitions
>  > (NONE, HCA, GLOB).
> 
> Vlad, what do you think about that?  The more I think about it, the
> cleaner this seems to me.  And it doesn't even consume a device
> capability flag bit, which is a nice bonus.

Hi Roland,
Do you propose to use IB_ATOMIC_GLOB instead of IB_ATOMIC_HCA while setting
atomic capability in the code below?

         props->atomic_cap          = dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_ATOMIC ?
                 IB_ATOMIC_HCA : IB_ATOMIC_NONE;

Or add IB_MASKED_ATOMIC to ib_atomic_cap enum and use this one instead of IB_ATOMIC_HCA?

All this, of course, comes to replace setting IB_DEVICE_MASKED_ATOMIC for device capability.

Thanks,
Vladimir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
