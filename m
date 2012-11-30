From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Dapltest test error DAT_CONN_QUAL_IN_USE
Date: Fri, 30 Nov 2012 20:16:59 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F94822EE15@ORSMSX101.amr.corp.intel.com>
References: <BE1D1D812551174182F280D7A4AEC90B357C04@nice.asicdesigners.com>
 <54347E5A035A054EAE9D05927FB467F94822CCC0@ORSMSX101.amr.corp.intel.com>
 <50B3C8ED.9080803@opengridcomputing.com> <50B76449.9010000@chelsio.com>
 <54347E5A035A054EAE9D05927FB467F94822E9F8@ORSMSX101.amr.corp.intel.com>
 <50B8CCD0.6030407@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50B8CCD0.6030407-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kumar A S <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Abhishek Agrawal <abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Divy Le Ray <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

http://openfabrics.org/bugzilla/index.cgi


> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Vipul Pandya
> Sent: Friday, November 30, 2012 7:12 AM
> To: Davis, Arlin R
> Cc: Steve Wise; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Kumar A S; Abhishek
> Agrawal; Divy Le Ray
> Subject: Re: Dapltest test error DAT_CONN_QUAL_IN_USE
> 
> Arlin,
> 
> Can you please refer to which bugzilla I should log a bug? Can you
> please provide me the url?
> 
> Thanks,
> Vipul
> 
> On 30-11-2012 05:21, Davis, Arlin R wrote:
> > Vipul,
> >
> > Can you submit a bug in bugzilla for tracking? I will try to get to
> > this next couple of days.
> >
> > -arlin
> >
> >> -----Original Message-----
> >> From: Vipul Pandya [mailto:vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org]
> >> Sent: Thursday, November 29, 2012 5:34 AM
> >> To: Davis, Arlin R
> >> Cc: Steve Wise; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Kumar A S; Abhishek
> >> Agrawal; Divy Le Ray
> >> Subject: Re: Dapltest test error DAT_CONN_QUAL_IN_USE
> >>
> >> Hi Arlin,
> >>
> >> This issue is happening because there is a port collision between
> >> dapltest server port space and host TCP stack. The port collision
> >> happens because rdma_bind_addr is getting called from the two
> >> different places with different port arguments from dapltest.
> >> rdma_bind_addr is getting called from the following two places:
> >>
> >> 1. Once it is getting called from dapls_ib_setup_conn_listener
> >> function with starting port as 45278. Based on number of threads and
> >> eps, in subsequent call of dapls_ib_setup_conn_listener this port
> >> number will keep getting incremented.
> >>
> >> 2. 2nd time it is getting called from dapls_ib_qp_alloc function
> with
> >> port number as always 0. Now, when rdma_bind_addr gets called with
> >> port number 0 it will allocate any free random port number.
> >>
> >> Then when dapls_ib_setup_conn_listener calls the rdma_bind_addr with
> >> fix port number which is already allocate via dapls_ib_qp_alloc
> >> function rdma_bind_addr will return EADDRINUSE error, which in turn
> >> will result in DAT_CONN_QUAL_IN_USE error.
> >>
> >> I think solution here would be to call rdma_bind_addr from both the
> >> location passing port number from the same port range.
> >>
> >> Please let me know your thoughts on this.
> >>
> >> Our testing has been blocked because of this issue. We would like to
> >> get this fixed. Please let us know if we need to log a bug anywhere
> >> for this.
> >>
> >> Thanks,
> >> Vipul
> >>
> >> On 27-11-2012 01:24, Steve Wise wrote:
> >>> Perhaps the port is in use by the host TCP stack?
> >>>
> >>>
> >>> On 11/26/2012 1:30 PM, Davis, Arlin R wrote:
> >>>> dapltest server will start with port 45278 and increase by client
> >> thread count during each new client connection. If you never restart
> >> the server it will continue to increase the listen port based on new
> >> clients connecting. If you restart dapltest it will restart back at
> >> port 45278. I am not familiar with iWarp CM but the error is coming
> >> from rdma_bind_addr (EADDRINUSE|EBUSY|EADDRNOTAVAIL). I will have to
> >> defer to Steve for this error.
> >>>>
> >>>> -arlin
> >>>>
> >>>>
> >>>>> -----Original Message-----
> >>>>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> >>>>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Vipul Pandya
> >>>>> Sent: Friday, November 23, 2012 5:54 AM
> >>>>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>>>> Cc: Kumar A S; Steve Wise; Abhishek Agrawal; Davis, Arlin R; Divy
> >> Le
> >>>>> Ray
> >>>>> Subject: Dapltest test error DAT_CONN_QUAL_IN_USE
> >>>>>
> >>>>> Hi All,
> >>>>>
> >>>>> I was running dapltest between my client and server machines with
> >>>>> OFED- 3.5. While running the test it dapltest server throws an
> >> error
> >>>>> DAT_CONN_QUAL_IN_USE if I increase number of threads and
> endpoints.
> >>>>>
> >>>>> Dapltest server:
> >>>>> ---------------
> >>>>> dapltest -T S -D chelsio1
> >>>>>
> >>>>> Dapltest client:
> >>>>> ---------------
> >>>>> dapltest -T T -s 102.1.1.2 -D chelsio1 -R BE -i 1 -t 16 -w 8
> >>>>> server SR
> >>>>> 8192 4 client SR 8192 4
> >>>>>
> >>>>>
> >>>>> Once I run the above test i get the following error on server
> side
> >>>>> and client side stalls.
> >>>>>
> >>>>> $# dapltest -T S -D chelsio1
> >>>>> Dapltest: Service Point Ready - chelsio1
> >>>>> Test[b13f]: dat_psp_create #6 error: DAT_CONN_QUAL_IN_USE
> >>>>> Test[b13f]: Warning: dat_ep_disconnect (abrupt) #0 error
> >>>>> DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
> >>>>> Test[b13f]: dat_evd_free (creq) error: DAT_INVALID_STATE
> >>>>> DAT_INVALID_STATE_EVD_IN_USE
> >>>>> Test[b13f]: Warning: dat_ep_disconnect (abrupt) #1 error
> >>>>> DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
> >>>>> Test[b13f]: dat_evd_free (creq) error: DAT_INVALID_STATE
> >>>>> DAT_INVALID_STATE_EVD_IN_USE
> >>>>> Test[b13f]: Warning: dat_ep_disconnect (abrupt) #2 error
> >>>>> DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
> >>>>> Test[b13f]: dat_evd_free (creq) error: DAT_INVALID_STATE
> >>>>> DAT_INVALID_STATE_EVD_IN_USE
> >>>>> Test[b13f]: Warning: dat_ep_disconnect (abrupt) #3 error
> >>>>> DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
> >>>>> Test[b13f]: dat_evd_free (creq) error: DAT_INVALID_STATE
> >>>>> DAT_INVALID_STATE_EVD_IN_USE
> >>>>> Test[b13f]: Warning: dat_ep_disconnect (abrupt) #4 error
> >>>>> DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
> >>>>> Test[b13f]: dat_evd_free (creq) error: DAT_INVALID_STATE
> >>>>> DAT_INVALID_STATE_EVD_IN_USE
> >>>>> Test[b13f]: Warning: dat_ep_disconnect (abrupt) #5 error
> >>>>> DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
> >>>>> Test[b13f]: dat_evd_free (creq) error: DAT_INVALID_STATE
> >>>>> DAT_INVALID_STATE_EVD_IN_USE
> >>>>> Test[b13f]: Warning: dat_ep_disconnect (abrupt) #6 error
> >>>>> DAT_INVALID_STATE DAT_INVALID_STATE_EP_UNCONNECTED
> >>>>>
> >>>>> Following link says DAT_CONN_QUAL_IN_USE error can come if
> rdma_cm
> >>>>> returns an error due to bind failure.
> >>>>> http://www.mail-archive.com/linux-
> >> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01297.html
> >>>>>
> >>>>> rdma_cm from OFED-3.5 does not provide module parameter
> >>>>> 'unify_tcp_port_space'. So, just to narrow down I installed OFED-
> >>>>> 1.5.4.1 and ran the same test with unify_tcp_port_space=1.
> However
> >>>>> with that also I was able to reproduced the same issue.
> >>>>>
> >>>>> Please note that if I decrease the numbers of endpoints to 4 then
> >>>>> test works fine. i.e. If I give '-w 4' instead of '-w 8' in
> >>>>> command line then test runs fine.
> >>>>>
> >>>>> I am using dapltest version 2.0.36 which comes from OFED-3.5.
> >>>>>
> >>>>> Can anyone give any pointers on this?
> >>>>>
> >>>>>
> >>>>> Thanks,
> >>>>> Vipul
> >>>>> --
> >>>>> To unsubscribe from this list: send the line "unsubscribe linux-
> >> rdma"
> >>>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> >> majordomo
> >>>>> info at  http://vger.kernel.org/majordomo-info.html
> >>>> --
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-
> >> rdma"
> >>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> >>>> majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
