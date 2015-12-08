From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] net/mlx5_core: Configure HW to support
 atomic request in host endianness
Date: Tue, 8 Dec 2015 10:17:57 -0700
Message-ID: <20151208171757.GC13549@obsidianresearch.com>
References: <1449593656-8437-1-git-send-email-eranbe@mellanox.com>
 <1449593656-8437-2-git-send-email-eranbe@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1449593656-8437-2-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 08, 2015 at 06:54:15PM +0200, Eran Ben Elisha wrote:
> HW is capable of 2 requestor endianness modes for standard 8 Bytes
> atomic: BE (0x0) and host endianness (0x1). Read the supported modes
> from hca atomic capabilities and configure HW to host endianness mode if
> supported.

Uh, isn't this a user visible thing?

How will apps know if they need to swap or not?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
