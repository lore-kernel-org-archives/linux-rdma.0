From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 11/16] ibacm: Add thread to monitor IP address changes
Date: Fri, 28 Mar 2014 17:23:20 +0100
Message-ID: <5335A1F8.6040103@acm.org>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com> <1395985810-23822-12-git-send-email-sean.hefty@intel.com> <53351A0D.1010007@acm.org> <2807E5FD2F6FDA4886F6618EAC48510E04B34C7A@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E04B34C7A-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/28/14 16:51, Weiny, Ira wrote:
>> On 03/28/14 06:50, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>>> +	while ((len = recv(sock, buffer, NL_MSG_BUF_SIZE, 0)) > 0) {
>>> +		nlh = (struct nlmsghdr *)buffer;
>>> +		while ((NLMSG_OK(nlh, len)) && (nlh->nlmsg_type !=
>> NLMSG_DONE)) {
>>> +			struct ifaddrmsg *ifa = (struct ifaddrmsg *)
>> NLMSG_DATA(nlh);
>>> +			struct ifinfomsg *ifi = (struct ifinfomsg *)
>> NLMSG_DATA(nlh);
>>> +			struct rtattr *rth = IFA_RTA(ifa);
>>> +			int rtl = IFA_PAYLOAD(nlh);
>>> +
>>> +			switch (nlh->nlmsg_type) {
>>> +			[ ... ]
>>> +			nlh = NLMSG_NEXT(nlh, len);
>>> +		}
>>> +	}
>>
>> Is there any reason why this code doesn't handle netlink buffer overflows
>> (ENOBUFS) ? From the netlink(7) man page:
> 
> No reason other than my inexperience with netlink.

In that case it's probably helpful to have a look at the libnl
documentation. I'm not saying that library should be used here but it's
accompanied by excellent documentation about the netlink protocol. See
also http://www.carisma.slowglass.com/~tgr/libnl/ and
http://www.carisma.slowglass.com/~tgr/libnl/doc/core.html.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
