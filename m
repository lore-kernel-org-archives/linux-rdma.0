From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 0/6] IB Netlink Interface and RDMA CM exports
Date: Sun, 19 Dec 2010 16:30:27 +0200
Message-ID: <1292769027.2369.2127.camel@nirm-desktop>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
	 <20101214182746.GB2506@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101214182746.GB2506-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-12-14 at 11:27 -0700, Jason Gunthorpe wrote:

> This should be:
> 
> static void format_address(const void *addr,size_t alen,
> 			   char *buff, size_t len)
> {
> 	const sockaddr_storage *ss = addr;
> 	if (ss->ss_family == AF_INET && alen == sizeof(sockaddr_in)) {
> 	        const sockaddr_in *ss4 = addr;
>                 char S[64];
>                 snprintf(buff,len,"%s-%d",inet_ntop(ss->ss_family,ss4->sin_addr,S,sizeof(S)),ntohs(ss4->sin_port));
> 		return;
>         }
> 	if (ss->ss_family == AF_INET6 && alen == sizeof(sockaddr_in6)) {
> 	        const sockaddr_in6 *ss6 = addr;
>                 char S[64];
>                 snprintf(buff,len,"%s-%d",inet_ntop(ss->ss_family,ss6->sin6_addr,S,sizeof(S)),ntohs(ss6->sin6_port));
> 		return;
>         }
> 	snprintf(buff,len,"??");
> }
> 
> Jason

Don't believe all this IPv6 hype ;)
seriously though, The demo application is solely meant as an
illustration for the means of communications with the current design.
It's going to be rewritten in the future.

Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
