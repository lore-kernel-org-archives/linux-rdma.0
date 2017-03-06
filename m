From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-core 06/14] i40iw: Get rid of unique barrier macros
Date: Mon, 6 Mar 2017 13:16:31 -0600
Message-ID: <20170306191631.GB34252@ssaleem-MOBL4.amr.corp.intel.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-7-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170301172920.GA11340@ssaleem-MOBL4.amr.corp.intel.com>
 <20170301175521.GB14791@obsidianresearch.com>
 <20170301221420.GA18548@ssaleem-MOBL4.amr.corp.intel.com>
 <20170301230506.GB2820@obsidianresearch.com>
 <20170303214514.GA12996@ssaleem-MOBL4.amr.corp.intel.com>
 <20170303222244.GA678@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170303222244.GA678-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 03, 2017 at 03:22:44PM -0700, Jason Gunthorpe wrote:
> On Fri, Mar 03, 2017 at 03:45:14PM -0600, Shiraz Saleem wrote:
> 
> > This is not quite how our DB logic works. There are additional HW
> > steps and nuances in the flow. Unfortunately, to explain this, we
> > need to provide details of our internal HW flow for the DB logic. We
> > are unable to do so at this time.
> 
> Well, it is very problematic to help you define what a cross-arch
> barrier should do if you can't explain what you need to have happen
> relative to PCI-E.
> 

Unfortunately, we can help with this only at the point when this information 
is made public. If you must have an explanation for all barriers defined in 
utils, an option here is to leave this barrier in i40iw and migrate it to 
utils when documentation is available. 

> > Mfence guarantees that load won't be reordered before the store, and
> > thus we are using it.
> 
> If that is all then the driver can use LFENCE and the
> udma_from_device_barrier() .. Is that OK?
>

The write valid WQE needs to be globally visible before read tail. LFENCE does not 
guarantee this. MFENCE does.

https://software.intel.com/sites/default/files/managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf

LFENCE (Vol. 3A 8-16)
"Serializes all load (read) operations that occurred prior to the LFENCE instruction 
in the program instruction stream, but does not affect store operations"

LFENCE (Vol. 2A 3-529)
"An LFENCE that follows an instruction that stores to memory might complete before 
the data being stored have become globally visible. Instructions following an LFENCE 
may be fetched from memory before the LFENCE, but they will not execute until the LFENCE 
completes"	

MFENCE (Vol. 2B 4-22)
"This serializing operation guarantees that every load and store instruction that precedes 
the MFENCE instruction in program order becomes globally visible before any load or store 
instruction that follows the MFENCE instruction"



 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
