From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibv_req_notify_cq and multithreading
Date: Fri, 13 Jan 2012 16:37:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325676E20@ORSMSX101.amr.corp.intel.com>
References: <4F0EC562.2040709@list-group.com>
 <1828884A29C6694DAF28B7E6B8A8237325676B8F@ORSMSX101.amr.corp.intel.com>
 <4F0FE6D9.4050403@list-group.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F0FE6D9.4050403-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Point 2 is correct though? ibv_req_notify_cq() should be called before
> ibv_poll_cq()?

To be technical, I would state is as you need to poll after calling notify.  For example, the sequence poll - notify - poll is okay.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
