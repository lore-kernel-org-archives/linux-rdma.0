From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 21/43] mlx5: Allocate a private page list in
 ib_alloc_mr
Date: Wed, 22 Jul 2015 19:51:14 +0300
Message-ID: <55AFCA02.5050907@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-22-git-send-email-sagig@mellanox.com>
 <20150722164605.GB6443@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150722164605.GB6443-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/22/2015 7:46 PM, Christoph Hellwig wrote:
> Just curious: what's the tradeoff between allocating the page list
> in the core vs duplicating it in all the drivers?  Does the driver
> variant give us any benefits?

It's not necessarily a page list... (i.e. a real scatterlist).
I it will make more sense in patch 41/43.

Moreover, as I wrote in the cover-letter. I noticed that several
drivers keep shadows anyway for various reasons. For example mlx4
sets the page list with a preset-bit (related to ODP...) so at
registration time we see the loop:

for (i = 0; i < mr->npages; ++i)
         mr->mpl[i] = cpu_to_be64(mr->pl[i] | MLX4_MTT_FLAG_PRESENT);

Given that this not a single example, I'd expect drivers to skip this
duplication (hopefully).

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
