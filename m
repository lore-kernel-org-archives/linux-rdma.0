From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 6/9] IB/core: Sysfs support for peer memory
Date: Thu, 2 Oct 2014 10:41:12 -0600
Message-ID: <20141002164112.GE9639@obsidianresearch.com>
References: <1412176717-11979-1-git-send-email-yishaih@mellanox.com>
 <1412176717-11979-7-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1412176717-11979-7-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 01, 2014 at 06:18:34PM +0300, Yishai Hadas wrote:
> Supplies the required functionality to expose information and
> statistics over sysfs for a given peer memory client.
> 
> This mechanism enables userspace application to check
> which peers are available (based on name & version) and based on that
> decides whether it can run successfully.

Seems like this belongs in debugfs..

At a minimum you must provide documentation for sysfs files.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
