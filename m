From: Christian Kniep <c.kniep-Pt+Xe7GJXK+P2YhJcF5u+nqWYbMAw+HU@public.gmane.org>
Subject: infiniband-diags needs libibmad with =?utf-8?b?J21hZF9kdW1wX21sbnhfZXh0X3BvcnRfaW5mbyc=?=
Date: Thu, 3 May 2012 06:26:04 +0000 (UTC)
Message-ID: <loom.20120503T081916-361@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey list,

I just compiled the newest version of libibumad,-ibmad, opensm and
infiniband-diags and I got an error I am not able to eliminate.
####
checking for mad_dump_mlnx_ext_port_info in -libmad... no
configure: error: mad_dump_mlnx_ext_port_info() not found.
        diags require libibmad with mad_dump_mlnx_ext_port_info support.
####
My installation on centos6.2 is discribed here:
https://github.com/ChristianKniep/QNIB/wiki/Installation

How could I fix this?

Thanks & kind regards
Christian

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
