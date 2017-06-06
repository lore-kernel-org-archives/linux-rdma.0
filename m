From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] libibverbs IB Device Memory support
Date: Tue, 6 Jun 2017 10:34:28 -0600
Message-ID: <20170606163428.GD8671@obsidianresearch.com>
References: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com>
 <20170605172058.GB20477@obsidianresearch.com>
 <20170606055229.GT6868@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170606055229.GT6868-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 06, 2017 at 08:52:29AM +0300, Leon Romanovsky wrote:
> On Mon, Jun 05, 2017 at 11:20:58AM -0600, Jason Gunthorpe wrote:
> > On Wed, May 10, 2017 at 02:25:23PM +0300, ahmad omary wrote:
> >
> > > struct ibv_dm *ibv_alloc_dm(struct ibv_context *context,
> > >    struct ibv_alloc_dm_attr *dm_attr);
> > >
> > > struct ibv_alloc_dm_attr{
> > > size_t length;
> > > uint32_t comp_mask; /*enable future extensions*/
> > > }
> >
> > Can we please stop this madness where every function call needs to
> > accept a struct?
> >
> > It is perfectly fine to add new function calls if new arguments are
> > needed someday.
> 
> IMHO, generally speaking, it is better and cleaner to have similar functions
> signatures for all APIs which is exported to user.

No, I don't think so.. The APIs should be simple to use first, in this
case we don't need a struct to pass 1 value.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
