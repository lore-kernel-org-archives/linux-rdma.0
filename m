From: Ramu <ramu.kavati-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Resolving IP addr to GID with librdmacm
Date: Wed, 24 Aug 2011 15:27:21 +0000 (UTC)
Message-ID: <loom.20110824T165557-959@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi, 
I am trying to explore the details of librdmacm.  When I ran qperf app (with
librdmacm as underlying user space cm module) on my Infiniband setup, it all
went fine i.e conn establishment and data path.  In this case, I had ib_ipoib
module loaded on both the sides and I gave remote IP addr associated with net
interface (ib0/ib1 etc.) exposed by infiniband hw (from Mellanox).

One of the doc from Infiniband hw vendor says that we need to have ib_ipoib
module loaded at both sides in order to map IP addr to GID.  But I am trying to
understand the dependency on ib_ipoib module.  I ran the below experiment to
explore on this.  

I have disabled ib0/ib1 interface (described above) and gave the remote IP addr
as the one associated with eth0 (normal LAN interface) then qperf client failed
with error "unexpected event from RDMA CM: Address error".  

In the code, it looks like during resolving IP addr to GID, one of the kernel
module (ib_addr) is using neigh_lookup(..) to get the hardware address of the
given IP.  I did not get the dependency on the module ib_ipoib to resolve remote
IP addr to GID.  Am I missing anything here? Please explain.

Thanks & Regards,
Ramu    

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
