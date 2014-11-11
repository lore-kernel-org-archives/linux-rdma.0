From: Chuck Lever <chucklever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 07/10] xprtrdma: Display async errors
Date: Tue, 11 Nov 2014 10:52:49 -0600
Message-ID: <1D304B95-D745-42B2-9324-143A5002FB35@gmail.com>
References: <20141109010328.8806.5861.stgit@manet.1015granger.net> <20141109011501.8806.23478.stgit@manet.1015granger.net> <54621D8D.7050508@dev.mellanox.co.il>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54621D8D.7050508-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 11, 2014, at 8:30 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
>> On 11/9/2014 3:15 AM, Chuck Lever wrote:
>> An async error upcall is a hard error, and should be reported in
>> the system log.
>> 
> 
> Could be useful to others... Any chance you put this in ib_core for all
> of us?

Eventually. We certainly wouldn't want copies of this array of strings
to appear many times in the kernel. That would be a waste of space.

I have a similar patch that adds an array for CQ status codes, and
xprtrdma has a string array already for connection status. Are those
also interesting?--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
