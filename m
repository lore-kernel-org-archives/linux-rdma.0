From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: IBoE and congestion management
Date: Thu, 19 Aug 2010 13:41:30 +0300
Message-ID: <4C6D0A5A.4020900@voltaire.com>
References: <4C62F86C.6060504@systemfabricworks.com>	<4C639635.4090704@voltaire.com> <4C6965EA.2050208@systemfabricworks.com>	<4C6CF139.1020405@Voltaire.com> <20100819093450.GA3225@eli-vm> <OFD964C280.7B7E4A90-ONC1257784.0038AAF8-C1257784.0039E842@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OFD964C280.7B7E4A90-ONC1257784.0038AAF8-C1257784.0039E842-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fredy Neeser <nfd-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fredy Neeser wrote:
> Not sure what you mean by "IB CM is fully functional for IBoE"  with 
> ConnectX.
>
The IB CM (Connection Manager) is used for the connection establishment, 
it has nothing do to with Congestion Management. I mentioned it in the 
context of IB MAD (Management Datagrams) support by IBoE. I believe that 
the RXE driver (IBoE hw emulation on regular Eth nics) emulates mads for 
the CM to work.
> Is your solution based on IB CCA?  If so, how will it interact with 
> 802.1Qau Congestion Notification?
>
I believe that IB CCA is not the correct path to go, but rather QCN 
which you've mentioned.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
