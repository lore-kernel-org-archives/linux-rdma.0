From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the bkl-llseek tree with the infiniband
 tree
Date: Wed, 29 Sep 2010 13:20:35 +1000
Message-ID: <20100929132035.18e89614.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, Roland Dreier <rdreier@cisco.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the bkl-llseek tree got a conflict in
drivers/infiniband/hw/cxgb4/device.c between commit
9e8d1fa3420f489da8a5da47c026511aa71fa50b ("RDMA/cxgb4: debugfs files for
dumping active stags") from the infiniband tree and commit
9711569d06e7df5f02a943fc4138fb152526e719 ("llseek: automatically
add .llseek fop") from the bkl-llseek tree.

The former added a whole new file_operations (and changed some
context) ... I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/infiniband/hw/cxgb4/device.c
index 986cfd7,a72ae12..0000000
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@@ -177,84 -149,44 +177,86 @@@ out
  	return ret;
  }
  
 -static ssize_t qp_read(struct file *file, char __user *buf, size_t count,
 -			loff_t *ppos)
 +static const struct file_operations qp_debugfs_fops = {
 +	.owner   = THIS_MODULE,
 +	.open    = qp_open,
 +	.release = qp_release,
 +	.read    = debugfs_read,
++	.llseek  = default_llseek,
 +};
 +
 +static int dump_stag(int id, void *p, void *data)
  {
 -	struct debugfs_qp_data *qpd = file->private_data;
 -	loff_t pos = *ppos;
 -	loff_t avail = qpd->pos;
 +	struct c4iw_debugfs_data *stagd = data;
 +	int space;
 +	int cc;
  
 -	if (pos < 0)
 -		return -EINVAL;
 -	if (pos >= avail)
 +	space = stagd->bufsize - stagd->pos - 1;
 +	if (space == 0)
 +		return 1;
 +
 +	cc = snprintf(stagd->buf + stagd->pos, space, "0x%x\n", id<<8);
 +	if (cc < space)
 +		stagd->pos += cc;
 +	return 0;
 +}
 +
 +static int stag_release(struct inode *inode, struct file *file)
 +{
 +	struct c4iw_debugfs_data *stagd = file->private_data;
 +	if (!stagd) {
 +		printk(KERN_INFO "%s null stagd?\n", __func__);
  		return 0;
 -	if (count > avail - pos)
 -		count = avail - pos;
 +	}
 +	kfree(stagd->buf);
 +	kfree(stagd);
 +	return 0;
 +}
  
 -	while (count) {
 -		size_t len = 0;
 +static int stag_open(struct inode *inode, struct file *file)
 +{
 +	struct c4iw_debugfs_data *stagd;
 +	int ret = 0;
 +	int count = 1;
  
 -		len = min((int)count, (int)qpd->pos - (int)pos);
 -		if (copy_to_user(buf, qpd->buf + pos, len))
 -			return -EFAULT;
 -		if (len == 0)
 -			return -EINVAL;
 +	stagd = kmalloc(sizeof *stagd, GFP_KERNEL);
 +	if (!stagd) {
 +		ret = -ENOMEM;
 +		goto out;
 +	}
 +	stagd->devp = inode->i_private;
 +	stagd->pos = 0;
  
 -		buf += len;
 -		pos += len;
 -		count -= len;
 +	spin_lock_irq(&stagd->devp->lock);
 +	idr_for_each(&stagd->devp->mmidr, count_idrs, &count);
 +	spin_unlock_irq(&stagd->devp->lock);
 +
 +	stagd->bufsize = count * sizeof("0x12345678\n");
 +	stagd->buf = kmalloc(stagd->bufsize, GFP_KERNEL);
 +	if (!stagd->buf) {
 +		ret = -ENOMEM;
 +		goto err1;
  	}
 -	count = pos - *ppos;
 -	*ppos = pos;
 -	return count;
 +
 +	spin_lock_irq(&stagd->devp->lock);
 +	idr_for_each(&stagd->devp->mmidr, dump_stag, stagd);
 +	spin_unlock_irq(&stagd->devp->lock);
 +
 +	stagd->buf[stagd->pos++] = 0;
 +	file->private_data = stagd;
 +	goto out;
 +err1:
 +	kfree(stagd);
 +out:
 +	return ret;
  }
  
 -static const struct file_operations qp_debugfs_fops = {
 +static const struct file_operations stag_debugfs_fops = {
  	.owner   = THIS_MODULE,
 -	.open    = qp_open,
 -	.release = qp_release,
 -	.read    = qp_read,
 +	.open    = stag_open,
 +	.release = stag_release,
 +	.read    = debugfs_read,
+ 	.llseek  = default_llseek,
  };
  
  static int setup_debugfs(struct c4iw_dev *devp)
