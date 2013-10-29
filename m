From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC v1 01/10] IB/core: Introduce protected memory regions
Date: Tue, 29 Oct 2013 22:20:08 +0200
Message-ID: <CAJZOPZJB+64V-iXTVE=93u31SBu3DG-3bVPoJx10tr77wfC0nA@mail.gmail.com>
References: <1382970376-13776-1-git-send-email-sagig@mellanox.com>
	<1382970376-13776-2-git-send-email-sagig@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237388CF1CDD@ORSMSX109.amr.corp.intel.com>
	<526F62DA.4050304@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237388CF25C5@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CF25C5-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 29, 2013 at 9:34 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> Hi Sean, anything else from your side re the IB core patches and this
>> series in general?

> Do we have a user of these changes?

Oh sure, we didn't do that just for the fun of it... Sagi is working
to enhance the upstream SCSI target iser driver to make use of the new
APIs, and later will do the same for the initiator driver. We have
patches to krping that examplify how the new functionality can be
used, will post them tomorrow.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
