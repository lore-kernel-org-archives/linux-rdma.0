From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] qedr: Add support for memory registeration verbs
Date: Fri, 11 Nov 2016 16:22:16 +0300
Message-ID: <20161111132035.GA14072@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Ram Amrani,

The patch e0290cce6ac0: "qedr: Add support for memory registeration
verbs" from Oct 10, 2016, leads to the following static checker
warning:

	drivers/infiniband/hw/qedr/verbs.c:2164 init_mr_info()
	warn: missing error code here? 'qedr_alloc_pbl_tbl()' failed. 'rc' = '0'

drivers/infiniband/hw/qedr/verbs.c
  2144          rc = qedr_prepare_pbl_tbl(dev, &info->pbl_info,
  2145                                    page_list_len, two_layered);
  2146          if (rc)
  2147                  goto done;
  2148  
  2149          info->pbl_table = qedr_alloc_pbl_tbl(dev, &info->pbl_info, GFP_KERNEL);
  2150          if (!info->pbl_table) {
  2151                  rc = -ENOMEM;
  2152                  goto done;
  2153          }
  2154  
  2155          DP_DEBUG(dev, QEDR_MSG_MR, "pbl_table_pa = %pa\n",
  2156                   &info->pbl_table->pa);
  2157  
  2158          /* in usual case we use 2 PBLs, so we add one to free
  2159           * list and allocating another one
  2160           */
  2161          tmp = qedr_alloc_pbl_tbl(dev, &info->pbl_info, GFP_KERNEL);
  2162          if (!tmp) {
  2163                  DP_DEBUG(dev, QEDR_MSG_MR, "Extra PBL is not allocated\n");
  2164                  goto done;

Presumably we want to set rc = -ENOMEM on this path?

  2165          }
  2166  
  2167          list_add_tail(&tmp->list_entry, &info->free_pbl_list);
  2168  
  2169          DP_DEBUG(dev, QEDR_MSG_MR, "extra pbl_table_pa = %pa\n", &tmp->pa);
  2170  
  2171  done:
  2172          if (rc)
  2173                  free_mr_info(dev, info);
  2174  
  2175          return rc;
  2176  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
