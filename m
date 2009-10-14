From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 2/4] SRP fail-over faster
Date: Wed, 14 Oct 2009 11:04:44 -0700
Message-ID: <ada63aham2r.fsf@cisco.com>
References: <4AD3B443.7040107@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD3B443.7040107-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> (Vu Pham's message of "Mon, 12
	Oct 2009 15:57:07 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > -	wait_for_completion(&target->done);

How do you avoid leaking connection on module unload etc?  Don't we have
to wait for the disconnect to finish somewhere?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
