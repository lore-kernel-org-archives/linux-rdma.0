From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V6 3/5] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Mon, 06 Jul 2015 17:08:08 +0300
Message-ID: <559A8BC8.60507@dev.mellanox.co.il>
References: <1435659967-27173-1-git-send-email-yishaih@mellanox.com> <1435659967-27173-4-git-send-email-yishaih@mellanox.com> <20150630184035.GC2819@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150630184035.GC2819-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, achiang-VXdhtT5mjnY@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/30/2015 9:40 PM, Jason Gunthorpe wrote:
> On Tue, Jun 30, 2015 at 01:26:05PM +0300, Yishai Hadas wrote:
>>   struct ib_uverbs_device {
>> -	struct kref				ref;
>> +	struct kref				comp_ref;
>> +	struct kref				free_ref;
>
> So.. I was looking at this, and there is something wrong with the
> existing code.
>
> This old code:
>
> 	cdev_del(&uverbs_dev->cdev);
> 	[..]
>   	wait_for_completion(&uverbs_dev->comp);
> -	kfree(uverbs_dev);
>
> Has built in to it an assumption that when cdev_del returns there can
> be no possible open() running. Which doesn't appear to be true, cdev
> calls open unlocked and relies on refcounting to make everything work
> out.

The patch that introduces this bug was added 5 years ago by Alex Chiang 
and Signed-off-by: Roland Dreier.

Look at commit ID:2a72f212263701b927559f6850446421d5906c41, it can be 
seen also at: 
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2a72f212263701b 


Before this commit there was a device look-up table that was protected 
by a spin_lock used by ib_uverbs_open and by ib_uverbs_remove_one. When 
it was dropped and container_of was used instead, it enabled the race 
with remove_one as dev might be freed just after:
dev = container_of(inode->i_cdev, struct ib_uverbs_device, cdev) but 
before the kref_get.

In addition, this buggy patch added some dead code as 
container_of(x,y,z) can never be NULL and so dev can never be NULL.
As a result the comment above ib_uverbs_open saying "the open method 
will either immediately run -ENXIO" is wrong as it can never happen.

  static int ib_uverbs_open(struct inode *inode, struct file *filp)
  {
@@ -631,13 +628,10 @@ static int ib_uverbs_open(struct inode *inode, 
struct file *filp)
  	struct ib_uverbs_file *file;
  	int ret;

-	spin_lock(&map_lock);
-	dev = dev_table[iminor(inode) - IB_UVERBS_BASE_MINOR];
+	dev = container_of(inode->i_cdev, struct ib_uverbs_device, cdev);
  	if (dev)
  		kref_get(&dev->ref);
-	spin_unlock(&map_lock);
-
-	if (!dev)
+	else
  		return -ENXIO;


Doug/Jason,
AFAIK V6 addressed all opened comments raised by Jason, including the 
last one that asked to use 2 separate krefs for both complete and free, 
it didn't introduced the problem above.

I believe that we should go forward and take the series. Please consider 
that this series fixes an existing oops in patch #1 and adds a missing 
functionality in the kernel, "Enable device removal when there are 
active user space clients".

To fix the existing 5 years bug an orthogonal patch that fixes the buggy 
patch should be sent.

Alex/Roland:
Please review above, any option that you'll contribute a patch that 
solves that problem ? any comment on ?



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
