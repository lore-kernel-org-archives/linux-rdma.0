From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/qib: Add congestion control agent implementation
Date: Fri, 20 Jul 2012 14:05:28 +0300
Message-ID: <20120720110528.GA31382@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Mike Marciniszyn,

The patch 36a8f01cd24b: "IB/qib: Add congestion control agent
implementation" from Jul 19, 2012, leads to the following warning:
drivers/infiniband/hw/qib/qib_init.c:230 qib_init_pportdata()
	 warn: value 1984 can't fit into 255 'ppd->cc_supported_table_entries'

drivers/infiniband/hw/qib/qib_init.c
   227          if (qib_cc_table_size < IB_CCT_MIN_ENTRIES)
   228                  goto bail;
   229  
   230          ppd->cc_supported_table_entries = min(max_t(int, qib_cc_table_size,
   231                  IB_CCT_MIN_ENTRIES), IB_CCT_ENTRIES*IB_CC_TABLE_CAP_DEFAULT);
                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
						64 * 31 = 1984
->cc_supported_table_entries is a u8 so 1984 gets truncated.

   232  
   233          ppd->cc_max_table_entries =
   234                  ppd->cc_supported_table_entries/IB_CCT_ENTRIES;
   235  

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
