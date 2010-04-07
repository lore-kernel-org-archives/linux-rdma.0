From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 02/10] iw_cxgb4: Add driver, fw, and hw headers.
Date: Wed, 07 Apr 2010 17:32:39 -0500
Message-ID: <4BBD0807.10001@opengridcomputing.com>
References: <20100402192346.14117.92767.stgit@build.ogc.int>	<20100402192357.14117.39150.stgit@build.ogc.int> <adahbnn0wxl.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adahbnn0wxl.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> The intention is that the device just treats wrid as opaque I assume so
> I think the correct fix is to go from __be16 to u16 in the structure
> declarations.
>
>   

Shouldn't it be __u16?  These structs are part of the firmware to host 
driver/lib API. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
