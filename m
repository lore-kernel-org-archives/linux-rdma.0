From: Christoph Hellwig <hch@infradead.org>
Subject: Re: T10 PI offloading seems to be broken in iser/isert in 4.5/4.6-rc
Date: Fri, 8 Apr 2016 21:58:46 -0700
Message-ID: <20160409045846.GA9269@infradead.org>
References: <20160408221553.GA3716@infradead.org>
 <1460159290.901.5.camel@haakon3.risingtidesystems.com>
 <20160409001456.GA1752@infradead.org>
 <1460169374.5010.4.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460169374.5010.4.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: sagig@mellanox.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 08, 2016 at 07:36:14PM -0700, Nicholas A. Bellinger wrote:
> Ah, yes.  However, TARGET_PROT_DIN_INSERT / TARGET_PROT_DOUT_STRIP
> will only be happening in sbc_set_prot_op_checks() if fabric_prot = true
> for a backend that does not support PI.
> 
> Eg: fabric_prot is for the special case where the fabric supports PI,
> but the backend does not, and the normal feature bits a device would
> expose for PI are emulated based upon the fabric protection features.
> 
> Since your backend does support PI, cmd->prot_op should always be
> TARGET_PROT_*_PASS regardless.
> 
> The other thing to check is that isert_get_sup_prot_ops() is returning
> TARGET_PROT_ALL when tpg->tpg_attrib.t10_pi = true.

Ok, it turns out this problem was a second LUN that doesn't support
PI.  So the reported bug is for a this fabrics_prot case, the scsi_debug
LUN was actually doing fine.

The root cause seems to be that transport_generic_new_cmd allocates
a prot_sg for all protection cases, which causes isert_reg_sig_mr
to assign a value to sig_wr.prot even for the strip/insert case,
which will then cause mlx5 to blow up.  But even when fixing that
I run into data compare errors, so there's defintively something deeper
hiding here.
