From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4] IB/{core, usnic}: Add generic function to extract IB speed from netdev
Date: Wed, 14 Jun 2017 23:13:32 +0300
Message-ID: <20170614201334.4654-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Please review this change which adds generic function to extract speed from
netdev and return IB speed to caller.

[PATCH v4 1/2] IB/usnic: Implement get_netdev hook
Preliminary and needed anyway patch which adds get_netdev implementation to
usnic driver.

[PATCH v4 2/2] IB/core: Add generic function to extract IB speed from
The actual patch that adds the $subject functionality.

Yuval
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
