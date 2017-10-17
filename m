From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 08/12] i40iw: Reinitialize IEQ on MTU change
Date: Tue, 17 Oct 2017 10:55:22 -0500
Message-ID: <20171017155522.GA40680@ssaleem-MOBL4.amr.corp.intel.com>
References: <20171016204605.37512-1-shiraz.saleem@intel.com>
 <20171016204605.37512-9-shiraz.saleem@intel.com>
 <CY1PR0701MB20123ECBE7D8235BD2F9FD8D884C0@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CY1PR0701MB20123ECBE7D8235BD2F9FD8D884C0-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 17, 2017 at 09:15:07AM +0000, Kalderon, Michal wrote:
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Shiraz Saleem
> > 
> > On a netdev MTU change event, the iWARP
> > Exception Queue (IEQ) buffers may not be sized properly to handle the new
> > MTU.
> > 
> > Reinitialize the IEQ with new MTU size on MTU change event.
> > 
> > Also, add define for the max ethernet frame size field in IEQ QP context
> > instead of the snd_mss define which is for iWARP QPs' MSS field.
> 
> How do you handle any open iWARP connections on mtu change? 

MTU change on active QPs is not supported. These QPs will continue to run on old MTU
and are not explicitly torn down. New QPs are created with the new value.

Shiraz
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
