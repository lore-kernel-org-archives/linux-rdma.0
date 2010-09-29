From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
Date: Wed, 29 Sep 2010 21:17:54 +0200
Message-ID: <201009292117.54828.arnd@arndb.de>
References: <20100929141112.26944.21931.stgit@build.ogc.int> <adawrq431sr.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adawrq431sr.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wednesday 29 September 2010 19:19:32 Roland Dreier wrote:
>  > @@ -182,6 +182,7 @@ static const struct file_operations qp_debugfs_fops = {
>  >      .open    = qp_open,
>  >      .release = qp_release,
>  >      .read    = debugfs_read,
>  > +    .llseek  = default_llseek,
>  >  };
> 
> I think this could actually be generic_file_llseek (right, Arnd?).

The main difference between default_llseek and generic_file_llseek
is that default_llseek doesn't care about the maximum file size
of the underlying file system, which is ULONG_MAX on debugfs,
so they are equivalent.

In general, the preferred one is no_llseek for those files where
you know you do not need to seek. If you do, I'd use default_llseek
for character devices and generic_file_llseek for file systems
that set the s_maxbytes.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
