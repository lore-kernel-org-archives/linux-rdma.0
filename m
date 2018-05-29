From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/mad: Use ID allocator routines to allocate agent
 number
Date: Tue, 29 May 2018 10:40:32 -0600
Message-ID: <20180529164032.GB18457@ziepe.ca>
References: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
 <20180529154922.GA18457@ziepe.ca>
 <A470D739-D0CD-42EE-9196-8E7610B6DAF4@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A470D739-D0CD-42EE-9196-8E7610B6DAF4@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Cc: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, Doug Ledford <dledford@redhat.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Daniel Jurgens <danielj@mellanox.com>, Parav Pandit <parav@mellanox.com>, Pravin Shedge <pravin.shedge4linux@gmail.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 29, 2018 at 06:16:14PM +0200, Håkon Bugge wrote:
>
> > On 29 May 2018, at 17:49, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > 
> > On Tue, May 29, 2018 at 09:38:08AM +0200, Hans Westgaard Ry wrote:
> >> The agent TID is a 64 bit value split in two dwords.  The least
> >> significant dword is the TID running counter. The most significant
> >> dword is the agent number. In the CX-3 shared port model, the mlx4
> >> driver uses the most significant byte of the agent number to store the
> >> slave number, making agent numbers greater and equal to 2^24 (3 bytes)
> >> unusable.
> > 
> > There is no reason for this to be an ida, just do something like
> > 
> > mad_agent_priv->agent.hi_tid = atomic_inc_return(&ib_mad_client_id) & mad_agent_priv->ib_dev->tid_mask;
> > 
> > And have the driver set tid_mask to 3 bytes of 0xFF
> 
> The issue is that some of the mad agents are long-lived, so you will
> wrap and use the same TID twice.

We already have that problem, and using ida is problematic because we
need to maximize the time between TID re-use, which ida isn't doing.

Preventing re-use seems like a seperate issue from limiting the range
to be compatible with mlx4.

Jason
