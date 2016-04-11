From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v1 05/18] xprtrdma: Avoid using Write list for small NFS READ requests
Date: Mon, 11 Apr 2016 15:35:35 -0500
Message-ID: <033901d19431$b3725d20$1a571760$@opengridcomputing.com>
References: <20160411200323.20531.8893.stgit@manet.1015granger.net> <20160411201050.20531.53651.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160411201050.20531.53651.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Avoid the latency and interrupt overhead of registering a Write
> chunk when handling NFS READ requests of a few hundred bytes or
> less.
> 
> This change does not interoperate with Linux NFS/RDMA servers
> that do not have commit 9d11b51ce7c1 ('svcrdma: Fix send_reply()
> scatter/gather set-up').
> 
> $ git describe 9d11b51ce7c1
> v4.2-rc3-10-g9d11b51
>

Hey Chuck,

Is there any way to avoid breaking interoperability with older servers?

Steve 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
