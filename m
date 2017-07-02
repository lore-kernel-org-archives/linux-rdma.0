From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] IB/iser: Handle lack of memory management extentions
 correctly
Date: Sun, 2 Jul 2017 13:19:48 +0300
Message-ID: <a5bcb1b5-6f9a-f6bd-cd3a-bf750bc19869@grimberg.me>
References: <20170622190110.27788.19910.stgit@phlsvslse11.ph.intel.com>
 <55a85363-da66-f6d6-f5cc-08b20f148f36@grimberg.me>
 <32E1700B9017364D9B60AED9960492BC34327953@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC34327953-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Rosenstein <thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> As for not having any max pages for FMR it's really annoying.
>>
>> What do you think about exposing max_fast_reg_page_list_len to
>> limit also for FMRs? We can also rename it to max_reg_page_list_len
>> to get rid of the FRWR association.
>>
>> Thoughts?
> 
> I have no issue with your proposal, but I would rather get this fixed and adjust the API with an additional fix.   I suspect we probably want to mark this fix stable.
> 
> I did audit the kernel ULPs for FMR vs. FRMR usage and the only one that looked at max_fast_reg_page_list_len unconditionally was iser.
> 
> Thomas, can you verify this patch and reply with a Tested-by:
> 
> Meanwhile, I will audit kernel providers for which ones besides qib do not support the extensions and FMR.

So what is the page_list limitation for qib? I want to prepare some 
patches...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
