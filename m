From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: re librdmacm-devel dependency on librdmacm
Date: Wed, 2 Feb 2011 12:42:02 +0200
Message-ID: <4D4934FA.8070905@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

I just realized the librdmacm-devel (version 1.0.8-5.el5 is installed on 
the system I hit that) is dependent on librdmacm, and wasn't sure if its 
a bug or a feature... the dependency is created through 
/usr/lib64/librdmacm.so which is soft link to the obj file installed by 
librdmacm.

Or.

> [root@celery ~]# rpm -qR librdmacm-devel
> libibverbs-devel >= 1.1
> librdmacm = 1.0.8-5.el5
> librdmacm.so.1()(64bit)
> rpmlib(CompressedFileNames) <= 3.0.4-1
> rpmlib(PayloadFilesHavePrefix) <= 4.0-1
> [root@celery ~]# rpm -ql librdmacm-devel | grep -v man
> /usr/include/rdma
> /usr/include/rdma/rdma_cma.h
> /usr/include/rdma/rdma_cma_abi.h
> /usr/lib64/librdmacm.so
> [root@celery ~]# ls -l /usr/lib64/librdmacm*
> lrwxrwxrwx 1 root root    18 Feb  2 12:22 /usr/lib64/librdmacm.so -> 
> librdmacm.so.1.0.0
> lrwxrwxrwx 1 root root    18 Feb  2 12:22 /usr/lib64/librdmacm.so.1 -> 
> librdmacm.so.1.0.0
> -rwxr-xr-x 1 root root 21376 Jun 22  2009 /usr/lib64/librdmacm.so.1.0.0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
