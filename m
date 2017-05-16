From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 1/4] IB/CM: Convert OPA Path record to IB
 during CM request
Date: Tue, 16 May 2017 21:20:20 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB11E231@ORSMSX109.amr.corp.intel.com>
References: <1494458598-6911-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1494458598-6911-2-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB11E1D7@ORSMSX109.amr.corp.intel.com>
 <9fa0b429-364f-0f49-fc2c-390d606a6ff6@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9fa0b429-364f-0f49-fc2c-390d606a6ff6-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hiatt, Don" <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chandramouli, Dasaratharaman" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> OPA path records need to be converted to IB path records
> >> during a connection request. If the slid/dlid fields in the
> >> OPA path records are extended, the resulting converted IB
> >> path records will have the corresponding GIDs populated as
> >> OPA GIDs
> >
> > I'm getting lost.  Why is a conversion from OPA PRs to IB PRs
> needed?
> >
> 
> If the OPA path record contained extended LIDS then the SGID/DGID
> fields
> of the IB path record would contain OPA GIDS.

But *why* is the conversion necessary?  The CM doesn't send/receive PRs.  And the interface to the CM should be able to handle either. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
