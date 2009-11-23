From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: patch for non-ib network
Date: Sun, 22 Nov 2009 20:19:52 -0800
Message-ID: <adabpit6ffb.fsf@roland-alpha.cisco.com>
References: <Pine.LNX.4.62.0911201915430.25859@mailhub.cdac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.62.0911201915430.25859-NG0XCrj25/kh/ldBx82aDQ@public.gmane.org>
	(javed-If5XQcfNmg0@public.gmane.org's message of "Fri, 20 Nov 2009 19:54:41 +0530 (IST)")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: javed-If5XQcfNmg0@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > is it possible to add a patch in ofed release for non-ib networks?
 > we've integrated ofed with 'paramnet-3' a 10Gbps system area
 > network. currently IPoIB is working fine. more details can be provided
 > if required.

I think rather than worrying about OFED, you're better off working on
getting your drivers integrated in the mainline kernel.

However if you just have IPoIB working, and your fabric is not IB, then
I think you might be better off implementing IP-over-paramnet-3 and
avoiding the complexity of the RDMA stack.  Unless paramnet-3 is RDMA-like?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
