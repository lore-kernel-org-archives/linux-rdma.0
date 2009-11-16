From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RESEND] ib/iser: re-write SG handling for rdma logic
Date: Mon, 16 Nov 2009 09:31:41 -0800
Message-ID: <ada7htqcr5u.fsf@roland-alpha.cisco.com>
References: <Pine.LNX.4.64.0911010824010.4388@zuben.voltaire.com>
	<4AF8142A.3070506@voltaire.com>
	<adapr7ry76j.fsf@roland-alpha.cisco.com>
	<4AFF9E90.8050208@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AFF9E90.8050208-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org> (Or Gerlitz's message of "Sun, 15
	Nov 2009 08:24:16 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Actually I started merging stuff without sending the "applied" emails
yet.  So far I have this in for-next:

Eli Cohen (2):
      IB/mlx4: Remove unneeded code
      IB/mlx4: Remove limitation on LSO header size

Or Gerlitz (1):
      IB/iser: Rewrite SG handling for RDMA logic

Roland Dreier (1):
      Merge branches 'cma', 'iser' and 'mlx4' into for-next

Sean Hefty (1):
      RDMA/ucma: Add option to manually set IB path

Yevgeny Petrilin (1):
      mlx4_core: Fix parsing of reserved EQ cap

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
