From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Ummunotify: progress at last!
Date: Tue, 23 Mar 2010 16:01:21 -0400
Message-ID: <3B848E1F-C9B6-416A-9E6E-99604E71902A@cisco.com>
References: <1CDB2AA4-A8DF-4169-943E-4EA190814596@cisco.com> <20100323165920.GH29129@obsidianresearch.com> <D7DCABC9-4BB2-4FBA-A7B3-C06F4A848467@cisco.com> <20100323172953.GI29129@obsidianresearch.com> <5F80899D-F989-4162-B050-7E4D6B389876@cisco.com> <20100323195251.GJ29129@obsidianresearch.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100323195251.GJ29129-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Benton <brad.benton-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mar 23, 2010, at 3:52 PM, Jason Gunthorpe wrote:

> > > ibv_set_mmu_counter(verbs, &my_counter);
> > > ibv_get_mmu_notifications(verbs, &my_list, sizeof(my_list));
> 
> These are not hiding mmap/read, they are new uverbs 'syscalls' that
> get the kernel to perform that operation.

Oh -- so there's 2 mechanisms to get the counter info (for example):

1. the above uverb
2. mmap

Right?

I don't really have an opinion here -- I'm not really an "owner" of the ibv API.  As long as there is a fast/mmap way for me to get the counter without an extra function call, I'm happy.  :-)

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
