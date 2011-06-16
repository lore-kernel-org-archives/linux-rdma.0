From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 7/9] ib/pma: add include file for IBA performance counters
 definitions
Date: Thu, 16 Jun 2011 11:01:59 +0300
Message-ID: <4DF9B877.8080808@mellanox.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com> <alpine.LRH.2.00.1106151747390.15844@ogerlitz.voltaire.com> <4DF8D90A.1000208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DF8D90A.1000208-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hal Rosenstock wrote:
>> Index: b/drivers/infiniband/hw/qib/qib_mad.h

>> -#define IB_PMA_PORT_COUNTERS_CONG       cpu_to_be16(0xFF00)
> This looks like a proprietary counter to me and if so should be left here.

okay, will get it back there

>> -struct ib_pma_portcounters_cong {
> Same as above.

sure, done

>> -#define IB_PMA_SEL_CONG_ALL                     0x01
>> -#define IB_PMA_SEL_CONG_PORT_DATA               0x02
>> -#define IB_PMA_SEL_CONG_XMIT                    0x04
>> -#define IB_PMA_SEL_CONG_ROUTING                 0x08

> Are these related to the proprietary counter above ?
yes, and as such, will leave them here

>> +#define IB_PMA_CONG_HW_CONTROL_TIMER            0x00
>> +#define IB_PMA_CONG_HW_CONTROL_SAMPLE           0x01

> Same as comment above.

removed from here, back home to qib code
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
