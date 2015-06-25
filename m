From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH RFC 0/2] iSER support for iWARP
Date: Thu, 25 Jun 2015 12:01:34 -0500
Message-ID: <005201d0af68$9781a520$c684ef60$@opengridcomputing.com>
References: <20150625153754.13272.432.stgit@build.ogc.int> <558C332B.4040901@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <558C332B.4040901@mellanox.com>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Sagi Grimberg' <sagig@mellanox.com>, linux-rdma@vger.kernel.org
Cc: 'Or Gerlitz' <ogerlitz@mellanox.com>, 'Roi Dayan' <roid@mellanox.com>, 'target-devel' <target-devel@vger.kernel.org>, "'Nicholas A. Bellinger'" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-owner@vger.kernel.org] On Behalf Of Sagi Grimberg
> Sent: Thursday, June 25, 2015 11:58 AM
> To: Steve Wise; linux-rdma@vger.kernel.org
> Cc: Or Gerlitz; Roi Dayan; target-devel; Nicholas A. Bellinger
> Subject: Re: [PATCH RFC 0/2] iSER support for iWARP
> 
> On 6/25/2015 6:39 PM, Steve Wise wrote:
> > The following series implements support for iWARP transpors
> > in the iSER initiator and target.  This is based on
> > Doug's k.o/for-4.2 branch.
> >
> 
> Hi Steve,
> 
> Thanks for this set,
> 
> Can you please rebase for target-pending/master?
> 
> or at least submit on top of:
> iser-target: Fix possible use-after-free
> iser-target: release stale iser connections
> iser-target: Fix variable-length response error completion
> 
> 
> I just added code that touches the same areas in isert.
> 
> Thanks!

Sure.
