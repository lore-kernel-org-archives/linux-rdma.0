From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/37] IB/rdmavt: Create module framework and handle driver registration
Date: Thu, 10 Dec 2015 08:18:28 -0500
Message-ID: <20151210131826.GA11526@phlsvsds.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com> <20151207204300.8144.20089.stgit@phlsvslse11.ph.intel.com> <566966CB.4080700@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <566966CB.4080700-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 01:49:31PM +0200, Haggai Eran wrote:
>On 07/12/2015 22:43, Dennis Dalessandro wrote:
>> +struct rvt_dev_info {
>> +	struct ib_device ibdev;
>> +	int (*port_callback)(struct ib_device *, u8, struct kobject *);
>> +
>> +	/*
>> +	 * TODO:
>> +	 *	need to reflect module parameters that may vary by dev
>> +	 */
>> +};
>
>Could you explain what you mean by the TODO comment? Different device
>drivers using rvt will have their own modules with their own parameters,
>right? Why do you need them reflected here?

I'm referring to module parameters of the driver which may have some impact 
on rdmavt. Initially things like the size of the qpn table which comes as a 
module parameter for qib and hfi1. However, I've started to fold that stuff 
into the dparms field so this comment can probably just be removed.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
