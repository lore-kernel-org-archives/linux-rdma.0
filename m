From: "Francisco Manuel Cardoso" <francisco.cardoso-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: NFS over RDMA in SLinux
Date: Thu, 5 Mar 2015 19:54:36 -0000
Message-ID: <000501d0577e$35db88a0$a19299e0$@gmail.com>
Reply-To: <francisco.cardoso-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-gb
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

 

Sorry newcomer to the group at the moment, brief question i hope someone can
at least point me.

Are there any considerations regarding NFS over RDMA on Linux SL6 ?

Question I've been setting up/using an HPC cluster and NFS over IPoIB it's
cool as soon as start dishing out things onto with the RDMA things go crazy.

The tipical setup is each machine is able to handle max 40 processes, using
all of those to mpi, I seem to be having some performance issues, if I scale
down to 39 I get much better performance still it crashes.

Anyone got any pointers ?

 

Cheers,

 

Francisco


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
