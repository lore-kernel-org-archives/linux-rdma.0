From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] verbs: Add an option to provide vendor
 private data when creating a CQ
Date: Tue, 14 Mar 2017 09:42:09 -0600
Message-ID: <20170314154209.GA3244@obsidianresearch.com>
References: <1488809204-30428-1-git-send-email-yishaih@mellanox.com>
 <1488809204-30428-5-git-send-email-yishaih@mellanox.com>
 <20170306180723.GD11805@obsidianresearch.com>
 <d3cc85f3-d5ef-5114-68a3-6989b5b26478@dev.mellanox.co.il>
 <20170307181738.GC2228@obsidianresearch.com>
 <6da2bd37-62c3-af73-fe81-5be57a327c2d@dev.mellanox.co.il>
 <20170307222228.GB15314@obsidianresearch.com>
 <b60069df-4c2f-6378-b9cb-b5e74acc8185@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b60069df-4c2f-6378-b9cb-b5e74acc8185-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 14, 2017 at 05:14:55PM +0200, Yishai Hadas wrote:
> It's not an issue of 'basic' and 'complex' API but a question of code
> sharing and resource managing.

This can always be acheived with some code restructuring.

eg we can put the tail of __lib_ibv_create_cq_ex into a helper, or
have an internal create_cq that accepts the void *provider_data

There is a lot less code inside libibverbs that outside, I'd rather
have an obvious clean user API than make our lives a tiny bit easier.

> >>Once the correct structure is used there should be *no* safety
> >>issue, please note that the vendor data defined to be as some
> >>extended structure which can only be grown based on comp_mask so
> >>that compatibility will be saved in any case.
> >
> >No, you still have to make sure that your ib_device is somehow a mlx5.
> 
> We are talking on an application that previously read some vendor
> capabilities using a direct API (e.g. mlx5dv_query_device) to know whether
> the vendor functionality is supported.

With these patches if the app passes the wrong thing into the
vendor_data it crashes, with a mlx5_create_cq it would get an error
code. Error codes are better.

Yishai, even if we go this way, stop using the word 'vendor'. It is
not vendor data.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
