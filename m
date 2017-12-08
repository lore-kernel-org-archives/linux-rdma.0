From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/2] i40iw: patches for 4.16
Date: Fri,  8 Dec 2017 14:34:27 -0600
Message-ID: <1512765269-145929-1-git-send-email-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These patches are targeted for the 4.16 kernel.

Chien Tin Tung (1):
  i40iw: Use sqsize to initialize cqp_requests elements

Mustafa Ismail (1):
  i40iw: Reinitialize add_sd_cnt

 drivers/infiniband/hw/i40iw/i40iw_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
