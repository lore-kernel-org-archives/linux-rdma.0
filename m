From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 06/14] i40iw: Get rid of unique barrier macros
Date: Fri, 3 Mar 2017 15:22:44 -0700
Message-ID: <20170303222244.GA678@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-7-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170301172920.GA11340@ssaleem-MOBL4.amr.corp.intel.com>
 <20170301175521.GB14791@obsidianresearch.com>
 <20170301221420.GA18548@ssaleem-MOBL4.amr.corp.intel.com>
 <20170301230506.GB2820@obsidianresearch.com>
 <20170303214514.GA12996@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170303214514.GA12996-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 03, 2017 at 03:45:14PM -0600, Shiraz Saleem wrote:

> This is not quite how our DB logic works. There are additional HW
> steps and nuances in the flow. Unfortunately, to explain this, we
> need to provide details of our internal HW flow for the DB logic. We
> are unable to do so at this time.

Well, it is very problematic to help you define what a cross-arch
barrier should do if you can't explain what you need to have happen
relative to PCI-E.

> > I get the feeling this approach requires MFENCE to do something it
> > doesn't...
> 
> Mfence guarantees that load won't be reordered before the store, and
> thus we are using it.

If that is all then the driver can use LFENCE and the
udma_from_device_barrier() .. Is that OK?

But fundamentally, PCI is fairly lax about what it permits the root
complex to do, and to what degree it requires strong ordering within
the root complex itself for PCI issued LOAD/STORES.

It is hard to understand how the order of CPU operations matters when
the PCI operations to different cache lines can be re-ordered inside
the root complex.

An approach may work on some x86-64 systems but be unreliable on other
arches, or even on unusual x86 (eg SGI's x86 NUMA systems have
conformant, but lax, ordering rules)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
