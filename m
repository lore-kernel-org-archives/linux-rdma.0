From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] ibdiag_common.c: Add more supported
 device IDs
Date: Tue, 13 Jan 2015 08:09:44 -0500
Message-ID: <54B51918.20106@dev.mellanox.co.il>
References: <54B41B9D.5020700@dev.mellanox.co.il> <54B4C3C4.9000101@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B4C3C4.9000101-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/13/2015 2:05 AM, Or Gerlitz wrote:
> On 1/12/2015 9:08 PM, Hal Rosenstock wrote:
>> Add support for ConnectX-3 and ConnectX-4
> 
> So... ConnectX-3 isn't supported today?! 

It's just device IDs 0x1012 and 0x1013.

> on what infrastructure/tools exactly?

This only affects tool(s) which invoke this routine
(is_mlnx_ext_port_info_supported) which is
currently just ibportstate.

is_mlnx_ext_port_info_supported determines whether or not the MLNX
vendor extended port info SMP is sent which is used to determine FDR10
speed.

Not having the device in the list would only result in FDR10 being
misinterpreted as QDR.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
