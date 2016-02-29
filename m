From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: SRPt oops with 4.5-rc3-ish
Date: Sun, 28 Feb 2016 16:37:40 -0800
Message-ID: <56D392D4.2000105@sandisk.com>
References: <56C0A6C3.3010903@redhat.com>
 <1456630639.19657.47.camel@haakon3.risingtidesystems.com>
 <1456647963.19657.135.camel@haakon3.risingtidesystems.com>
 <56D31CC9.7000609@sandisk.com>
 <1456692183.19657.151.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456692183.19657.151.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On 02/28/16 12:43, Nicholas A. Bellinger wrote:
> Anyways, I'll sit down this week and figure out what's going on with
> Doug's active I/O shutdown regression.

The crash occurs in the core_tpg_del_initiator_node_acl() function
and a call to that function has been added recently in
target_fabric_nacl_base_release(). I think it was added through the
following patch:

commit c7d6a803926bae9bbf4510a18fc8dd8957cc0e01
Date:   Mon Apr 13 19:51:14 2015 +0200

    target: refactor init/drop_nodeacl methods
    
    By always allocating and adding, respectively removing and freeing
    the se_node_acl structure in core code we can remove tons of repeated
    code in the init_nodeacl and drop_nodeacl routines.  Additionally
    this now respects the get_default_queue_depth method in this code
    path as well.
    
Bart.
