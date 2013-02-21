From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/saquery.c: switchinfo support added
Date: Thu, 21 Feb 2013 10:33:44 -0800
Message-ID: <20130221103344.57aeda4abc1ac4915a6a0a06@llnl.gov>
References: <WC20130221094946.530170@asaltech.com>
	<20130221100900.87b509d834fc0adc21b6f68b@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130221100900.87b509d834fc0adc21b6f68b-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Husam Kahalah <HKahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 21 Feb 2013 10:09:00 -0800
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:

[snip]

> > + ib_net16_t swir_lid;
> 
> We don't need this field or lid option.  Other records simply have an optional parameter to specify the lid.
> 
> The usage should be:
> 
> SwitchRecord [lid]
> 

Sorry I meant "SwitchInfoRecord" or SWIR.

Ira

[snip]
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
