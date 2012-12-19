From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [infiniband:for-next 1/6]
 drivers/scsi/csiostor/t4fw_api_stor.h:48:2: error: redeclaration of
 enumerator 'FW_ENOEXEC'
Date: Thu, 20 Dec 2012 02:27:18 +0800
Message-ID: <50d20706.IibEEHISM+t3MU1D%fengguang.wu@intel.com>
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
commit: f2b7e78dbc79e09fc1164b226adc03ed91a326cb [1/6] cxgb4: Add T4 filter support
config: make ARCH=x86_64 allmodconfig

All error/warnings:

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

vim +/FW_ENOEXEC +48 drivers/scsi/csiostor/t4fw_api_stor.h

a3667aae Naresh Kumar Inna 2012-11-15  42  
a3667aae Naresh Kumar Inna 2012-11-15  43  enum fw_retval {
a3667aae Naresh Kumar Inna 2012-11-15  44  	FW_SUCCESS		= 0,	/* completed sucessfully */
a3667aae Naresh Kumar Inna 2012-11-15  45  	FW_EPERM		= 1,	/* operation not permitted */
a3667aae Naresh Kumar Inna 2012-11-15  46  	FW_ENOENT		= 2,	/* no such file or directory */
a3667aae Naresh Kumar Inna 2012-11-15  47  	FW_EIO			= 5,	/* input/output error; hw bad */
a3667aae Naresh Kumar Inna 2012-11-15 @48  	FW_ENOEXEC		= 8,	/* exec format error; inv microcode */
a3667aae Naresh Kumar Inna 2012-11-15  49  	FW_EAGAIN		= 11,	/* try again */
a3667aae Naresh Kumar Inna 2012-11-15  50  	FW_ENOMEM		= 12,	/* out of memory */
a3667aae Naresh Kumar Inna 2012-11-15  51  	FW_EFAULT		= 14,	/* bad address; fw bad */

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
