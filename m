From: Vasant Hegde <vahegde1-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [libibverbs bug] Passing negative size to ibv_rc_pingpong causes
 seg fault
Date: Tue, 17 Jan 2012 16:24:59 +0530
Message-ID: <4F155383.4010008@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

Issue:
    ibv_rc_pingpong with negative size causes segfault

Steps :
    run below command :
        ibv_rc_pingpong -s -2048
        Segmentation fault

Package source :
    git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git
   
http://www.openfabrics.org/downloads/libibverbs/libibverbs-1.1.4-1.24.gb89d4d7.tar.gz

Solution :
    Currently we are not validating the input size passed by user.
Adding input size validation fixes this issue.

Thanks
Vasant



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
