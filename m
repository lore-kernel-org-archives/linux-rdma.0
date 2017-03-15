From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/7] Fix various missing swaps in
 debugging/logging macros
Date: Wed, 15 Mar 2017 09:58:27 -0600
Message-ID: <20170315155827.GC29562@obsidianresearch.com>
References: <1489508474-16664-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1489508474-16664-4-git-send-email-jgunthorpe@obsidianresearch.com>
 <SN1PR07MB22075A6E4341F141A27692ECF8270@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB22075A6E4341F141A27692ECF8270-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 15, 2017 at 07:24:06AM +0000, Amrani, Ram wrote:

> How did sparse "know" what is little/big endian and where to use each?

It is like the kernel, we have to add __be32/etc all over the place

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
