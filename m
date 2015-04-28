From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v6 01/26] IB/Verbs: Implement new callback
 query_transport()
Date: Tue, 28 Apr 2015 20:25:56 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC8572@ORSMSX109.amr.corp.intel.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
 <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com>
 <DB4PR05MB086367DF92CEE1977D8EB0AEB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
 <553DE799.5050608@profitbricks.com>
 <20150427215229.GD5347@phlsvsds.ph.intel.com> <553ED159.2090006@talpey.com>
 <1430181360.44548.35.camel@redhat.com> <553EDA01.9040708@talpey.com>
 <1430184275.44548.44.camel@redhat.com> <553EE718.1030502@talpey.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC819C@ORSMSX109.amr.corp.intel.com>
 <C8AE8850-C411-4805-95C2-6884669D92CF@cisco.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC8538@ORSMSX109.amr.corp.intel.com>
 <B21373C3-87EB-4D13-95B2-7D5FC39AEEEB@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B21373C3-87EB-4D13-95B2-7D5FC39AEEEB-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> For the UDP port used by the usNIC QP, the usnic_verbs kernel driver
> requires user space to pass a file descriptor of a regular UDP socket down
> at create_qp time.  The reference count on this socket is incremented to
> make sure that the socket can't disappear out from under us.  Then an RX
> filter is installed in the NIC which matches UDP/IP/Ethernet packets that
> are destined for the UDP port to which the given socket is already bound.
> So there is a real UDP socket to make most of the usual things happen in
> the net stack, but the raw UDP/IP/Ethernet packets get delivered directly
> to the user space queues by the NIC.  E.g., "netstat" and "lsof" show you
> proper addressing information, though obviously any information related to
> data-path statistics will not be accurate.  At teardown we just reverse
> the steps.
> 
> However, I'm not sure if that's the sort of information you were looking
> for.

This is more part of the RoCEv2 discussion than this thread.  But, yes, this is what I was looking for.  Conceptually, this is loosely similar to the port mapper functionality in iWarp, with a direct port mapping. Thanks.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
