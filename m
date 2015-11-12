From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/mad: In validate_mad, validate CM method and attribute
Date: Thu, 12 Nov 2015 15:13:00 -0700
Message-ID: <20151112221300.GA12250@obsidianresearch.com>
References: <56447CA2.1070802@dev.mellanox.co.il>
 <20151112181339.GA16488@phlsvsds.ph.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A9BACD7D@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A9BACD7D-8oqHQFITsIHTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 12, 2015 at 08:30:55PM +0000, Hefty, Sean wrote:
> > > +		/* CM attributes other than ClassPortInfo only use Send method
> > */
> > > +		if (mad_hdr->mgmt_class == IB_MGMT_CLASS_CM) {
> > > +			if (mad_hdr->attr_id != IB_MGMT_CLASSPORTINFO_ATTR_ID) {
> > > +				if (mad_hdr->method != IB_MGMT_METHOD_SEND)
> > > +					goto out;
> > > +			} else if (mad_hdr->method != IB_MGMT_METHOD_GET_RESP)
> > > +				goto out;
> > > +		}
> > 
> > Doesn't this invalidate a CM Get(ClassPortInfo) mad?
> 
> I believe this does.  I think you could remove the else if clause
> and let the received MAD get passed to the CM.  It would be dropped
> there as unsupported.  The net result is likely the same.

IIRC responding to Get(CPI) is mandatory?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
