From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 0/6] IB Netlink Interface and RDMA CM exports
Date: Tue, 14 Dec 2010 11:27:46 -0700
Message-ID: <20101214182746.GB2506@obsidianresearch.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1292257370-24391-1-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 13, 2010 at 06:22:44PM +0200, Nir Muchtar wrote:

> static int format_address(void *addr, char *buff)
> {
> 	struct sockaddr_in *addr_in = (struct sockaddr_in *)addr;
> 	if (addr_in->sin_addr.s_addr) {
> 		sprintf(buff, "%s/%d", inet_ntoa(addr_in->sin_addr), ntohs(addr_in->sin_port));
> 	} 
> 	else
> 		sprintf(buff, "N/A");
> 	return 0;
> }

This should be:

static void format_address(const void *addr,size_t alen,
			   char *buff, size_t len)
{
	const sockaddr_storage *ss = addr;
	if (ss->ss_family == AF_INET && alen == sizeof(sockaddr_in)) {
	        const sockaddr_in *ss4 = addr;
                char S[64];
                snprintf(buff,len,"%s-%d",inet_ntop(ss->ss_family,ss4->sin_addr,S,sizeof(S)),ntohs(ss4->sin_port));
		return;
        }
	if (ss->ss_family == AF_INET6 && alen == sizeof(sockaddr_in6)) {
	        const sockaddr_in6 *ss6 = addr;
                char S[64];
                snprintf(buff,len,"%s-%d",inet_ntop(ss->ss_family,ss6->sin6_addr,S,sizeof(S)),ntohs(ss6->sin6_port));
		return;
        }
	snprintf(buff,len,"??");
}

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
