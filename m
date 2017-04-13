From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: Don't clamp residual length to mtu
Date: Thu, 13 Apr 2017 14:00:00 +0200
Message-ID: <20170413120000.GI6734@linux-x5ow.site>
References: <20170406124944.11074-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170406124944.11074-1-jthumshirn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 06, 2017 at 02:49:44PM +0200, Johannes Thumshirn wrote:
> When reading a RDMA WRITE FIRST packet we copy the DMA length from the RDMA
> header into the qp->resp.resid variable for later use. Later in check_rkey()
> we clamp it to the MTU if the packet is an  RDMA WRITE packet and has a
> residual length bigger than the MTU. Later in write_data_in() we subtract the
> payload of the packet from the residual length. If the packet happens to have a
> payload of exactly the MTU size we end up with a residual length of 0 despite
> the packet not being the last in the conversation. When the next packet in the
> conversation arrives, we don't have any residual length left and thus set the QP

Hi Moni, Sagi and Max,

Any comments on this?

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
