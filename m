From: Richard Graham <richardg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: ibv_send_wr extension
Date: Sat, 11 May 2013 01:17:31 +0000
Message-ID: <3D8F945A4E59E644AE9205E5CD3708E51892E3A1@MTIDAG02.mtl.com>
References: <3D8F945A4E59E644AE9205E5CD3708E51892DDC3@MTIDAG02.mtl.com>
 <3D8F945A4E59E644AE9205E5CD3708E51892DE4B@MTIDAG02.mtl.com>
 <1828884A29C6694DAF28B7E6B8A823736FD22FE0@ORSMSX109.amr.corp.intel.com>
 <3D8F945A4E59E644AE9205E5CD3708E51892E2D6@MTIDAG02.mtl.com>
 <1828884A29C6694DAF28B7E6B8A823736FD22FFB@ORSMSX109.amr.corp.intel.com>
 <3D8F945A4E59E644AE9205E5CD3708E51892E303@MTIDAG02.mtl.com>
 <1828884A29C6694DAF28B7E6B8A823736FD23023@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD23023-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> > So are you are OK with this option ?  There were 2 options, and this 
> > one is our preference.
> > 
> > Remove the pointer to the ibv_send_wr_ext pointer from the wr union  
> > in ibv_send_wr, and put the ibv_send_wr (less the duplicated data
> >  structures) after the union, with the usual comp_mask flag to 
> > indicate what is supported.
> 
> As long as it's compatible, yes.

Sounds good - thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
