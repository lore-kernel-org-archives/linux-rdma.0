From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH RESEND] infiniband:core:Add needed error path in
 cm_init_av_by_path
Date: Wed, 16 Dec 2015 11:16:44 -0700
Message-ID: <20151216181644.GF32594@obsidianresearch.com>
References: <1450194724-7107-1-git-send-email-xerofoify@gmail.com>
 <5670420A.7040202@profitbricks.com>
 <20151215173022.GB25965@obsidianresearch.com>
 <56713C5F.5020507@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56713C5F.5020507@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Nicholas Krause <xerofoify@gmail.com>, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, haggaie@mellanox.com, matanb@mellanox.com, doront@mellanox.com, david.ahern@oracle.com, erezsh@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 16, 2015 at 11:26:39AM +0100, Michael Wang wrote:
> 
> On 12/15/2015 06:30 PM, Jason Gunthorpe wrote:
> > On Tue, Dec 15, 2015 at 05:38:34PM +0100, Michael Wang wrote:
> >> The hop_limit is only suggest that the package allowed to be
> >> routed, not have to, correct?
> > 
> > If the hop limit is >= 2 (?) then the GRH is mandatory. The
> > SM will return this information in the PathRecord if it determines a
> > GRH is required. The whole stack follows this protocol.
> > 
> > The GRH is optional for in-subnet communications.
> 
> Thanks for the explain :-)
> 
> I've rechecked the ib_init_ah_from_path() again, and found it
> still set IB_AH_GRH when the GID cache missing, but with:

How do you mean?

                ah_attr->ah_flags = IB_AH_GRH;
                ah_attr->grh.dgid = rec->dgid;

                ret = ib_find_cached_gid(device, &rec->sgid, ndev, &port_num,
                                         &gid_index);
                if (ret) {
                        if (ndev)
                                dev_put(ndev);
                        return ret;
                }

If find_cached_gid fails then ib_init_ah_from_path also fails.

Is there a case where ib_find_cached_gid can succeed but not return
good data?

I agree it would read nicer if the ah_flags and gr.dgid was moved
after the ib_find_cached_gid

> BTW, cma_sidr_rep_handler() also call ib_init_ah_from_path() with out
> a check on return.

That sounds like a problem.

Jason
