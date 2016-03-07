From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 04/10] IB/core: Support accessing SA in
 virtualized environment
Date: Tue, 8 Mar 2016 00:29:08 +0200
Message-ID: <20160307222908.GC33629@x-vnc01.mtx.labs.mlnx>
References: <1457384940-11951-1-git-send-email-eli@mellanox.com>
 <1457384940-11951-5-git-send-email-eli@mellanox.com>
 <20160307220434.GB6706@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160307220434.GB6706-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, eitan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 07, 2016 at 03:04:34PM -0700, Jason Gunthorpe wrote:
> On Mon, Mar 07, 2016 at 11:08:54PM +0200, Eli Cohen wrote:
> 
> > +enum {
> > +	IB_SA_WELL_KNOWN_GUID	= 2,
> > +};
> 
> Where did this come from?
It comes from the virtualization annex which can be found in the ibta
web site:
SM GID - A well-known GID that is associated with the SM, comprising
the concatenation of the Subnet prefix and the GUID 0x2. The SM GID is
never present in any GID Table. If SubnetPrefix is modified by the SM
the SM GID is updated implicitly.

> 
> It is wrong to have a EUI-64 like this that has a 0 OUI.
> 
> It is wrong to have a 'well known GUID' that is by definition not
> universal without setting the local bit (IBA spec even says this)
> 
> The well known guid should still conform to IEEE rules for creating
> EUI-64s.
> 
> Note, that the IBA is a little confused because it tries to follow
> IPv6 rules in some places not realizing that IPv6 uses an EUI-64 with
> the U/L bit inverted.
> 
> IMHO, new constants should strictly follow the IEEE EUI-64 rules and
> not try and confuse matters futher. The unused, incorrect, IBA
> definition of ::1 should be ignored.
> 

I will let Eitan and Liran comment on this.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
