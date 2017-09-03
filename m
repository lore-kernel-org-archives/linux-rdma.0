From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] verbs: Tidy up ibverbs_get_device_list
Date: Sun, 3 Sep 2017 08:48:39 -0600
Message-ID: <20170903144839.GA20230@obsidianresearch.com>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1504212659-9674-5-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170903140351.GO10539@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170903140351.GO10539-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 03, 2017 at 05:03:51PM +0300, Leon Romanovsky wrote:
> > +			list_del(&sysfs_dev->entry);
> > +			// Ownership of sysfs_dev moves into vdev->sysfs
> 
> Please don't use "//" C++ style in C files.

I thought we were following the C11 rules? We use all the other
features now and don't support pre C11 compilers. (unlike the kernel)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
