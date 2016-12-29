From: Kenneth Lee <liguozhu@hisilicon.com>
Subject: Re: [PATCH] ib umem: bug: put pid back before return from error path
Date: Thu, 29 Dec 2016 10:28:34 +0800
Message-ID: <20161229022834.GH46690@Turing-Arch-b>
References: <1482390692-147946-1-git-send-email-liguozhu@hisilicon.com>
 <e470fbab-a330-b9c4-f2b3-65fb45f24e0a@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e470fbab-a330-b9c4-f2b3-65fb45f24e0a@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Bloch <markb@mellanox.com>
Cc: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, robin.murphy@arm.com, jroedel@suse.de, egtvedt@samfundet.no, vgupta@synopsys.com, dave.hansen@linux.intel.com, lstoakes@gmail.com, krzk@kernel.org, sebott@linux.vnet.ibm.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi, 

Sorry for the delay (I'd got some problem in my procmailrc file, and miss this 
mail).

The new patch, with title "[PATCH] ib umem: bugfix: mixed put_pid()s in
ib_umem_get()", has been sent.

On Thu, Dec 22, 2016 at 10:00:57AM +0200, Mark Bloch wrote:
> Date: Thu, 22 Dec 2016 10:00:57 +0200
> From: Mark Bloch <markb@mellanox.com>
> To: Kenneth Lee <liguozhu@hisilicon.com>, dledford@redhat.com,
>  sean.hefty@intel.com, hal.rosenstock@gmail.com
> CC: robin.murphy@arm.com, jroedel@suse.de, egtvedt@samfundet.no,
>  vgupta@synopsys.com, dave.hansen@linux.intel.com, lstoakes@gmail.com,
>  krzk@kernel.org, sebott@linux.vnet.ibm.com, linux-rdma@vger.kernel.org,
>  linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] ib umem: bug: put pid back before return from error
>  path
> User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:45.0) Gecko/20100101
>  Thunderbird/45.5.1
> Message-ID: <e470fbab-a330-b9c4-f2b3-65fb45f24e0a@mellanox.com>
> 
> Hi,
> 
> You have two bugs here:
> 1) When using ODP, ib_umem_release() checks for umem->odp_data != NULL 
>    calls ib_umem_odp_release() and returns immediately without calling put_pid().
>    This one isn't in the error path so the title doesn't fit.
> 
> 2) In case the allocation failed, we return in -ENOMEM without calling put_pid().
> 
> Can you please resend this with proper fixes line and a better description of what is going on.
> 
> On 22/12/2016 09:11, Kenneth Lee wrote:
> > I catched this bug when reading the code. I'm sorry I have no hardware to test
> > it. But it is abviously a bug.
> > 
> > Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
> > ---
> >  drivers/infiniband/core/umem.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> > index 1e62a5f..4609b92 100644
> > --- a/drivers/infiniband/core/umem.c
> > +++ b/drivers/infiniband/core/umem.c
> > @@ -134,6 +134,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
> >  		 IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_MW_BIND));
> >  
> >  	if (access & IB_ACCESS_ON_DEMAND) {
> > +		put_pid(umem->pid);
> >  		ret = ib_umem_odp_get(context, umem);
> >  		if (ret) {
> >  			kfree(umem);
> > @@ -149,6 +150,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
> >  
> >  	page_list = (struct page **) __get_free_page(GFP_KERNEL);
> >  	if (!page_list) {
> > +		put_pid(umem->pid);
> >  		kfree(umem);
> >  		return ERR_PTR(-ENOMEM);
> >  	}
> > 
> 
> Mark.

-- 
			-Kenneth(Hisilicon)
