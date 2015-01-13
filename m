From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] ibdiag_common.c: Add more supported
 device IDs
Date: Tue, 13 Jan 2015 16:22:44 +0200
Message-ID: <54B52A34.4060300@mellanox.com>
References: <54B41B9D.5020700@dev.mellanox.co.il>
 <54B4C3C4.9000101@mellanox.com> <54B51918.20106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B51918.20106-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/13/2015 3:09 PM, Hal Rosenstock wrote:
> On 1/13/2015 2:05 AM, Or Gerlitz wrote:
>> >On 1/12/2015 9:08 PM, Hal Rosenstock wrote:
>>> >>Add support for ConnectX-3 and ConnectX-4
>> >
>> >So... ConnectX-3 isn't supported today?!
> It's just device IDs 0x1012 and 0x1013
I don't see these devices in the mlx4 core driver PCI table 
(mlx4_pci_table in main.c) nor in libmlx4, not sure what you are 
referring to  here...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
