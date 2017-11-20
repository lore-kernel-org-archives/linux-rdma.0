From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 3/6] IB/SA: Check dlid before SA agent queries
 for ClassPortInfo
Date: Mon, 20 Nov 2017 12:16:48 -0700
Message-ID: <20171120191648.GI29075@ziepe.ca>
References: <20171114122859.10579.79788.stgit@scvm10.sc.intel.com>
 <20171114123428.10579.94740.stgit@scvm10.sc.intel.com>
 <9f775a16-08b4-033b-7003-93a327bf68f8@dev.mellanox.co.il>
 <8C8FAED8CED26F4C8245E7FC6A20F9062BA45FA1@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8C8FAED8CED26F4C8245E7FC6A20F9062BA45FA1-8oqHQFITsIGkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dhanalakota, Venkata S" <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 20, 2017 at 07:11:09PM +0000, Dhanalakota, Venkata S wrote:
> Hi Hal,
> 
> The patch intends to only check if smlid is assigned or not. It does
> not intend to check if smlid is a valid lid or not. Validity of lid
> is taken care by the individual drivers, during create_ah().

I think that is Hal's point - there are multiple ways to say 'not
assigned' for SMLID, including == 0 and == 0xFFFF

It is best to use !valid as a test for an unassigned SM lid.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
