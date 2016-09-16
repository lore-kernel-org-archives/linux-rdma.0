From: Knut Omang <knut.omang@oracle.com>
Subject: Re: [PATCH v2 0/8] SIF related verbs patches
Date: Fri, 16 Sep 2016 22:42:02 +0200
Message-ID: <1474058522.20134.47.camel@oracle.com>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
         <92bb7bce-b72f-54e1-59ab-1a93a084b10e@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <92bb7bce-b72f-54e1-59ab-1a93a084b10e@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2016-09-16 at 13:30 -0700, Santosh Shilimkar wrote:
> Hi Knut,
> 
> On 9/16/2016 11:31 AM, Knut Omang wrote:
> > This patch set contains the changes and bug fixes necessary
> > to support Oracle's new Infiniband HCA (SIF) from the kernel side.
> >
> > The exception is patch 3 which is a useful consolidation and simplification
> > made possible by patch 2 and the replacement of the dma_attr type with
> > a plain bitmask.
> >
> > The changes to other rdma drivers are just trivial consequences of
> > the extended umem_get and create_ah calls and should hopefully be
> > uncontroversial.
> >
> > Patches 4-7 are related to corresponding libibverbs patches.
> > These make minor changes (fixing end alignment) to some uverbs
> > data structures, but these are carefully made to be backward
> > binary compatible between user and kernel for existing provider
> > libraries.
> >
> You have missed SOBs on few patches accidentally. You might want to
> fix that for next post :-)
> 
> regards,
> Santosh

An unfortunate side effect of getting going with the otherwise excellent
git series tools that the -ns option I have been using to 'git format-patch'
git lost. 

I have fixed the series for the next post,

Thanks for spotting it,
Knut
