From: Stephen Bates <Stephen.Bates-PwyqCcigF0Q@public.gmane.org>
Subject: RE: [RFC 0/7] Peer-direct memory
Date: Wed, 24 Feb 2016 23:45:12 +0000
Message-ID: <36F6EBABA23FEF4391AF72944D228901EB712F72@BBYEXM01.pmc-sierra.internal>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
 <20160211191838.GA23675@obsidianresearch.com>
 <20160212201328.GA14122@infradead.org>
 <20160212203649.GA10540@obsidianresearch.com>
 <56C09C7E.4060808@dev.mellanox.co.il>
 <36F6EBABA23FEF4391AF72944D228901EB70C102@BBYEXM01.pmc-sierra.internal>
 <56C97E13.9090101@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C97E13.9090101-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "'Logan Gunthorpe' (logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org)" <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Haggi

> I'd be happy to see your RFC when you are ready. I see in the thread of [3]
> that you are using write-combining. Do you think your patchset will also be
> suitable for uncachable memory?

Great, we hope to have the RFC soon. It will be able to accept different flags for devm_memremap() call with regards to caching. Though one question I have is when does the caching flag affect Peer-2-Peer memory accesses? I can see caching causing issues when performing accesses from the CPU but P2P accesses should bypass any caches in the system?

> I don't think that's enough for our purposes. We have devices with rather
> small BARs (32MB) and multiple PFs that all need to expose their BAR to peer
> to peer access. One can expect these PFs will be assigned adjacent addresses
> and they will break the "one dev_pagemap per section" rule.

On the cards and systems I have checked even small BARs tend to be separated by more than one section's worth of memory.  As I understand it the allocation of BAR addresses is very ARCH and BIOS specific. Let's discuss this once the RFC comes out and see what options exist to address your concerns. 

> 
> > 4. The out of tree patch we did allows one to register the device memory as
> IO memory. However, we were only concerned with DRAM exposed on the
> BAR and so were not affected by the "i/o side effects" issues. Someone
> would need to think about how this applies to IOMEM that does have side-
> effects when accessed.
> With this RFC, we map parts of the HCA BAR that were mmapped to a
> process (both uncacheable and write-combining) and map them to a peer
> device (another HCA). As long as the kernel doesn't do anything else with
> these pages, and leaves them to be controlled by the user-space application
> and/or the peer device, I don't see a problem with mapping IO memory with
> side effects. However, I'm not an expert here, and I'd be happy to hear what
> others think about this.

See above. I think the upcoming RFC should provide support for both caching and uncashed mappings. I concur that even if the mappings are flagged as cachable there should be no issues as long as all accesses are from the peer-direct device.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
