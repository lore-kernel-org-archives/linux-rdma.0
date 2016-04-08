From: Christoph Hellwig <hch@infradead.org>
Subject: T10 PI offloading seems to be broken in iser/isert in 4.5/4.6-rc
Date: Fri, 8 Apr 2016 15:15:53 -0700
Message-ID: <20160408221553.GA3716@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: sagig@mellanox.com
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

I've recently started looking into adding support for signature MRs
in the RDMA R/W API, but it seems like it's already broken upstream.

I suspect it's the target that's at fault, but I'm not sure.  I've
tested 4.5 and todays 4.6-rc tree on both the target and the client
side.

The setup is pretty simple: on the target I've loaded scsi_debug
with dif=1 and dix=1, and set I've set fabric_prot_type=1, t10_pi=1
and ImmediateData to No on the tpg, and then did a simple mkfs.ext4.

Just doing the login I get the following error on the target:

[  369.890182] Bad block size given: 0
[  369.894131] mlx5_0:mlx5_ib_post_send:3296:(pid 331): 
[  369.894228] isert: isert_reg_sig_mr: fast registration failed, ret:-22
[  369.901580] isert: isert_handle_prot_cmd: conn ffff880904d54000 failed to fast reg mr
[  369.906348] iSCSI/iqn.1993-08.org.debian:01:197dad5d1f17: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  369.910395] isert: isert_put_datain: Cmd: ffff880902b26b00 failed to prepare RDMA res

If I then do an actual I/O think go downhill quickly.
