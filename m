From: Christoph Hellwig <hch@infradead.org>
Subject: Re: T10 PI offloading seems to be broken in iser/isert in 4.5/4.6-rc
Date: Fri, 8 Apr 2016 17:14:56 -0700
Message-ID: <20160409001456.GA1752@infradead.org>
References: <20160408221553.GA3716@infradead.org>
 <1460159290.901.5.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460159290.901.5.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, sagig@mellanox.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 08, 2016 at 04:48:10PM -0700, Nicholas A. Bellinger wrote:
> It looks like the isert_set_dif_domain() assignments of
> ib_sig_domain->sig.dif.* from dev->dev_attrib.block_size + friends is
> being zeroed before making it into mlx5_ib_post_send() ->
> IB_WR_REG_SIG_MR -> set_sig_umr_wr() -> set_sig_data_segment().

>From my limited understanding that's not the case, even if the weird
printk about the bad block size might suggest it.

I think what we have is the TARGET_PROT_DIN_INSERT /
TARGET_PROT_DOUT_STRIP case (probably the first), and thus
sig_attrs->mem.sig_type is set to IB_SIG_TYPE_NONE, but for some
reason the prot pointer is set, which will lead to this misleading
printk.

Does anyone know a recent working version of T10 PI in isert?  There
aren't any recent-ish changes that look related.
