From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: update internal PortInfo state for any ports
Date: Thu, 08 Aug 2013 11:03:38 -0400
Message-ID: <5203B34A.8010401@dev.mellanox.co.il>
References: <20130707205219.GA6084@gmail.com> <51E006B5.3060808@dev.mellanox.co.il> <20130722154032.GA23909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130722154032.GA23909-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashakvolt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

On 7/22/2013 11:40 AM, Sasha Khapyorsky wrote:
> Hi Hal,
> 
> On 09:37 Fri 12 Jul     , Hal Rosenstock wrote:
>>
>> What difference does it make ? Does this patch fix some operational
>> issue ? Is there any harm in not keeping the complete PortInfo when port
>> is DOWN ?
> 
> AFAIK it doesn't harm in the current state. However, I'm prepering the
> patches, which will let to OpenSM work on stand alone port. For such
> mode this fix is critical.

Why is it critical for this set of patches ? I'm still missing why
that's required for supporting single port sweep (so loopback
connections still work). What PortInfo fields are really needed ?

-- Hal

> Will recent with other patches shortly.
> 
> Sasha
> .
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
