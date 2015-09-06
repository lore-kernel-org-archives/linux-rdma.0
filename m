From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: RDMA/CM and multiple QPs
Date: Sat, 5 Sep 2015 23:45:50 -0700
Message-ID: <20150906064550.GA30683@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

right now RDMA/CM works on a QP basis, but seems very awakward if you
want multiple QPs as part of a single logical device, which will be
useful for a lot of modern protocols.  For example we will need to check
in the CM handler that we're not getting a different ib_device if we
want to apply the device limit in any sort of global scope, and it's
generally very hard to get a struct ib_device that can be used as
a driver model parent.

Is there any interest in trying to add an API to the CM to do a single
address resolution and allocate multiple QPs with these checks in
place?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
