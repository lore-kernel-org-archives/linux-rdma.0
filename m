From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 11/16] ibacm: Add thread to monitor IP address changes
Date: Fri, 28 Mar 2014 15:51:31 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04B34C7A@CRSMSX101.amr.corp.intel.com>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
 <1395985810-23822-12-git-send-email-sean.hefty@intel.com>
 <53351A0D.1010007@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53351A0D.1010007-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On 03/28/14 06:50, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > +	while ((len = recv(sock, buffer, NL_MSG_BUF_SIZE, 0)) > 0) {
> > +		nlh = (struct nlmsghdr *)buffer;
> > +		while ((NLMSG_OK(nlh, len)) && (nlh->nlmsg_type !=
> NLMSG_DONE)) {
> > +			struct ifaddrmsg *ifa = (struct ifaddrmsg *)
> NLMSG_DATA(nlh);
> > +			struct ifinfomsg *ifi = (struct ifinfomsg *)
> NLMSG_DATA(nlh);
> > +			struct rtattr *rth = IFA_RTA(ifa);
> > +			int rtl = IFA_PAYLOAD(nlh);
> > +
> > +			switch (nlh->nlmsg_type) {
> > +			[ ... ]
> > +			nlh = NLMSG_NEXT(nlh, len);
> > +		}
> > +	}
> 
> Is there any reason why this code doesn't handle netlink buffer overflows
> (ENOBUFS) ? From the netlink(7) man page:

No reason other than my inexperience with netlink.

> 
> Netlink is not a reliable protocol. [ ... ] The kernel can't send a netlink
> message if the socket buffer is full: the message will be dropped and the
> kernel and the user-space process will no longer have the same view of
> kernel state. It is up to the application to detect when this happens (via the
> ENOBUFS error returned by recvmsg(2)) and resynchronize.

Thanks, I'll rework the patch to account for this.

Maybe by that time I will have Intel's email figured out...

Thanks,
Ira

> 
> Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
