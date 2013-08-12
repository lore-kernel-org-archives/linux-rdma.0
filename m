From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs v2 00/11] make read_config() more robust
Date: Mon, 12 Aug 2013 13:26:54 -0600
Message-ID: <20130812192654.GC7968@obsidianresearch.com>
References: <cover.1375952089.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1375952089.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 08, 2013 at 09:40:43PM +0200, Yann Droneaud wrote:
> Please find patches to protect libibverbs from using invalid,
> unsecure configuration files.

I really don't think any of this is necessary.

The expected installation for verbs is:
 / is secure
 /etc is secure
 /etc/ibverbs.d is secure
 /etc/ibverbs.d/* is seucure and contains the correct contents.
[and similar statements about the shared libaries]

If these installation expectations are met then your patches are not
needed because all the path components are controlled exclusively by
root.

If you mis-install parts of your system with the wrong security
permissions then you will have a security problem.

It isn't the job of verbs to self-check the installation.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
