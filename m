From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Sun, 26 Jul 2015 11:54:48 +0300
Message-ID: <55B4A058.5010806@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
 <55B0BEB4.9080702@dev.mellanox.co.il>
 <20150723184221.GA30303@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150723184221.GA30303-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
> I would like to see the kdoc for ib_map_mr_sg explain exactly what is
> required of the caller, maybe just hoist this bit from the
> ib_sg_to_pages

I'll add the kdoc.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
