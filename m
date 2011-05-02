From: bhavinkumar thumar <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Problem with ib_write_bw
Date: Mon, 2 May 2011 15:49:44 +0530
Message-ID: <BANLkTing3YebSw_=Wkonyayvss0V0MJRDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

#ib_write_bw -m 4096 -s 1048576
------------------------------------------------------------------
                    RDMA_Write BW Test
 Number of qp's running 1
 Connection type : RC
 Each Qp will post up to 100 messages each time
 Inline data is used up to 0 bytes message
 Link type is IB
Requested mtu is higher than active mtu
Changing to active mtu
 Mtu : 2048
 local address: LID 0x0e QPN 0x1f0405 PSN 0xcb8369 RKey 0x56002700
VAddr 0x002b47c7575000
Couldn't parse line <000d:230405:9017a6:fa042e00:00002b61c9213000:80:54>
Unable to Read from the socket
 Failed to exchange date between server and clients


what's wrong?

Thanks
Bhavin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
