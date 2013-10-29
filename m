From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC v1 01/10] IB/core: Introduce protected memory regions
Date: Tue, 29 Oct 2013 10:15:17 +0200
Message-ID: <526F6E95.5080100@mellanox.com>
References: <1382970376-13776-1-git-send-email-sagig@mellanox.com> <1382970376-13776-2-git-send-email-sagig@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237388CF1CDD@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CF1CDD-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/28/2013 11:22 PM, Hefty, Sean wrote:
>> +enum ib_mr_create_flags {
>> +		IB_MR_SIGNATURE_EN = 1,
>> +};
>> +
>> +/**
>> + * ib_mr_init_attr - Memory region init attributes passed to routine
>> + *	ib_create_mr.
>> + * @max_reg_descriptors: max number of registration units that
>> + *   may be used with UMR work requests.
>> + * @flags: MR creation flags bit mask.
>> + */
>> +struct ib_mr_init_attr {
>> +	int			max_reg_descriptors;
>> +	enum ib_mr_create_flags	flags;
> Assuming that flags will be a bitwise OR of values, they should be an int, not an enum.

Right, will fix. The same applies to signature caps in ib_device.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
