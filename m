From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC 0/7] Peer-direct memory
Date: Sun, 14 Feb 2016 17:25:50 +0200
Message-ID: <56C09C7E.4060808@dev.mellanox.co.il>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
 <20160211191838.GA23675@obsidianresearch.com>
 <20160212201328.GA14122@infradead.org>
 <20160212203649.GA10540@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160212203649.GA10540-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-Dj0/KMMU01E@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Stephen Bates <stephen.bates-PwyqCcigF0Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> Agreed on all points.  Nevermind that seems to be missing a user of all
>> the newly added infrastructure, which should come with the series.
>
> Yep!
>
> I've heard from the people working on NVMe cards that this approach
> isn't needed, desired, or correct. I'm deeply skeptical that there
> would be an in-kernel user.

Hey Jason,

So regarding NVMe, a possible user for this would be a user-space NVMe
target implementation which wants to use a CMB (controller memory
buffer on the device bar) as an intermediate memory for RDMA. In case
the NVMe unplugs we can't rely on user-space to handle it, and need a
way to tell the HCA to tear down the CMB mappings.

I do think that this problem is solvable if we create a mmu_notitifier
client for this mapping (assuming that device unplug will trigger mmu
invalidate callouts on the relevant pages). But I'm still not exactly
sure how ZONE_DEVICE works with I/O device bar though (I'll appreciate
if someone can educate me here).

CC'ing sbates who played with this stuff at some point...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
