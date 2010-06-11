From: Ding Dinghua <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: A strange problem when using IB to transfer things
Date: Fri, 11 Jun 2010 16:51:57 +0800
Message-ID: <AANLkTiml1Q7sD9MFsg_q1nQx5091rNnzhK8oh1aUnxwT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all:
         I'm using RDMA to do fs-metadata mirror between nodes. I
encountered a strange problem when the program was running:
Complete queue handler reported that the  RDMA-Write operation failed,
 the status of  corresponding "struct ib_wc" is "IB_WC_RETRY_EXC_ERR".
The problem is encountered randomly. I don't know the meaning of this
error code as well as what to do next. Would anyone give me some tips?
thanks a lot.
       My dev env is Centos5.3, IB card is "01:00.0 InfiniBand:
Mellanox Technologies MT25204 [InfiniHost III Lx HCA] (rev 20)".
       Please cc to me, since I haven't subscribe the list.

-- 
Ding Dinghua
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
