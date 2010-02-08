From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Patch series from Dec 2009 which needs reviewing/applying
Date: Mon, 08 Feb 2010 09:09:35 -0800
Message-ID: <adapr4fwt68.fsf@roland-alpha.cisco.com>
References: <201002041059.09368.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201002041059.09368.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> (Jack Morgenstein's
	message of "Thu, 4 Feb 2010 10:59:08 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > [PATCH 0/2] fix SRQ WQE buffer initialization in liblmx4 and in mlx4_ib
 > http://www.spinics.net/lists/linux-rdma/msg01911.html

This isn't a patch AFAICT.

 > [PATCH 1/2] libmlx4: initialize SRQ scatter entries when creating an SRQ
 > http://www.spinics.net/lists/linux-rdma/msg01912.html

Just applied this.

 > [PATCH 2/2] mlx4_ib: initialize SRQ scatter entries when creating an SRQ
 > http://www.spinics.net/lists/linux-rdma/msg01910.html

Has been upstream as 4c425588 for a few weeks.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
