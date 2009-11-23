From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: ib_post_send in drivers
Date: Mon, 23 Nov 2009 11:02:31 -0800
Message-ID: <adaocmt3vzs.fsf@roland-alpha.cisco.com>
References: <4B06C0EA.2070501@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B06C0EA.2070501-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> (frank zago's message of
	"Fri, 20 Nov 2009 10:16:42 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > It seems ib_post_send() is implemented slightly differently in the
 > various hardware drivers (as in kernel 2.6.31). Here are the
 > differences I've noticed regarding the bad_wr parameter.

Most of those appear to be bugs.  Patches fixing them would be welcome I
think.  (just to be clear -- splitting this up by driver is probably the
best idea, so that individual driver maintainers can review)

Thanks for auditing all this.

 - Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
