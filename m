From: bhavinkumar thumar <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SDP zcopy performance measurement
Date: Mon, 25 Apr 2011 16:54:26 +0530
Message-ID: <BANLkTimet4Q0qYgsmf=jqOkTr72D3MOeCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I am having issue with SDP performance measurement. I tried Netperf
with following command:

LD_PRELOAD=libsdp.so netperf -L 172.31.133.1 -H 172.31.132.1 -c -C -- -m 655360

this doesn't work. sdp_zcopy_thresh is set to 65536.


Is there any other method to measure performance for SDP?

Please Help

Thanks
Bhavin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
