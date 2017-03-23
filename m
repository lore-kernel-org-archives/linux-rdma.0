From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 6/6] Bump version and update debian
Date: Thu, 23 Mar 2017 11:19:16 -0600
Message-ID: <20170323171916.GB5840@obsidianresearch.com>
References: <1490277329-8738-1-git-send-email-yishaih@mellanox.com>
 <1490277329-8738-7-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1490277329-8738-7-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There are still more places that need updating, see

Documentation/versioning.md

Or ec419980a7890b57ceaf6fefa797a365f2f5fed3

Please follow the commit message pattern from that example..

> index 3defc05..f47fcec 100644
> +++ b/debian/changelog
> @@ -1,5 +1,8 @@
> -rdma-core (13-1) unstable; urgency=low
> +rdma-core (14-1) unstable; urgency=low
> +
> +  * Bump version.

I haven't been adding new change log entires in the past, this is just
a standin file - Debian will maintain their own in their .diff. Same
with rpm.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
