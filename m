From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: sysfs.c: Fix PerfMgt ClassPortInfo handling
Date: Tue, 29 Dec 2015 07:46:54 -0500
Message-ID: <568280BE.8030005@dev.mellanox.co.il>
References: <568263DF.6020505@dev.mellanox.co.il>
 <56827AB7.50508@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56827AB7.50508-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/29/2015 7:21 AM, Or Gerlitz wrote:
> On 12/29/2015 12:43 PM, Hal Rosenstock wrote:
>> This handles issue pointed out by Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>
>> Fixes: 145d9c541032 ('IB/core: Display extended counter set if
>> available')
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> again, remove the blank line after the fixes tag.
> 
> Also,  I am not that the way Doug is setting the branch for pull would
> preserve commit IDs when
> the offending patch landed in Linus tree. If this is the case, we should
> put your patch in 2nd pull
> request and have the right commit ID there. Please check with Doug.

Doug ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
