From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC rdma-core 2/2] verbs: Introduce non-contiguous memory
 registration
Date: Thu, 11 Jan 2018 09:44:55 -0700
Message-ID: <20180111164455.GA1309@ziepe.ca>
References: <1515088046-26605-1-git-send-email-alexma@mellanox.com>
 <1515088046-26605-2-git-send-email-alexma@mellanox.com>
 <20180111122206.GB2800@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180111122206.GB2800@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 11, 2018 at 02:22:07PM +0200, Yuval Shaia wrote:
> > +The following code example demonstrates non-contiguous memory registration,
> > +by combining two contiguous regions, along with the WR-based completion semantic:
> > +.PP
> > +.nf
> > +mr1 = ibv_reg_mr(pd, addr1, len1, 0);
> > +if (!mr1) {
> > +        fprintf(stderr, "Failed to create MR #1\en");
> > +        return 1;
> > +}
> > +
> > +mr2 = ibv_reg_mr(pd, addr2, len2, 0);
> > +if (!mr2) {
> > +        fprintf(stderr, "Failed to create MR #2\en");
> > +        return 1;
> > +}
> 
> So, to register non-contiguous 512 random buffers i would have to create
> 512 MRs?

That is a fair point - I wonder if some of these API should have an
option to accept a pointer directly? Maybe the driver requires a MR
but we don't need that as an the API?

Particularly the _sg one..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
