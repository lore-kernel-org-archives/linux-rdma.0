From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: T10 PI offloading seems to be broken in iser/isert in 4.5/4.6-rc
Date: Fri, 08 Apr 2016 19:36:14 -0700
Message-ID: <1460169374.5010.4.camel@haakon3.risingtidesystems.com>
References: <20160408221553.GA3716@infradead.org>
	 <1460159290.901.5.camel@haakon3.risingtidesystems.com>
	 <20160409001456.GA1752@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160409001456.GA1752@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: sagig@mellanox.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2016-04-08 at 17:14 -0700, Christoph Hellwig wrote:
> On Fri, Apr 08, 2016 at 04:48:10PM -0700, Nicholas A. Bellinger wrote:
> > It looks like the isert_set_dif_domain() assignments of
> > ib_sig_domain->sig.dif.* from dev->dev_attrib.block_size + friends is
> > being zeroed before making it into mlx5_ib_post_send() ->
> > IB_WR_REG_SIG_MR -> set_sig_umr_wr() -> set_sig_data_segment().
> 
> From my limited understanding that's not the case, even if the weird
> printk about the bad block size might suggest it.
> 
> I think what we have is the TARGET_PROT_DIN_INSERT /
> TARGET_PROT_DOUT_STRIP case (probably the first), and thus
> sig_attrs->mem.sig_type is set to IB_SIG_TYPE_NONE, but for some
> reason the prot pointer is set, which will lead to this misleading
> printk.

Ah, yes.  However, TARGET_PROT_DIN_INSERT / TARGET_PROT_DOUT_STRIP
will only be happening in sbc_set_prot_op_checks() if fabric_prot = true
for a backend that does not support PI.

Eg: fabric_prot is for the special case where the fabric supports PI,
but the backend does not, and the normal feature bits a device would
expose for PI are emulated based upon the fabric protection features.

Since your backend does support PI, cmd->prot_op should always be
TARGET_PROT_*_PASS regardless.

The other thing to check is that isert_get_sup_prot_ops() is returning
TARGET_PROT_ALL when tpg->tpg_attrib.t10_pi = true.

> 
> Does anyone know a recent working version of T10 PI in isert?  There
> aren't any recent-ish changes that look related.

Sagi..?
