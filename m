From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Mon, 28 Nov 2016 10:00:56 -0700
Message-ID: <20161128170056.GC28381@obsidianresearch.com>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
 <1480258296-27032-2-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1480258296-27032-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 27, 2016 at 04:51:27PM +0200, Leon Romanovsky wrote:

> +static inline bool rdma_protocol_raw_packet(const struct ib_device *device, u8 port_num)
> +{
> +	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_RAW_PACKET;
> +}

Does the mlx drivers really register ports with different capabilities
as the same ib_device? I'm not sure that should be allowed.

I keep talking about how we need to get rid of the port_num in these
sorts of places because it makes no sense...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
