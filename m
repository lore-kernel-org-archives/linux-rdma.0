From: "Joel Nider" <JOELN-7z/5BgaJwgfQT0dZR+AlfA@public.gmane.org>
Subject: ib_create_qp failing
Date: Mon, 29 Jan 2018 10:50:39 +0200
Message-ID: <OF089AD255.99D19AC9-ONC2258224.002F8CF2-C2258224.00309558@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I have been trying to implement a kernel module (kernel 4.12) that opens 
an Infiniband connection, but have run into difficulties.  The call to 
ib_create_qp() fails with -EINVAL.  I have successfully set up the 
completion queues and protection domain. I have called ib_query_port() 
beforehand, which helps (I get farther along) but the ib_create_qp() call 
still fails.

>From userspace, I have no problems moving data over RoCE, so I'm assuming 
my hardware, kernel, OFED, etc are all OK.

I have used the net/smc module extensively as a reference, but there seems 
to be something fundamental that I'm missing.  How can I find out what's 
going wrong here?

Thanks,
Joel


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
