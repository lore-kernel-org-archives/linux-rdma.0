From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [ANNOUNCE]  libcxgb4-1.3.4 is released
Date: Wed, 18 Jun 2014 15:45:38 -0500
Message-ID: <53A1FA72.2040500@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Hariprasad S <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A new release of libcxgb4 (1.3.4) is available at

https://www.openfabrics.org/downloads/cxgb4/libcxgb4-1.3.4.tar.gz

with md5sum

52cc304e415cc7390a8944ddae8e7179 libcxgb4-1.3.4.tar.gz

I also pushed this to

git://git.openfabrics.org/~swise/libcxgb4

The tag is named v1.3.4.

Summary of v1.3.4:

Steve Wise (3):
       Account for the full qid range.
       Support the query_qp() verb
       Spin release 1.3.4

Yann Droneaud (2):
       kernel abi: adds explicit padding in struct c4iw_create_cq_resp
       kernel abi: adds explicit padding in struct c4iw_alloc_ucontext_resp


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
