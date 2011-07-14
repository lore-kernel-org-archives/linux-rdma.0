From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] libibmad: Support for Mellanox vendor specific ExtendedPortInfo
 SM class MAD
Date: Thu, 14 Jul 2011 14:48:58 -0400
Message-ID: <4E1F3A1A.2020103@dev.mellanox.co.il>
References: <4E1F3419.3010508@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237302E197@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237302E197-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/14/2011 2:34 PM, Hefty, Sean wrote:
>> -	IB_ATTR_LAST
>> +	IB_ATTR_LAST,
>> +
>> +	IB_ATTR_MLNX_EXT_PORT_INFO = 0xff90,
>>  };
> 
> Seems kind of odd to have something come after 'last'..

I'm not sure why IB_ATTR_LAST is even there (similarly for
IB_SA_ATTR_LAST); maybe a historical vestige at this point but due to
backward compatibility (who knows if it's used) should remain.

It's a poor name given vendor SM attribute IDs.

I didn't think it was safe to have IB_ATTR_LAST increase from 0x21 to
0xff91 because of this so I thought it best to add it as I did and treat
this new attribute ID as an exception if needed which it isn't currently.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
