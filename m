From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 2/6] RDMA/ehca - ib_post_send fixes, v2
Date: Wed, 09 Dec 2009 15:08:09 -0800
Message-ID: <ada1vj3pwyu.fsf@roland-alpha.cisco.com>
References: <20091203023350.646158428@systemfabricworks.com>
	<4B17240D.8060906@zago.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B17240D.8060906-6OywahBdSro@public.gmane.org> (Frank Zago's message of "Wed, 02 Dec
	2009 20:35:57 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Frank Zago <frank-6OywahBdSro@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

thanks, applied... same complaints about formatting plus:

 > +	while(send_wr) {

checkpatch.pl warns about the missing space after "while" here.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
