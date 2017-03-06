From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 08/14] mlx5: Update to use new udma write
 barriers
Date: Mon, 6 Mar 2017 16:19:21 +0200
Message-ID: <bc987646-d8b2-2d7e-7606-8a1dcbe1464d@dev.mellanox.co.il>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-9-git-send-email-jgunthorpe@obsidianresearch.com>
 <d5921636-1911-5588-8c59-620066bca01a@dev.mellanox.co.il>
 <20170227180009.GL5891@obsidianresearch.com>
 <2969cce4-8b51-8fcf-f099-2b42a6d40a9c@dev.mellanox.co.il>
 <20170228170658.GA17995@obsidianresearch.com>
 <24bf0e37-e032-0862-c5b9-b5a40fcfb343@dev.mellanox.co.il>
 <20170302171210.GA8595@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170302171210.GA8595-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/2/2017 7:12 PM, Jason Gunthorpe wrote:
> Are you happy with the other things now as well?

No, it looks like the barriers patch for mlx4 introduced performance 
degradation which we don't accept, will answer on with the exact details 
shortly.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
