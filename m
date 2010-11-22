From: Brian <balexander-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Subject: Problem Pinning Physical Memory
Date: Mon, 22 Nov 2010 18:28:47 +0000 (UTC)
Message-ID: <loom.20101122T192618-795@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ibv_reg_mr works fine as long as the shared region is in RAM. However, if I
change the memory region to the physical memory on a PCI device the call to
ibv_reg_mr fails. What should I be doing to register a physical memory region?

In searching through this forum I've seen some patches relating to
reg_io_mr/dereg_io_mr. However, I don't see those changes in the 1.5.2 ofed
sources. I had hoped to try applying the patches myself but the structure of the
unchanged code in the patches appears to be different than the 1.5.2 ofed
sources. Is there another, more recent, code base that I should be using?

Thank you in advance for your time and help! 

-Brian

PS. My apologies if this appears posted twice. I waited a couple of hours for
the original to post and it didn't - despite seeing later posts appear. 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
