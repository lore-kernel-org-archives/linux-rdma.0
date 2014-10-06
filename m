From: Adam Brenner <aebrenne-sXc7qaQca9o@public.gmane.org>
Subject: NFS over RDMA with no TCP/UDP
Date: Mon, 6 Oct 2014 12:11:33 -0700
Message-ID: <CAO9TOLckugLP5_r+9MMeRWfCC3oXq8XcXbyaT7QgTyfg5i-now@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Howdy,

On our HPC cluster, we are exploring the option of mounting a NFS
client over RDMA where no TCP/UDP connection will be available. Both
the client and the server will have RDMA configured with OFED.

Is this possible?


If so, what address would we specify on the NFS client side as the
source host? iWARP address + port number? How I find out the iWARP
address? Is that the same as the GID given by the command ibaddr? Or
is this the Node GUID from ibstat? Do we have to safe escape or quote
this address for both the mount option and /etc/exports?

thanks,
/adam

--
Adam Brenner
Computer Science, Undergraduate Student
Donald Bren School of Information and Computer Sciences

System Administrator, HPC Cluster
Office of Information Technology
http://hpc.oit.uci.edu/

University of California, Irvine
www.ics.uci.edu/~aebrenne/
aebrenne-sXc7qaQca9o@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
