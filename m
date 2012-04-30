From: <Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: fmr pool and remap doubt
Date: Mon, 30 Apr 2012 08:56:33 -0700
Message-ID: <c4b18172-e422-4b29-a733-4b701f8def5d@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I am trying to understand remapping functionality and fmr_pool.c.
Looking back at old thread: http://lists.openfabrics.org/pipermail/general/2006-February/017198.html

Can you please confirm whether my understanding is correct or not.
1. max_map_per_fmr  indicates that - different memory pages can be remapped (again) without invoking unmap_fmr().
Basically previous mapping is over-written on every map_phys_fmr() call with new mapping without doing unmapping.

2. adapter indicates above limit - how many times old mapping can be overwritten (remapped) before invoking unmap_fmr().

3. Remapping allows faster operation compare to map(), unmap() sequence, due to which unmap_fmr() is mostly done in worker threads in SDP, RDS etc consumers.

Is above understanding correct?

Regards,
Parav Pandit

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
