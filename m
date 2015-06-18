From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH REPOST libibverbs] Add IP and TCP/UDP TX checksum offload
 support
Date: Thu, 18 Jun 2015 10:38:42 -0600
Message-ID: <20150618163842.GA14348@obsidianresearch.com>
References: <1434276784-15909-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434276784-15909-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 14, 2015 at 01:13:04PM +0300, Or Gerlitz wrote:
> From: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add a device capability flag IB_DEVICE_IP_SUM to denote checksum offload
> support. Devices should set this flag if they support insertion of IP, TCP
> and UDP checksums on outgoing IP packets sent over IB UD or ETH RAW_PACKET QPs.

It would be really nice to see the man page discuss exactly what is
done here, there are quite a few different options for checksum.

IPoIB maps this to 'NETIF_F_IP_CSUM', so only UDP/TCP checksum in
IPv4.

What value should be placed in the checksum header(s) prior to issuing
the send? It looks like IPoIB uses the CHECKSUM_PARTIAL protocol ?

This should all be made clear in the man page, IMHO.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
