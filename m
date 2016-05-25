From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V7 for-next 1/4] IB/core: Introduce capabilitymask2 field
 in ClassPortInfo mad
Date: Wed, 25 May 2016 15:25:18 -0400
Message-ID: <414e108a-b0cc-52c7-a5af-3823fcbf7d55@dev.mellanox.co.il>
References: <1464202927-14979-1-git-send-email-erezsh@mellanox.com>
 <1464202927-14979-2-git-send-email-erezsh@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464202927-14979-2-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/25/2016 3:02 PM, Erez Shitrit wrote:
> Change struct ib_class_port_info to conform to IB Spec 1.3
> That in order to get specific capability mask from ClassPortInfo mad.
> 
>>From the IB Spec, ClassPortInfo section:
>         "CapabilityMask2 Bits 0-26: Additional class-specific capabilities...
>          RespTimeValue the rest 5 bits"
> 
> The new struct now has one field for capabilitymask2 (previously was the
> reserved field) and the resp_time field.
> 
> And it fixes up qib and srpt, use of the field repurposed to be used as
> capabilitymask2:
> IB/qib: Change pma_get_classportinfo
> IB/srpt: Adjust the use of ib_class_port_info
> 
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
