From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 01/13] IB/core: Add get FW version string to the core
Date: Wed, 15 Jun 2016 11:20:49 -0400
Message-ID: <20160615152048.GB8690@phlsvsds.ph.intel.com>
References: <1465971728-24104-1-git-send-email-ira.weiny@intel.com> <1465971728-24104-2-git-send-email-ira.weiny@intel.com> <20160615064008.GS5408@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160615064008.GS5408-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 15, 2016 at 09:40:08AM +0300, Leon Romanovsky wrote:
> On Wed, Jun 15, 2016 at 02:21:56AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

[snip]

> > 
> > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> > index 5c155fa91eec..760ef603a468 100644
> > --- a/drivers/infiniband/core/device.c
> > +++ b/drivers/infiniband/core/device.c
> > @@ -311,6 +311,15 @@ static int read_port_immutable(struct ib_device *device)
> >  	return 0;
> >  }
> >  
> > +void ib_get_device_fw_str(struct ib_device *dev, char *str, size_t str_len)
> > +{
> > +	if (dev->get_dev_fw_str)
> > +		dev->get_dev_fw_str(dev, str, str_len);
> > +	else
> > +		str[0] = '\0';
> 
> Interesting point, what is better for the caller to get as a version?
> You chose empty string, but it can be all Fs or all 0s.

The default here is that a device does not provide a firmware string.  In that
case the assumption is that there is no firmware.  Hence the empty string.  I
don't think that reporting 0's or F's are appropriate if a device does not have
firmware.

In the cases you speak of I would expect the device to supply the firmware
function and report all 0s or all Fs for whatever version that may represent.
(I'm assuming that would be some sort of debug or unreleased firmware...)

I could just as well done something like.

snprintf(str, str_len, "<none>");

Which may be more informative?  I just don't want to get too wrapped up in the
policy here.  I think this is best left to the driver/hw vendor.

Ira

> 
> > +}
> > +EXPORT_SYMBOL(ib_get_device_fw_str);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
