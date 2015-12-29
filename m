From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: sysfs.c: Fix PerfMgt ClassPortInfo handling
Date: Tue, 29 Dec 2015 14:21:11 +0200
Message-ID: <56827AB7.50508@mellanox.com>
References: <568263DF.6020505@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568263DF.6020505-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/29/2015 12:43 PM, Hal Rosenstock wrote:
> Port number is not part of ClassPortInfo attribute but is
> still needed as a parameter when invoking process_mad.

Please remove the blank line above your 1st sentence.

>
> To properly handle this attribute, port_num is added as a
> parameter to get_counter_table and get_perf_mad was changed
> not to store port_num in the attribute itself when it's
> querying the ClassPortInfo attribute.
>
> This handles issue pointed out by Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>
> Fixes: 145d9c541032 ('IB/core: Display extended counter set if available')
>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
again, remove the blank line after the fixes tag.

Also,  I am not that the way Doug is setting the branch for pull would 
preserve commit IDs when
the offending patch landed in Linus tree. If this is the case, we should 
put your patch in 2nd pull
request and have the right commit ID there. Please check with Doug.
> Acked-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Acked-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> Change from v1:
> Added fixes line to description

So this patch makes mlx4 IB driver on Eth ports workable with the 
4.5-rc1 proposed bits?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
