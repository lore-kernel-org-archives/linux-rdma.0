From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re:   [PATCH 0/8] IB/srp bug fixes
Date: Mon, 13 Feb 2017 22:02:12 -0500 (EST)
Message-ID: <1465409120.30916025.1487041332560.JavaMail.zimbra@redhat.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com> <20170210235611.3243-9-bart.vanassche@sandisk.com> <20170212171928.GF14015@mtr-leonro.local> <1041506550.30101266.1486922573298.JavaMail.zimbra@redhat.com> <1051975432.30101289.1486922792858.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1051975432.30101289.1486922792858.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Bart

The following 7 of 8 patches were applied to Linus's latest tree.

However this required first reverting 

commit ad8e66b4a80182174f73487ed25fd2140cf43361
Author: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Wed Dec 28 12:48:28 2016 +0200

See my other email regarding why the above needed to be reverted.

All tests passed in my mlx5 EDR-100 test bed for the ib-srp/mlx5 tests.

4.10.0-rc8.bart+

The revert of the above meant I did not apply and test patch 6 of the series
IB/srp: Use the IB_DEVICE_SG_GAPS_REG HCA feature if supported

  IB/srp: Avoid that duplicate responses trigger a kernel bug
  IB/srp: Fix race conditions related to task management
  IB/srp: Document locking conventions
  IB/srp: Make a diagnostic message more informative
  IB/srp: Improve an error path
  *** Not applied and not tested IB/srp: Use the IB_DEVICE_SG_GAPS_REG HCA feature if supported
  IB/core: Add support for draining IB_POLL_DIRECT completion queues
  IB/srp: Drain the send queue before destroying a QP

For the series except patch 6

Tested-by:     Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
