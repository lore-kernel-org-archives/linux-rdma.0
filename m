From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/13] IB/core: Add get FW version string to the core
Date: Mon, 13 Jun 2016 22:45:54 -0400
Message-ID: <20160614024552.GA25688@phlsvsds.ph.intel.com>
References: <1465509248-11324-1-git-send-email-ira.weiny@intel.com> <1465509248-11324-2-git-send-email-ira.weiny@intel.com> <20160609222919.GA13366@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160609222919.GA13366-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 09, 2016 at 04:29:19PM -0600, Jason Gunthorpe wrote:
> On Thu, Jun 09, 2016 at 05:53:56PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > +void ib_get_device_fw_str(struct ib_device *dev, char *str, size_t str_len)
> > +{
> > +	if (dev->get_dev_fw_str)
> > +		dev->get_dev_fw_str(dev, str, str_len);
> > +	else
> > +		snprintf(str, str_len, "%s", "");
> 
> That is the strangest way to write str[0] = 0;

I find it to be very explicit without any performance requirements.

How about?

str[0] = '\0';

> 
> >  void ib_dealloc_device(struct ib_device *device);
> >  
> > +void ib_get_device_fw_str(struct ib_device *device, char *, size_t);
> 
> It is not common in the kernel to drop the parameter names from the
> prototype, please don't add more.

Good catch sorry about that.

Fixed.

Ira

> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
