From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/mad: Fix an array index check
Date: Mon, 21 Nov 2016 12:52:50 -0800
Message-ID: <ab9e8563-160b-a9de-08b3-b09bdd52fbad@sandisk.com>
References: <94eb11fc-b558-b994-c933-da784caefc53@sandisk.com>
 <396b3fe2-6a84-efed-07de-3e6381009ad1@sandisk.com>
 <d5924c69-c052-84d3-06e3-b74ed8eb58d3@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d5924c69-c052-84d3-06e3-b74ed8eb58d3-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/21/2016 12:17 PM, Hal Rosenstock wrote:
> I think there is also similar thing in missing check in ib_register_mad_agent where:
> 
>         /*
>          * Make sure MAD registration (if supplied)
>          * is non overlapping with any existing ones
>          */
>         if (mad_reg_req) {
>                 mgmt_class = convert_mgmt_class(mad_reg_req->mgmt_class);
>                 if (!is_vendor_class(mgmt_class)) {
>                         class = port_priv->version[mad_reg_req->
>                                                    mgmt_class_version].class;
>                         if (class) {
>                                 method = class->method_table[mgmt_class];
> 
> so here the class' method_table is also accessed without checking mgmt_class for range violation, right ?

Hello Hal,

I think such a check is already present in ib_register_mad_agent():

		if (mad_reg_req->mgmt_class >= MAX_MGMT_CLASS) {
			/*
			 * IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE is the only
			 * one in this range currently allowed
			 */
			if (mad_reg_req->mgmt_class !=
			    IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) {
				dev_notice(&device->dev,
					   "%s: Invalid Mgmt Class 0x%x\n",
					   __func__, mad_reg_req->mgmt_class);
				goto error1;
			}
		} [ ... ]

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
