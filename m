From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: SRPt oops with 4.5-rc3-ish
Date: Mon, 29 Feb 2016 22:49:58 -0800
Message-ID: <1456814998.19657.223.camel@haakon3.risingtidesystems.com>
References: <56C0A6C3.3010903@redhat.com>
	 <1456630639.19657.47.camel@haakon3.risingtidesystems.com>
	 <1456647963.19657.135.camel@haakon3.risingtidesystems.com>
	 <56D31CC9.7000609@sandisk.com>
	 <1456692183.19657.151.camel@haakon3.risingtidesystems.com>
	 <56D392D4.2000105@sandisk.com> <20160229060504.GA6024@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160229060504.GA6024@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2016-02-29 at 07:05 +0100, Christoph Hellwig wrote:
> On Sun, Feb 28, 2016 at 04:37:40PM -0800, Bart Van Assche wrote:
> > On 02/28/16 12:43, Nicholas A. Bellinger wrote:
> > > Anyways, I'll sit down this week and figure out what's going on with
> > > Doug's active I/O shutdown regression.
> > 
> > The crash occurs in the core_tpg_del_initiator_node_acl() function
> > and a call to that function has been added recently in
> > target_fabric_nacl_base_release(). I think it was added through the
> > following patch:
> 
> That patch just moved the call from the .fabric_drop_nodeacl instances
> (in the SRPT case srpt_drop_nodeacl) to the caller in
> target_fabric_nacl_base_release.

I've not re-produced with v4.5-rc, but IIRC pre-commit 59fae4de usage of
ib_create_cq() w/ srpt_compl_thread() -> kthread_stop(ch->thread) in
srpt_destroy_ch_ib() did play a role wrt IB CQ active I/O shutdown
completion in original code.

Btw, is original ib_create_cq() usage a incompatible with chain RDMA
READ/WRITE requests, or was that an extra improvement..?
