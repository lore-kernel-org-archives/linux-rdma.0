From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: recommend setting for dev_loss_tmo and fast_io_fail_tmo
Date: Thu, 13 Jun 2013 19:52:14 +0400
Message-ID: <CACaajQuhmd8ExRHvQQBES43FNDWKGHxEb0DjmxWJ1K2=ybUuKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello. I'm using 3.9.5 and ib_srp_backport from github.
What is recommended setting for dev_loss_tmo and fast_io_fail_tmo ?
Now i have
dev_loss_tmo = 60
fast_io_fail_tmo = 40

Does it right?

I need to wait no more 100 seconds for failed path. (i'm use some xen
vm on this host and it linux kernels not like to stuck more than 120
seconds =))

--
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
