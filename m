From: "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Subject: RE: [PATCH for-rc 5/7] IB/hfi1: Close race condition on user
 context disable and close
Date: Tue, 22 Jan 2019 16:24:11 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E8663BE655904@FMSMSX108.amr.corp.intel.com>
References: <20190117204148.30826.53799.stgit@scvm10.sc.intel.com>
 <20190122155611.B55A0217F9@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190122155611.B55A0217F9@mail.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This patch needs to be redone.

Please drop.

Thanks,

Mike

>-----Original Message-----
>From: Sasha Levin [mailto:sashal@kernel.org]
>Sent: Tuesday, January 22, 2019 10:56 AM
>To: Sasha Levin <sashal@kernel.org>; Dalessandro, Dennis
><dennis.dalessandro@intel.com>; Ruhl, Michael J
><michael.j.ruhl@intel.com>; jgg@ziepe.ca; dledford@redhat.com
>Cc: linux-rdma@vger.kernel.org; stable@vger.kernel.org
>Subject: Re: [PATCH for-rc 5/7] IB/hfi1: Close race condition on user context
>disable and close
>
>Hi,
>
>[This is an automated email]
>
>This commit has been processed because it contains a "Fixes:" tag,
>fixing commit: f683c80ca68e IB/hfi1: Resolve kernel panics by reference
>counting receive contexts.
>
>The bot has tested the following trees: v4.20.3, v4.19.16, v4.14.94.
>
>v4.20.3: Build OK!
>v4.19.16: Build OK!
>v4.14.94: Failed to apply! Possible dependencies:
>    071e4fec8e4d ("IB/hfi1: Reorg ctxtdata and rightsize fields")
>    1b311f8931cf ("IB/hfi1: Add tx_opcode_stats like the opcode_stats")
>    40442b30aad0 ("IB/hfi1: Move rhf_offset from devdata to ctxtdata")
>    b0ba3c18d6bf ("IB/hfi1: Move normal functions from hfi1_devdata to const
>array")
>    c8314811f9b2 ("IB/hfi1: Cleanup of exp_rcv")
>    ed71e86a8d66 ("IB/hfi1: Rename exp_lock to exp_mutex")
>
>
>How should we proceed with this patch?
>
>--
>Thanks,
>Sasha
