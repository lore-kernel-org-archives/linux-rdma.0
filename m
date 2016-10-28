From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core v2 4/4] redhat/spec: build split rpm packages
Date: Fri, 28 Oct 2016 14:57:30 -0600
Message-ID: <20161028205730.GA31492@obsidianresearch.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161020153357.27286-1-jarod@redhat.com>
 <20161020153357.27286-5-jarod@redhat.com>
 <20161027211059.GA7224@obsidianresearch.com>
 <20161028171147.GJ42084@redhat.com>
 <20161028172503.GA28451@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161028172503.GA28451-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 28, 2016 at 11:25:03AM -0600, Jason Gunthorpe wrote:

> > Nah, I think things look good, and we can always keep tweaking as needed,
> > this is a solid update to work on top of.
> 
> Okay, I'll patch in the changes from this discussion and send the
> pull.

I added two commits:

https://github.com/linux-rdma/rdma-core/pull/30

This bit seems important:

--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -267,7 +267,7 @@ install -D -m0644 redhat/rdma.fixup-mtrr.awk %{buildroot}%{_libexecdir}/rdma-fix
 install -D -m0755 redhat/rdma.mlx4-setup.sh %{buildroot}%{_libexecdir}/mlx4-setup.sh
 
 # ibacm
-%{buildroot}/%{_bindir}/ib_acme -D . -O
+bin/ib_acme -D . -O
 install -D -m0644 ibacm_opts.cfg %{buildroot}%{_sysconfdir}/rdma/
 install -D -m0644 redhat/ibacm.service %{buildroot}%{_unitdir}/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
