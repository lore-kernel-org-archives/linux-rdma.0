From: Kenneth Lee <liguozhu@hisilicon.com>
Subject: Re: [PATCH v2] ib umem: bugfix: mixed put_pid()s in ib_umem_get()
Date: Fri, 30 Dec 2016 12:50:11 +0800
Message-ID: <20161230045011.GA79815@Turing-Arch-b>
References: <1483000048-183875-1-git-send-email-liguozhu@hisilicon.com>
 <20161229081756.GI26885@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161229081756.GI26885@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, robin.murphy@arm.com, jroedel@suse.de, egtvedt@samfundet.no, vgupta@synopsys.com, dave.hansen@linux.intel.com, lstoakes@gmail.com, krzk@kernel.org, sebott@linux.vnet.ibm.com, markb@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi, Leon,

1. I do change the title except for the version number itself:) But my English
is quite bad, maybe the title is still quite stupid. I can update it according
to your advice.

2. I catched the bug by reading the final code, not by bisect-ing the old
commit. Do you means I should find out which commit introducing the bug? It will
not be easily to say which it is because it is a "missing bug", rather than a
"introduced bug". Indicate the commit may not help to remove a patch/commit from
the stable tree.

Could you please give more suggestion? Thanks.

On Thu, Dec 29, 2016 at 10:17:56AM +0200, Leon Romanovsky wrote:
> Date: Thu, 29 Dec 2016 10:17:56 +0200
> From: Leon Romanovsky <leon@kernel.org>
> To: Kenneth Lee <liguozhu@hisilicon.com>
> CC: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
>  robin.murphy@arm.com, jroedel@suse.de, egtvedt@samfundet.no,
>  vgupta@synopsys.com, dave.hansen@linux.intel.com, lstoakes@gmail.com,
>  krzk@kernel.org, sebott@linux.vnet.ibm.com, markb@mellanox.com,
>  linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] ib umem: bugfix: mixed put_pid()s in ib_umem_get()
> User-Agent: Mutt/1.7.2 (2016-11-26)
> Message-ID: <20161229081756.GI26885@mtr-leonro.local>
> 
> On Thu, Dec 29, 2016 at 04:27:28PM +0800, Kenneth Lee wrote:
> > There are two bugfixes in this patch:
> >
> > 1. When the execution go to the ib_umem_odp_get() path, pid should be put
> >    back.
> > 2. When the memory allocation fail, the pid also should be put back before
> >    exit.
> >
> > Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
> > Reviewed-by: Haggai Eran <haggaie@mellanox.com>
> > ---
> > Change from v1 to v2:
> >   Correcting the patch title and description
> 
> I don't see any changes except version in the title.
> What about anything like this?
> [PATCH v3] IB/umem: Release pid in error and ODP flows
> 
> And Fixes line please, it will help to forward it to stable trees.
> 
> Thanks



-- 
			-Kenneth(Hisilicon)
