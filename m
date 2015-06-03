From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 2/9] IB/core: Change ib_create_cq to use
 struct ib_cq_init_attr
Date: Wed, 3 Jun 2015 10:02:37 -0600
Message-ID: <20150603160237.GA12073@obsidianresearch.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
 <1433074457-26437-3-git-send-email-ogerlitz@mellanox.com>
 <20150601165335.GB14391@obsidianresearch.com>
 <CAAKD3BAyNpEKwM7xu=LzFo2F=qP=EN9ZteL2yyAgBVuPNmvtqA@mail.gmail.com>
 <20150602172711.GB17776@obsidianresearch.com>
 <CAAKD3BA7ZD4Gx5c16Ak+0_64rzazw+7n4frkuKHyrvdT=8ac6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BA7ZD4Gx5c16Ak+0_64rzazw+7n4frkuKHyrvdT=8ac6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 03, 2015 at 12:04:23PM +0300, Matan Barak wrote:
> Why is it casting away the const?
> ib_create_cq gets a "struct ib_cq_init_attr *" and passes it to
> device->create_cq which gets a "const struct ib_cq_init_attr *",
> so I'm adding a const, which is perfectly fine.

Right, never mind, I read the patch upside down..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
