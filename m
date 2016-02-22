From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 5/8] IB/{core,ulp} Support above 32 possible
 device capability flags
Date: Mon, 22 Feb 2016 13:02:23 -0700
Message-ID: <20160222200223.GA26459@obsidianresearch.com>
References: <1455954465-15141-1-git-send-email-leon@leon.nu>
 <1455954465-15141-6-git-send-email-leon@leon.nu>
 <56C969B5.5080802@mellanox.com>
 <20160221080053.GL30450@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160221080053.GL30450-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 21, 2016 at 10:00:53AM +0200, Leon Romanovsky wrote:
> Current implementation doesn't change ipoib behavior and easy for
> review without extra knowledge of ipoib internals, so let's stay this
> change as is.

It is one line to fix ipoib's size, and avoids this subtle future land
mine. I'm with Haggi on this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
