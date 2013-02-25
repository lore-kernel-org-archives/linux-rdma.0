From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/saquery.c: switchinfo support added
Date: Sun, 24 Feb 2013 17:34:47 -0800
Message-ID: <20130224173447.08f0201f24e97ea4c62a5a60@llnl.gov>
References: <WC20130221094946.530170@asaltech.com>
	<20130221100900.87b509d834fc0adc21b6f68b@llnl.gov>
	<20130221103344.57aeda4abc1ac4915a6a0a06@llnl.gov>
	<WC20130224082247.780048@asaltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <WC20130224082247.780048-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Husam Kahalah <HKahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 24 Feb 2013 10:22:47 +0200
"Husam Kahalah" <HKahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org> wrote:

> Thank you for your time, I have the following notes:
> I plan to add support for more records other than switchInfoRecord like 
> smInfo, multipath, nodeInfo

That would be great!

> I plan also to add component filter to those records attributes in the same 
> way that pathInfo and MCR were implemented, this is the reason why I started 
> adding attributes to query_params structure 
> I'am not talking about RID(record identifier) attributes only, but also 
> about other attributes that may differ between records.
> If it is available to add to query_params structure in that way let me know 
> , otherwise I will add just RID attributes in the suggested way.
> 

I am not against adding fields to query_params.  However, we have a standard way to specify the RID components like LID which should be followed.

If you need new components to be specified for new attributes it is fine to add them to query_params.  That said, any components which already have options should be overloaded; for example MultiPathRecord.SL should use the --sl option.

Does this make sense?

Thanks,
Ira

> 
> -----Original Message-----
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Cc: "Husam Kahalah" <HKahalah-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 
> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Date: Thu, 21 Feb 2013 10:33:44 -0800
> Subject: Re: [PATCH] infiniband-diags/saquery.c: switchinfo support added
> 
> On Thu, 21 Feb 2013 10:09:00 -0800
> Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> 
> [snip]
> 
> > > + ib_net16_t swir_lid;
> >
> > We don't need this field or lid option.  Other records simply have an 
> optional parameter to specify the lid.
> >
> > The usage should be:
> >
> > SwitchRecord [lid]
> >
> 
> Sorry I meant "SwitchInfoRecord" or SWIR.
> 
> Ira
> 
> [snip]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
