From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx4: kernel 3.4-rc1 breaks libumad
Date: Mon, 2 Apr 2012 17:51:13 +0300
Message-ID: <4F79BCE1.7010308@mellanox.com>
References: <4F795880.4070306@acm.org> <4F798069.4030305@mellanox.com> <4F798A9B.7060805@acm.org> <4F798B9A.6090309@mellanox.com> <4F799222.3050306@acm.org> <4F79A0C5.2030805@mellanox.com> <4F79A359.2020204@mellanox.com> <4F79A8C4.5000604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F79A8C4.5000604-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/2/2012 4:25 PM, Hal Rosenstock wrote:
>
> I think there are 3 main issues here:
> 1. EINVAL can be returned from rate_show and hence "Invalid argument"
> rate string should be handled in libibumad. I think this was Bart's original point.
> 2. Why is rate_show returning EINVAL ? I think that's what you're trying
> to isolate with the additional printks you sent Bart for sysfs.c.
> 3. link_layer ethernet should also be handled which is the issue you raised.
Just to sync, I just sent kernel patches which should eliminate the case 
when EINVAL is seen by rate_show after calling into the mlx4 driver.  
This addresses point #2, as for #3, I made a check and forced Ethernet 
link layer on IB port, in this case the mlx4 driver issues the ethernet 
port query command and it returns valid value for active_speed (4) so I 
didn't patch that code too. As for libibumad fixes, I'm not dealing with 
that...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
