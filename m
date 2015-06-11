From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v5 1/1] ibacm: Add support for pathrecord query through
 netlink
Date: Thu, 11 Jun 2015 20:55:52 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1109BE11@CRSMSX101.amr.corp.intel.com>
References: <1434042265-5066-1-git-send-email-kaike.wan@intel.com>
 <20150611175940.GD20142@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E1109BDCF@CRSMSX101.amr.corp.intel.com>
 <20150611202200.GA25813@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611202200.GA25813-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Thu, Jun 11, 2015 at 08:16:41PM +0000, Weiny, Ira wrote:
> > > For instance if we add SL it would be mandatory, but policy
> > > information like requesting net_device would be optional.
> >
> > Why would SL be mandatory?
> 
> If the kernel asks for a specific SL then user space must respect that and return
> a path with that exact SL.
> 
> If userspace does not know how to do that, then it must not answer the query. It
> cannot ignore the SL requirement and return a random SL.

Oh, right, I misunderstood.  I thought that you were saying that SL would be mandatory as a netlink attribute.

> 
> Hypothetically, assuming we add SL..

Right...  ;-)

Ira
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
