From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/ipath: infiniband verbs support
Date: Wed, 16 Sep 2015 09:30:59 +0300
Message-ID: <20150916063059.GA23123@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bos-Hl0AACgZOF5l57MIdRCFDg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Bryan O'Sullivan,

The patch 6522108f19a9: "IB/ipath: infiniband verbs support" from Mar
29, 2006, leads to the following static checker warning:

	drivers/staging/rdma/ipath/ipath_verbs.c:2289 show_hca()
	warn: bool is not less than zero.

drivers/staging/rdma/ipath/ipath_verbs.c
  2281  static ssize_t show_hca(struct device *device, struct device_attribute *attr,
  2282                          char *buf)
  2283  {
  2284          struct ipath_ibdev *dev =
  2285                  container_of(device, struct ipath_ibdev, ibdev.dev);
  2286          int ret;
  2287  
  2288          ret = dev->dd->ipath_f_get_boardname(dev->dd, buf, 128);
  2289          if (ret < 0)

ret is either zero or one, not negative.  There is some dead code in
ipath_ht_boardname() which indicates that it might have returned error
codes at some point as well.

This warning is from a too many false positives to publish Smatch check.

  2290                  goto bail;
  2291          strcat(buf, "\n");
  2292          ret = strlen(buf);
  2293  
  2294  bail:
  2295          return ret;
  2296  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
