From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/6] redhat/spec: clean up rsocket packaging
Date: Thu, 22 Dec 2016 10:33:02 -0700
Message-ID: <20161222173302.GA29518@obsidianresearch.com>
References: <20161221220840.36268-1-jarod@redhat.com>
 <20161221220840.36268-6-jarod@redhat.com>
 <140dc3aa-6088-c4cf-5a8a-1a0426f55cd3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <140dc3aa-6088-c4cf-5a8a-1a0426f55cd3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 22, 2016 at 02:17:52AM -0500, Jarod Wilson wrote:
> > %files -n librdmacm
> > %{_libdir}/librdmacm*.so.*
> >-%{_libdir}/rsocket/*.so.*
> >+%dir %{_libdir}/rsocket
> >+%{_libdir}/rsocket/*.so
> 
> Minor error here, should be rsocket/*.so* to pick up the symlinks too, at
> least until they get neutered.

FWIW, it would also be appropriate to put the LDPRELOAD library into
librdmacm-utils..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
