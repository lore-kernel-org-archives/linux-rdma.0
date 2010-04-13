From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 0/2] Add support for enhanced atomic operations
Date: Tue, 13 Apr 2010 10:43:09 -0700
Message-ID: <adatyrfmeoi.fsf@roland-alpha.cisco.com>
References: <20100310155749.GA25964@vlad-laptop>
	<A27E2E88-63A0-45EE-9A70-F95B2A0C25AD@Sun.com>
	<adaaaueelby.fsf@roland-alpha.cisco.com>
	<BA082DF0-B3C6-4405-B480-F69B0193BF17@Sun.COM>
	<adavdd1a64g.fsf@roland-alpha.cisco.com>
	<adaeijj96a6.fsf@roland-alpha.cisco.com>
	<4BA0F623.1050606@dev.mellanox.co.il>
	<4BC2EB7F.20804@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BC2EB7F.20804-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> (Vladimir Sokolovsky's
	message of "Mon, 12 Apr 2010 12:44:31 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: =?utf-8?Q?H=C3=A5kon?= Bugge <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Do you propose to use IB_ATOMIC_GLOB instead of IB_ATOMIC_HCA while setting
> atomic capability in the code below?
>
>         props->atomic_cap          = dev->dev->caps.flags &
> MLX4_DEV_CAP_FLAG_ATOMIC ?
>                 IB_ATOMIC_HCA : IB_ATOMIC_NONE;
>
> Or add IB_MASKED_ATOMIC to ib_atomic_cap enum and use this one
> instead of IB_ATOMIC_HCA?
>
> All this, of course, comes to replace setting
> IB_DEVICE_MASKED_ATOMIC for device capability.

Sorry, missed this reply first time around I guess.

Anyway, no I don't think we should use ATOMIC_GLOB unless an HCA truly
provides global atomic ops; not possible without PCIe 3.0 atomic support
I think.  But as I said, I think the original suggestion:

 > > Hence, I think it would be cleaner if a new capability,
 > > masked_atomic_cap, were introduced, using the original definitions
 > > (NONE, HCA, GLOB).

makes sense, ie create a new props->masked_atomic_cap and set it to
NONE, HCA or GLOB as appropriate (ie NONE for everyone except mlx4, and
HCA for mlx4).
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
