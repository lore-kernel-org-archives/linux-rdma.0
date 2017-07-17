From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.4 29/57] RDMA/uverbs: Check port number supplied by
 user verbs cmds
Date: Mon, 17 Jul 2017 21:22:15 +0200
Message-ID: <20170717192215.GA2535@kroah.com>
References: <20170713153957.515045341@linuxfoundation.org>
 <20170713153959.566717957@linuxfoundation.org>
 <5C5647B5F4794941BAAC07CF28785CBC33E4E81F@fmsmsx101.amr.corp.intel.com>
 <20170713162540.GB22870@kroah.com>
 <32E1700B9017364D9B60AED9960492BC34341BF7@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC34341BF7@fmsmsx120.amr.corp.intel.com>
Sender: stable-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: "Ismail, Mustafa" <mustafa.ismail@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Yevgeny Kliteynik <kliteyn@mellanox.com>, Tziporet Koren <tziporet@mellanox.com>, Alex Polak <alexpo@mellanox.com>, Boris Pismenny <borisp@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 17, 2017 at 05:30:45PM +0000, Marciniszyn, Mike wrote:
> > Subject: Re: [PATCH 4.4 29/57] RDMA/uverbs: Check port number supplied
> > by user verbs cmds
> > 
> > On Thu, Jul 13, 2017 at 03:54:28PM +0000, Ismail, Mustafa wrote:
> > > > Subject: [PATCH 4.4 29/57] RDMA/uverbs: Check port number supplied
> > by
> > > > user verbs cmds
> > > >
> > > > 4.4-stable review patch.  If anyone has any objections, please let me
> > know.
> > >
> > > Yes, this breaks modify qp.
> > > See https://patchwork.kernel.org/patch/9830663/
> > 
> > I don't understand this response at all, sorry.
> > 
> > What should I do about this?  Is this patch alone a problem?  Is there
> > some other patch I should apply that is in Linus's tree?  Where is the
> > problem, only in this old release?
> > 
> > totally confused,
> > 
> 
> This patch utterly breaks qib and hfi1 on at least 4.10.11 stable kernel.
> 
> I suspect and will soon verify that v4.13-rc1 is broke as well.

it should be broken, see the patches submitted already to fix it :)
