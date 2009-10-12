From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: Add a new supported 40 GigE device ID
Date: Mon, 12 Oct 2009 07:43:36 -0700
Message-ID: <adaskdohduv.fsf@cisco.com>
References: <20091012143015.GA27990@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091012143015.GA27990@mtls03> (Eli Cohen's message of "Mon, 12
	Oct 2009 16:30:15 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

same comment -- This patch doesn't apply since e76d0b67 ("mlx4_core: Add
40GigE device ID") which adds ID 0x676e for 40GE.  (and which is
upstream in 2.6.32-rc4)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
