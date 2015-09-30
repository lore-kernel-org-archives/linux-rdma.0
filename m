From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RFC] IB/mad: remove obsolete snoop interface
Date: Wed, 30 Sep 2015 19:31:17 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1CBA320B@CRSMSX101.amr.corp.intel.com>
References: <1443592864-32019-1-git-send-email-ira.weiny@intel.com>
 <560BDB97.8010908@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E1CBA2FA4@CRSMSX101.amr.corp.intel.com>
 <560C31E4.2080007@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <560C31E4.2080007-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> > I have a series of about 5 patches which implement tracing in the MAD
> > stack which I was working through and was going to submit
> 
> Does your MAD stack tracing include the dumping and decode of sent and
> received MADs ?
> 

Yes with a bit more details in some places and probably less in others.  It also traces MADs throughout the stack as well.  So there is some indication of where they are in the stack umad vs mad for example.

I'll post them later today for RFC.  The most recent work I did on them involved a panic (which I fixed).  But this is the main reason I have not submitted this series.  (I wanted to get more testing on it before submission.)

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
