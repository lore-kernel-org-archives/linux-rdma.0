From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibv_post_send/recv kernel path optimizations
Date: Fri, 21 Jan 2011 07:49:48 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25C1D51C31@orsmsx501.amr.corp.intel.com>
References: <20101013091312.GB6060@bicker> <20101123071025.GI1522@bicker>
	<adahbf6gytv.fsf@cisco.com>	<20101124221845.GH2369@obsidianresearch.com>
	<adad3pugi90.fsf@cisco.com>	<20101125041337.GA11049@obsidianresearch.com>
	<4CEE7A22.2040706@voltaire.com>
	<BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>
	<4CF60343.7050602@voltaire.com>
	<BE2BFE91933D1B4089447C644860408066ABCF66@irsmsx503.ger.corp.intel.com>
	<20101214181735.GA2506@obsidianresearch.com>	<4D1888CB.2010101@Voltaire.com>
	<BE2BFE91933D1B4089447C644860408066C547E0@irsmsx503.ger.corp.intel.com>
	<ada4o9nfc6e.fsf@cisco.com>
	<BE2BFE91933D1B4089447C644860408066DDDF31@irsmsx503.ger.corp.intel.com>
 <adawrmc7av2.fsf@cisco.com>
 <BE2BFE91933D1B4089447C644860408066F95285@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408066F95285-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
> +	if (!qp)
> +		goto out_raw_qp;
> +
> +	if (qp->qp_type == IB_QPT_RAW_ETH) {
> +		resp.bad_wr = 0;
> +		ret = qp->device->post_send(qp, NULL, NULL);

This looks odd to me and can definitely confuse someone reading the code.  It adds assumptions to uverbs about the underlying driver implementation and ties that to the QP type.  I don't know if it makes more sense to key off something in the cmd or define some other property of the QP, but the NULL parameters into post_send are non-intuitive.
 
> +		if (ret)
> +			resp.bad_wr = cmd.wr_count;

Is this always the case?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
