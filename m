From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 for-next 00/14] RDMA/bnxt_re: Bug fixes
Date: Tue, 13 Jun 2017 22:32:45 -0400
Message-ID: <1497407565.7171.249.camel@redhat.com>
References: <1495448144-18966-1-git-send-email-selvin.xavier@broadcom.com>
         <1497386691.7171.244.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497386691.7171.244.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-06-13 at 16:44 -0400, Doug Ledford wrote:
> On Mon, 2017-05-22 at 03:15 -0700, Selvin Xavier wrote:
> > 
> > The patch series has some bug fixes for bnxt_re driver.
> > This series includes implementation of some of the workarounds
> > required for the HW and FW and removes the FMR verb support from
> > the driver.
> > I have addressed all the review comments from Leon and Dennis in
> > this series.
> > 
> > Doug,
> >  Please review and apply these changes to your repository.
> 
> As we discussed off-list, I took the most important of these for -rc
> (but I have to say, you requested both 1/14 and 2/14 for -rc, and I
> took them, but they are *much* larger than I like to see in -rc
> patches...please try to keep -rc patches smaller in the future).
> 
> 1, 2, 4, 6, 10, 14 in -rc.  The rest being reviewed for for-next.

Patch 2/14 cause a build regression:

tree:   https://github.com/dledford/linux.git k.o/for-4.12-rc
head:   1e40a786493e7256cc9192165b431fba3fb2023b
commit: fabfb8786409d7be24ac84150b1fa025e181861d [29/36] RDMA/bnxt_re:
HW workarounds for handling specific conditions
config: xtensa-allmodconfig (attached as .config)
compiler: xtensa-linux-gcc (GCC) 4.9.0
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/s
bin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout fabfb8786409d7be24ac84150b1fa025e181861d
        # save the attached .config to linux build tree
        make.cross ARCH=xtensa 

All warnings (new ones prefixed by >>):

   drivers/infiniband/hw/bnxt_re/ib_verbs.c: In function
'bnxt_re_create_fence_wqe':
>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:470:17: warning: cast from
pointer to integer of different size [-Wpointer-to-int-cast]
     wqe->bind.va = (u64)fence->va;
                    ^
   drivers/infiniband/hw/bnxt_re/ib_verbs.c: In function
'bnxt_re_create_fence_mr':
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:578:28: warning: cast from
pointer to integer of different size [-Wpointer-to-int-cast]
     mr->qplib_mr.va         = (u64)fence->va;
                               ^
--
   drivers/infiniband/hw/bnxt_re/qplib_fp.c: In function 'do_wa9060':
>> drivers/infiniband/hw/bnxt_re/qplib_fp.c:1612:16: warning: cast to
pointer from integer of different size [-Wint-to-pointer-cast]
         peek_qp = (struct bnxt_qplib_qp *)
                   ^

This appears to be a general problem on 32bit arches (at least i386,
parisc, and xtensa all reported this problem).  Please fix ASAP or I'll
need to remove this patch from the series.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
