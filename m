From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [infiniband:for-next 3/6]
 drivers/scsi/csiostor/t4fw_api_stor.h:43:6: error: nested redefinition of
 'enum fw_retval'
Date: Thu, 20 Dec 2012 02:33:29 +0800
Message-ID: <50d20879.UIpHtFATQzlWNmJM%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-next
head:   73b32b46c1484afa58e959fb62f9979516341998
commit: f65b56b15931dc180a89eb73596319f200bf5ddd [3/6] RDMA/cxgb4: Fix LE hash collision bug for active open connection
config: make ARCH=x86_64 allmodconfig

All error/warnings:

In file included from drivers/scsi/csiostor/csio_wr.h:42:0,
                 from drivers/scsi/csiostor/csio_scsi.h:49,
                 from drivers/scsi/csiostor/csio_init.h:45,
                 from drivers/scsi/csiostor/csio_attr.c:45:
drivers/scsi/csiostor/t4fw_api_stor.h:43:6: error: nested redefinition of 'enum fw_retval'
drivers/scsi/csiostor/t4fw_api_stor.h:43:6: error: redeclaration of 'enum fw_retval'
In file included from drivers/scsi/csiostor/csio_wr.h:41:0,
                 from drivers/scsi/csiostor/csio_scsi.h:49,
                 from drivers/scsi/csiostor/csio_init.h:45,
                 from drivers/scsi/csiostor/csio_attr.c:45:
drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:42:6: note: originally defined here
In file included from drivers/scsi/csiostor/csio_wr.h:42:0,
                 from drivers/scsi/csiostor/csio_scsi.h:49,
                 from drivers/scsi/csiostor/csio_init.h:45,
                 from drivers/scsi/csiostor/csio_attr.c:45:
drivers/scsi/csiostor/t4fw_api_stor.h:48:2: error: redeclaration of enumerator 'FW_ENOEXEC'
In file included from drivers/scsi/csiostor/csio_wr.h:41:0,
                 from drivers/scsi/csiostor/csio_scsi.h:49,
                 from drivers/scsi/csiostor/csio_init.h:45,
                 from drivers/scsi/csiostor/csio_attr.c:45:
drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:39:2: note: previous definition of 'FW_ENOEXEC' was here
In file included from drivers/scsi/csiostor/csio_wr.h:42:0,
                 from drivers/scsi/csiostor/csio_scsi.h:49,
                 from drivers/scsi/csiostor/csio_init.h:45,
                 from drivers/scsi/csiostor/csio_attr.c:45:
drivers/scsi/csiostor/t4fw_api_stor.h:50:2: error: redeclaration of enumerator 'FW_ENOMEM'
In file included from drivers/scsi/csiostor/csio_wr.h:41:0,
                 from drivers/scsi/csiostor/csio_scsi.h:49,
                 from drivers/scsi/csiostor/csio_init.h:45,
                 from drivers/scsi/csiostor/csio_attr.c:45:
drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:43:2: note: previous definition of 'FW_ENOMEM' was here
In file included from drivers/scsi/csiostor/csio_wr.h:42:0,
                 from drivers/scsi/csiostor/csio_scsi.h:49,
                 from drivers/scsi/csiostor/csio_init.h:45,
                 from drivers/scsi/csiostor/csio_attr.c:45:
drivers/scsi/csiostor/t4fw_api_stor.h:58:2: error: redeclaration of enumerator 'FW_EADDRINUSE'
In file included from drivers/scsi/csiostor/csio_wr.h:41:0,
                 from drivers/scsi/csiostor/csio_scsi.h:49,
                 from drivers/scsi/csiostor/csio_init.h:45,
                 from drivers/scsi/csiostor/csio_attr.c:45:
drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:44:2: note: previous definition of 'FW_EADDRINUSE' was here

vim +43 drivers/scsi/csiostor/t4fw_api_stor.h

a3667aae Naresh Kumar Inna 2012-11-15  37  
a3667aae Naresh Kumar Inna 2012-11-15  38  
a3667aae Naresh Kumar Inna 2012-11-15  39  /******************************************************************************
a3667aae Naresh Kumar Inna 2012-11-15  40   *   R E T U R N   V A L U E S
a3667aae Naresh Kumar Inna 2012-11-15  41   ********************************/
a3667aae Naresh Kumar Inna 2012-11-15  42  
a3667aae Naresh Kumar Inna 2012-11-15 @43  enum fw_retval {
a3667aae Naresh Kumar Inna 2012-11-15  44  	FW_SUCCESS		= 0,	/* completed sucessfully */
a3667aae Naresh Kumar Inna 2012-11-15  45  	FW_EPERM		= 1,	/* operation not permitted */
a3667aae Naresh Kumar Inna 2012-11-15  46  	FW_ENOENT		= 2,	/* no such file or directory */
a3667aae Naresh Kumar Inna 2012-11-15  47  	FW_EIO			= 5,	/* input/output error; hw bad */
a3667aae Naresh Kumar Inna 2012-11-15  48  	FW_ENOEXEC		= 8,	/* exec format error; inv microcode */
a3667aae Naresh Kumar Inna 2012-11-15  49  	FW_EAGAIN		= 11,	/* try again */
a3667aae Naresh Kumar Inna 2012-11-15 @50  	FW_ENOMEM		= 12,	/* out of memory */
a3667aae Naresh Kumar Inna 2012-11-15  51  	FW_EFAULT		= 14,	/* bad address; fw bad */
a3667aae Naresh Kumar Inna 2012-11-15  52  	FW_EBUSY		= 16,	/* resource busy */
a3667aae Naresh Kumar Inna 2012-11-15  53  	FW_EEXIST		= 17,	/* file exists */
a3667aae Naresh Kumar Inna 2012-11-15  54  	FW_EINVAL		= 22,	/* invalid argument */
a3667aae Naresh Kumar Inna 2012-11-15  55  	FW_ENOSPC		= 28,	/* no space left on device */
a3667aae Naresh Kumar Inna 2012-11-15  56  	FW_ENOSYS		= 38,	/* functionality not implemented */
a3667aae Naresh Kumar Inna 2012-11-15  57  	FW_EPROTO		= 71,	/* protocol error */
a3667aae Naresh Kumar Inna 2012-11-15 @58  	FW_EADDRINUSE		= 98,	/* address already in use */
a3667aae Naresh Kumar Inna 2012-11-15  59  	FW_EADDRNOTAVAIL	= 99,	/* cannot assigned requested address */
a3667aae Naresh Kumar Inna 2012-11-15  60  	FW_ENETDOWN		= 100,	/* network is down */
a3667aae Naresh Kumar Inna 2012-11-15  61  	FW_ENETUNREACH		= 101,	/* network is unreachable */

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
