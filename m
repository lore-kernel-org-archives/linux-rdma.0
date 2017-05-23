From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Protect the global dev_cntr_names and
 port_cntr_names
Date: Tue, 23 May 2017 21:39:30 +0200
Message-ID: <20170523193930.GB11862@kroah.com>
References: <20170523192000.23809.10271.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170523192000.23809.10271.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 23, 2017 at 03:20:00PM -0400, Mike Marciniszyn wrote:
> From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> commit d5483feda85a8f39ee2e940e279547c686aac30c upstream.
> 
> Protect the global dev_cntr_names and port_cntr_names with the global
> mutex as they are allocated and freed in a function called per device.
> Otherwise there is a danger of double free and memory leaks.
> 
> Cc: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.10

Thanks, but 4.10 is end-of-life.

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
