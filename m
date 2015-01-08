From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 03/16] ib/mad: Add check for jumbo MADs support on
 a device
Date: Thu, 8 Jan 2015 13:41:36 +0200
Message-ID: <54AE6CF0.30902@mellanox.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
 <1415908465-24392-4-git-send-email-ira.weiny@intel.com>
 <54770F44.2090909@mellanox.com> <54772C70.8060602@dev.mellanox.co.il>
 <54773C59.6080505@mellanox.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0CBEE86E@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CBEE86E-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/7/2015 6:32 PM, Weiny, Ira wrote:
>> >On 11/27/2014 3:51 PM, Sagi Grimberg wrote:
>>> > >We're already short on bits in device_cap_flags
>> >
>> >no shortage @ the kernel... we can add more 32 bits if/when we need it
> Why is there a gap in the bits?
>
> enum ib_device_cap_flags {
> ...
>          IB_DEVICE_MEM_WINDOW_TYPE_2B    = (1<<24),
>          IB_DEVICE_MANAGED_FLOW_STEERING = (1<<29),
> ...
> };
>
> 25-28 are not used?  Is there some legacy software out there which uses these?

sort of... the verbs RSS design which wasn't accepted upstream uses bits 
25/26/27 and Mellanox Core-Direct (whose verbs model called 
"Cross-Channel") which wasn't submitted upstream yet uses bit 28. Since 
in the kernel we can trivially use 64 bits, I would opt to keep these 
entries free for now.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
