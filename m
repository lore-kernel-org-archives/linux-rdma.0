From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 11/16] ibacm: Add thread to monitor IP address changes
Date: Fri, 28 Mar 2014 07:43:25 +0100
Message-ID: <53351A0D.1010007@acm.org>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com> <1395985810-23822-12-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395985810-23822-12-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/28/14 06:50, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> +	while ((len = recv(sock, buffer, NL_MSG_BUF_SIZE, 0)) > 0) {
> +		nlh = (struct nlmsghdr *)buffer;
> +		while ((NLMSG_OK(nlh, len)) && (nlh->nlmsg_type != NLMSG_DONE)) {
> +			struct ifaddrmsg *ifa = (struct ifaddrmsg *) NLMSG_DATA(nlh);
> +			struct ifinfomsg *ifi = (struct ifinfomsg *) NLMSG_DATA(nlh);
> +			struct rtattr *rth = IFA_RTA(ifa);
> +			int rtl = IFA_PAYLOAD(nlh);
> +
> +			switch (nlh->nlmsg_type) {
> +			[ ... ]
> +			nlh = NLMSG_NEXT(nlh, len);
> +		}
> +	}

Is there any reason why this code doesn't handle netlink buffer
overflows (ENOBUFS) ? From the netlink(7) man page:

Netlink is not a reliable protocol. [ ... ] The kernel can't send a
netlink message if the socket buffer is full: the message will be
dropped and the kernel and the user-space process will no longer have
the same view of kernel state. It is up to the application to detect
when this happens (via the ENOBUFS error returned by recvmsg(2)) and
resynchronize.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
