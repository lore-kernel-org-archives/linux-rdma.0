From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: IB/iSER problems with Linux 3.0
Date: Tue, 17 Jan 2012 16:56:13 +0200
Message-ID: <4F158C0D.7070302@mellanox.com>
References: <CAJZOPZL=bV4SjdD2eakX9MhOhw=91xzCK=BEkirhRQd8oPA6bg@mail.gmail.com> <4F154CF2.7030504@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F154CF2.7030504-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/17/2012 12:26 PM, Sebastian Riemer wrote:
> In the log from working iSER there is the RDMA mapping debug message 
> at the position of the error in the other log

I didn't understand that comment, please clarify, anyway, could you try 
and patch your 3.0.15 kernel with commit 
52439540ea30396982b69662dd21aede6b336288 "IB/iser: DMA unmap TX bufs 
used for iSCSI/iSER headers" from upstream, this could help here.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
