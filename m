From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH,RFC] nfsd: Make INET6 transport creation failure an informational message
Date: Fri, 02 Apr 2010 10:22:17 -0700
Message-ID: <adaljd57os6.fsf@roland-alpha.cisco.com>
References: <4BB522CF.60503@opengridcomputing.com>
	<4BB61F19.2000403@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BB61F19.2000403-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> (Chuck Lever's message of "Fri, 02
	Apr 2010 12:45:13 -0400")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > The write_ports code will fail both the INET4 and INET6 transport
 > > creation if
 > > the transport returns an error when PF_INET6 is specified. Some transports
 > > that do not support INET6 return an error other than EAFNOSUPPORT.
 > 
 > That's the real bug.  Any reason the RDMA RPC transport can't return
 > EAFNOSUPPORT in this case?

I think Tom's changelog is misleading.  The problem is that the RDMA
transport actually does support IPv6, but it doesn't support the
IPV6ONLY option yet.  So if NFS/RDMA binds to a port for IPv4, then the
IPv6 bind fails because of the port collision.

Implementing the IPV6ONLY option for RDMA binding is probably not
feasible for 2.6.34, so the best band-aid for now seems to be Tom's
patch.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
