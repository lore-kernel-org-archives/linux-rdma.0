From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: hns compiler warnings
Date: Fri, 29 Dec 2017 12:58:32 -0700
Message-ID: <20171229195832.GG6513@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yisen Zhuang <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When !CONFIG_REGMAP hns throws compiler warnings since
dsaf_read_syscon ignores the return result from regmap_read, which
allows val to be uninited. This looks like a bug to me.

Could someone please send a patch to fix this? It probably isn't a
good idea to wrapper regmap_read with something that throws away the
return code.

Thanks
Jason

drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c: In function ‘cpld_set_led_id’:
drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c:165:26: warning: ‘val’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   mac_cb->cpld_led_value =
   ~~~~~~~~~~~~~~~~~~~~~~~^
    dsaf_read_syscon(mac_cb->cpld_ctrl,
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       mac_cb->cpld_ctrl_reg);
       ~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c: In function ‘hns_mac_get_sfp_prsnt’:
drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c:511:15: warning: ‘val’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  *sfp_prsnt = !dsaf_read_syscon(mac_cb->cpld_ctrl, mac_cb->cpld_ctrl_reg
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      + MAC_SFP_PORT_OFFSET);
      ~~~~~~~~~~~~~~~~~~~~~~
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
