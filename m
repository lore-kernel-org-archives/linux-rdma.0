From: Alex Merritt <merritt.alex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SDP Kernel Module Compilation
Date: Fri, 16 Dec 2011 13:42:55 -0500
Message-ID: <CADK3ta+r4+nZ+p=SvDCL5KacOv94fuoKKA2=df2Gm=H8f67Oig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I'm running a non-RPM system and have installed most of the libraries
and the kernel/modules from git repositories directly. My goal is to
run applications via SDP. The SDP library is installed, but I cannot
seem to find the kernel module anywhere. In Roland's kernel git
sources, there is no sdp directory in drivers/infiniband/ulp. Am I
missing something? Does the OFED package have it because the module is
compiled outside of the kernel sources?

Thanks,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
