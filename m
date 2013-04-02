From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fail post send command on error recovery
Date: Tue, 2 Apr 2013 14:24:27 +0300
Message-ID: <201304021424.28135.jackm@dev.mellanox.co.il>
References: <1364496315-7588-1-git-send-email-klebers@linux.vnet.ibm.com> <515AA1C6.7070804@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515AA1C6.7070804-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tuesday 02 April 2013 12:15, Or Gerlitz wrote:
> On 28/03/2013 20:45, Kleber Sacilotto de Souza wrote:
> > When the PCI adapter is going through error recovery, a call to
> > mlx4_ib_post_send() will return success without the command actually
> > arriving to the hardware. Adding a call to pci_channel_offline() to
> > check the state of the PCI slot and returning an error will allow the
> > upper layers to be aware that the command didn't succeed.
> 
> Is putting this call in fast path common practice in other (e.g 
> Ethernet) drivers?
> 
> Or.
> 
In addition, have you done any timing tests to see how this affects the
data path?  I am very concerned here that you penalize normal performance
for the sake of a very rare corner case.

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
