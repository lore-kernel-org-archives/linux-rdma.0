From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: kernel inline sending / UARs / etc
Date: Mon, 08 Nov 2010 15:24:09 +0200
Message-ID: <4CD7F9F9.5070803@Voltaire.com>
References: <Pine.LNX.4.64.1011080936200.14213@zuben.voltaire.com>	<E113D394D7C5DB4F8FF691FA7EE9DB443D1BB38721@MTLMAIL.mtl.com>	<4CD7ABF4.5090305@Voltaire.com>	<E113D394D7C5DB4F8FF691FA7EE9DB443D1BB387C7@MTLMAIL.mtl.com>	<4CD7B463.2030402@voltaire.com> <4CD7B8B6.4060704@Voltaire.com>	<20101108084916.GD5921@mtldesk30> <4CD7BA12.5090704@Voltaire.com> <20101108124709.GG5921@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101108124709.GG5921@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> For IPoIB it gives ~1 usec for improvement in latency.

yep, this is what I expected, so over your testbed from what value to what value? also it 
would be important to note the change in the cpu utilization (e.g few "vmstat 1" output
lines before/after the change, while running IPoIB traffic)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
