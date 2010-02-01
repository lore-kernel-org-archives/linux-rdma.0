From: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Pull request for OFED 1.5
Date: Mon, 01 Feb 2010 15:38:15 -0800
Message-ID: <4B6765E7.4020900@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ramachandra.kuchimanchi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Vlad,

I found a small typo in the header guard of vnic_multicast.h which can
cause a compilation error, please pull.

Thanks -- Regards -- Andy

The following changes since commit 40fbb82255896a5c39b35035e2fd5202246b6508:
  Yevgeny Petrilin (1):
        mlx4_en: No need to set smaller tx queue len

are available in the git repository at:

  git://git.openfabrics.org/~agrover/ofed_1_5/linux-2.6.git
code-drop/20100201

Andy Grover (1):
      qlgc_vnic: Fix typo in header guard

 drivers/infiniband/ulp/qlgc_vnic/vnic_multicast.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
