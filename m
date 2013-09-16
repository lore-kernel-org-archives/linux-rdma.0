From: Eva Mishra <eva.mishra2007-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: memory registration using zero based virtual address
Date: Mon, 16 Sep 2013 17:39:14 +0530
Message-ID: <CAAcPZE5q9HY7CWcMhMSQceo4URSr8cOPpA9ZtkvW_izjGQLVDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

i understood following steps for memory registration using zero based
virtual address

step 1:  allocate a buffer. return address is a virtual address.
step 2:  in memory registration verb, provide virtual address returned
in step 1 and set Type of VA as zbva.
step 3:  in the verb for posting operation, address of zero can be
passed, since first memory location of returned MR has virtual address
of zero as per IB spec

is the above understanding of zbva correct.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
