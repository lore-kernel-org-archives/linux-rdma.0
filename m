From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv10 0/11] IBoE support to Infiniband
Date: Sun, 10 Oct 2010 10:44:52 +0200
Message-ID: <4CB17D04.1080509@voltaire.com>
References: <20100826141659.GA8795@mtldesk30> <4CADD1C1.90700@Voltaire.com> <4CB16892.5070708@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CB16892.5070708-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eldad Zinger <eldadz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Amir Vadai wrote:
> It is from the days that SDP over RoCE wasn't stable. In addition, when customers had a very long delay before TCP connection established, in the following scenario:
>    1. in libsdp.conf, setting mode to 'both' (Try SDP and fallback to TCP)
>    2. application tries to open socket to a remote peer connected using 10G ethernet
>    3. Remote host don't support RoCE.
> It took few seconds till the CMA gave up trying to connect, and SDP connection failed, and TCP connection was established.
>   
thanks for the clarification re remote host not supporting IBoE, anyway, 
I don't see if/what this has to do with sdp stability, its just a delay 
on the connection establishment and you say the default is to be changed 
to off for this param.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
