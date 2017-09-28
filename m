From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 03/10] verbs: Split init_device into a match
 and alloc/bind step
Date: Thu, 28 Sep 2017 09:56:22 -0600
Message-ID: <20170928155622.GB16780@obsidianresearch.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1505855931-4956-4-git-send-email-jgunthorpe@obsidianresearch.com>
 <5a30e4a3-e22c-5d1a-435d-d3c5d94333fd@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5a30e4a3-e22c-5d1a-435d-d3c5d94333fd-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 26, 2017 at 07:00:16PM +0300, Yishai Hadas wrote:

> >+/* A rdma device detected in sysfs */
> >+struct verbs_sysfs_dev {
> >+	struct list_node entry;
> >+	void *provider_data;
> 
> It looks as this field isn't used in the series, correct ? if this is the
> case better add when it'll become applicable.

Ah, interesting. It is used during the series, but during the series
all the uses get removed and replaced with verbs_match_ent.driver_data
instead.

So it could be dropped at the patch that removes the last use.. I'll
look at that today.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
