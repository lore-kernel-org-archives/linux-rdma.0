From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v5 1/1] ibacm: Add support for pathrecord query through
 netlink
Date: Thu, 11 Jun 2015 20:16:41 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1109BDCF@CRSMSX101.amr.corp.intel.com>
References: <1434042265-5066-1-git-send-email-kaike.wan@intel.com>
 <20150611175940.GD20142@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611175940.GD20142-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Thu, Jun 11, 2015 at 01:04:25PM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > +static int acm_nl_parse_path_attr(struct nlattr *attr,
> > +				   struct acm_ep_addr_data *data)
> 
> > +	switch (attr->nla_type & NLA_TYPE_MASK) {
> > +	default:
> > +		acm_log(1, "WARN: unknown attr %x\n", attr->nla_type);
> > +		ret = -1;
> > +		break;
> 
> I would like to see a mandatory/optional scheme here.
> 
> For instance if we add SL it would be mandatory, but policy information like
> requesting net_device would be optional.

Why would SL be mandatory?

Ira
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
