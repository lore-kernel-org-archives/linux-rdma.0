From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 00/24] New fast registration API
Date: Wed, 7 Oct 2015 02:20:24 -0700
Message-ID: <20151007092024.GA18020@infradead.org>
References: <560AE099.2080004@sandisk.com>
 <560AFB71.3010003@dev.mellanox.co.il>
 <560C30F4.50900@sandisk.com>
 <560C42CE.6090000@sandisk.com>
 <560CDDBC.8000400@dev.mellanox.co.il>
 <560D730C.9000302@sandisk.com>
 <560D9E69.70604@sandisk.com>
 <35618B90-4D6E-4036-A69B-4405F020D440@dev.mellanox.co.il>
 <560EA4A1.3080709@sandisk.com>
 <56138854.4040209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56138854.4040209-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 06, 2015 at 11:37:40AM +0300, Sagi Grimberg wrote:
> The issue is that the device requires the MR page array to have
> an alignment (0x40 for mlx4 and 0x400 for mlx5). When I modified the
> page array allocation to be non-coherent I didn't take care of
> alignment.

Just curious:  why did you switch away from the coheret dma allocations
anyway?  Seems like the page lists are mapped as long as they are
allocated so the coherent allocator would seem like a nice fit.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
