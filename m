From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: RDMA with multiple read/write
Date: Thu, 18 Nov 2010 08:03:11 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B867F94C@orsmsx501.amr.corp.intel.com>
References: <5781964.1289558094205.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B852239F@orsmsx501.amr.corp.intel.com>
 <3625421.1290095447257.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3625421.1290095447257.SLOX.WebMail.wwwrun-XDIR3SKYeFbgKi2NxijLtw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> --> I register a single larger memory region with rdma_reg_msgs.
> What are parameters in rdma_post_recv function to use these "big" memory
> regions few times? In other words, on that MR can I write/read different
> smaller messages?

Just adjust the addr and length parameters.  For example:

buffer = calloc(MSG_COUNT, MSG_SIZE);

mr = rdma_reg_msgs(id, buffer, MSG_SIZE * MSG_COUNT);

for (offset = 0; offset < MSG_SIZE * MSG_COUNT; offset += MSG_SIZE)
	rdma_post_recv(id, context, buffer + offset, MSG_SIZE, mr);


Note that rdma_reg_msgs only supports send/receive messages.  You'll need to use rdma_reg_read or rdma_reg_write to mark a buffer for RDMA read or write operations, respectively.  Or, use ibv_reg_mr to support reads and writes.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
