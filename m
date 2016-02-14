From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [RFC 0/7] Peer-direct memory
Date: Sun, 14 Feb 2016 16:27:20 +0200
Message-ID: <56C08EC8.10207@mellanox.com>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
 <20160211191838.GA23675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160211191838.GA23675@obsidianresearch.com>
Sender: owner-linux-mm@kvack.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Kovalyov Artemy <artemyko@mellanox.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "leon@leon.ro" <leon@leon.ro>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

[apologies: sending again because linux-mm address was wrong]

On 11/02/2016 21:18, Jason Gunthorpe wrote:
> Resubmit those parts under the mm subsystem, or another more
> appropriate place.

We want the feedback from linux-mm, and they are now Cced.

> If you want to make some incremental progress then implement the
> existing ZONE_DEVICE API for the IB core and add the invalidate stuff
> later, once you've negotiated a common API for that with linux-mm.

So there are couple of issues we currently have with ZONE_DEVICE. 
Perhaps they can be solved and then we could use it directly.

First, I'm not sure it is intended to be used for our purpose. 
memremap() has this comment [1]:
> memremap() is "ioremap" for cases where it is known that the resource
> being mapped does not have i/o side effects and the __iomem
> annotation is not applicable. 

Does this apply also to devm_memremap_pages()? Because the HCA BAR 
clearly doesn't fall under this definition.

Second, there's a requirement that ZONE_DEVICE ranges are aligned to 
section-boundary, right? We have devices that have 8MB or 32MB BARs, 
so they won't work with 128MB sections on x86_64.

Third, I understand there was a desire to place ZONE_DEVICE page structs 
in the device itself. This can work for pmem, but obviously won't work 
for an I/O device BAR like an HCA.

Regards,
Haggai

[1] http://lxr.free-electrons.com/source/kernel/memremap.c?v=4.4#L38

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
