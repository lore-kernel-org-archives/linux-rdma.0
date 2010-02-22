From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [ewg] nfsrdma fails to write big file,
Date: Mon, 22 Feb 2010 12:49:24 -0600
Message-ID: <4B82D1B4.2030902@opengridcomputing.com>
References: <9FA59C95FFCBB34EA5E42C1A8573784F02662E58@mtiexch01.mti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9FA59C95FFCBB34EA5E42C1A8573784F02662E58-SDnKeQl2TTymvrjiD8yIlgC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mahesh Siddheshwar <siddheshwar.mahesh-xsfywfwIY+M@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Vu Pham wrote:
> Setup: 
> 1. linux nfsrdma client/server with OFED-1.5.1-20100217-0600, ConnectX2
> QDR HCAs fw 2.7.8-6, RHEL 5.2.
> 2. Solaris nfsrdma server svn 130, ConnectX QDR HCA.
>
>
> Running vdbench on 10g file or *dd if=/dev/zero of=10g_file bs=1M
> count=10000*, operation fail, connection get drop, client cannot
> re-establish connection to server.
> After rebooting only the client, I can mount again.
>
> It happens with both solaris and linux nfsrdma servers.
>
> For linux client/server, I run memreg=5 (FRMR), I don't see problem with
> memreg=6 (global dma key)
>
>   

Awesome. This is the key I think.

Thanks for the info Vu,
Tom


> On Solaris server snv 130, we see problem decoding write request of 32K.
> The client send two read chunks (32K & 16-byte), the server fail to do
> rdma read on the 16-byte chunk (cqe.status = 10 ie.
> IB_WC_REM_ACCCESS_ERROR); therefore, server terminate the connection. We
> don't see this problem on nfs version 3 on Solaris. Solaris server run
> normal memory registration mode.
>
> On linux client, I see cqe.status = 12 ie. IB_WC_RETRY_EXC_ERR
>
> I added these notes in bug #1919 (bugs.openfabrics.org) to track the
> issue.
>
> thanks,
> -vu
> _______________________________________________
> ewg mailing list
> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
