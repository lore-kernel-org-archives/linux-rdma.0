From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v1 0/5] Fix "support large inline thresholds"
Date: Fri, 20 Jan 2017 11:30:37 -0600
Message-ID: <021301d27342$e9f59fb0$bde0df10$@opengridcomputing.com>
References: <20170113173023.32692.30661.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170113173023.32692.30661.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> I've received a number of reports that v4.9 commit 655fec6987be
> ("xprtrdma: Use gathered Send for large inline messages") causes
> NFS/RDMA mounts to fail for devices that have a small max_sge.
> 
> This series addresses that problem.
> 
> A much smaller fix was provided initially. It worked for devices
> with as small as five send SGEs. However, additional research has
> shown that there is at least one in-tree device that supports only
> three send SGEs.
> 
> The current series should enable NFS/RDMA again on those devices.
> 
> 
> Available in the "nfs-rdma-for-4.10-rc" topic branch of this git repo:
> 
> git://git.linux-nfs.org/projects/cel/cel-2.6.git

Hey Chuck,

Tests ok on cxgb4.

Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
