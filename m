From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] IB/iser: Handle lack of memory management extentions
 correctly
Date: Thu, 29 Jun 2017 08:41:47 +0300
Message-ID: <c9b4c804-09d3-c02e-da21-32468e913c81@grimberg.me>
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


> I have no issue with your proposal, but I would rather get this fixed and adjust the API with an additional fix.   I suspect we probably want to mark this fix stable.

I agree, we should get it in and fix the API incrementally.

> I did audit the kernel ULPs for FMR vs. FRMR usage and the only one that looked at max_fast_reg_page_list_len unconditionally was iser.

Correct, but it doesn't mean that others get it right.

nfs uses a hard coded value without even knowing what the device is
capable of, and srp calculates it from max_mr_size which is a user-space
mr capability and has nothing to do with fmrs.

So no one got it right, which is not surprising as we don't have a cap
for it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
