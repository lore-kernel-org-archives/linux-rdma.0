From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/ipath: sysfs and ipathfs support for core driver
Date: Tue, 8 Jul 2014 13:57:54 +0300
Message-ID: <20140708105754.GD19737@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bos-Hl0AACgZOF5l57MIdRCFDg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Bryan O'Sullivan,

This is a semi-automatic email about new static checker warnings.

The patch 3e9b4a5eb4ae: "IB/ipath: sysfs and ipathfs support for core 
driver" from Mar 29, 2006, leads to the following Smatch complaint:

drivers/infiniband/hw/ipath/ipath_fs.c:285 remove_file()
	 error: we previously assumed 'tmp->d_inode' could be null (see line 281)

drivers/infiniband/hw/ipath/ipath_fs.c
   280		spin_lock(&tmp->d_lock);
   281		if (!(d_unhashed(tmp) && tmp->d_inode)) {
                                         ^^^^^^^^^^^^
We allow that ->d_inode to be NULL.

   282			dget_dlock(tmp);
   283			__d_drop(tmp);
   284			spin_unlock(&tmp->d_lock);
   285			simple_unlink(parent->d_inode, tmp);
                                                       ^^^
But we dereference it inside the call to simple_unlink().  This code is
probably cut-and-pasted from configfs because I reported a bug in that
code as well yesterday but haven't heard back.

   286		} else
   287			spin_unlock(&tmp->d_lock);

drivers/infiniband/hw/qib/qib_fs.c
   458          spin_lock(&tmp->d_lock);
   459          if (!(d_unhashed(tmp) && tmp->d_inode)) {
                                         ^^^^^^^^^^^^
   460                  __d_drop(tmp);
   461                  spin_unlock(&tmp->d_lock);
   462                  simple_unlink(parent->d_inode, tmp);
                                                       ^^^
And another one here in qib_fs.c.

   463          } else {
   464                  spin_unlock(&tmp->d_lock);

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
