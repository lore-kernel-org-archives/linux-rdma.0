From: bhavinkumar thumar <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: How to write an SDP Zcopy enabled application
Date: Mon, 16 May 2011 12:04:00 +0530
Message-ID: <BANLkTi=mKqah1CC7mBQgTz_eD9GFdBt6hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

How can I write a socket application (client & server) which will use
the Zcopy path instead of Bcopy? I know that there is a parameter
called sdp_zcopy_threshold through which we can control the data
transfer modes. So if I write a socket application which has a call to
send with buffer size larger than sdp_zcopy_threshold, would it be
zero copied to receiver?


Thanks,
Bhavin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
