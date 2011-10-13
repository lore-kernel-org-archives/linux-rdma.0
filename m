From: <Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: create new library project and few queries to open source
Date: Thu, 13 Oct 2011 09:40:18 -0700
Message-ID: <88B766C272F2C64B944B21AD078333151BB18C09A2@EXMAIL.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

1. I would like to submit user space library for a new RDMA adapter.
Can you please do needful for creating empty project under http://git.openfabrics.org/git/projects/~ppandit/libocrdma.git?

2. For adding hardware driver for a new RDMA adapter, to which git tree(s) do I need to submit patches? 
openfabrics.org as well as kernel.org or just openfabrics is sufficient?

git://git.openfabrics.org/ofed_1_5/linux-2.6.git, branch ofed_kernel_1_5?
and 
git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git, branch for-next?

4. I am little confused. 
pub/scm/linux/kernel/git/roland/infiniband.git is not showing up in the list at http://git.kernel.org.
Am I looking at wrong place? Or?

5. my_new_rdma_hw_driver that will be located in drivers/infiniband/hw/my_new_rdma_hw_driver directory, does it have to compile for all backports or only my desired kernel versions are sufficient for OFED 1.5.x, as I don't plan to support 2.6.22 and older kernel version?

6. If I have to support all backport kernel versions, do I need to submit patch for all the required kernel versions? Can this backport patches come at later stage?

Regards,
Parav Pandit

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
