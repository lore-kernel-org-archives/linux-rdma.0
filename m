From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [for-next V2 08/10] linux/dim: Implement rdma_dim
Date: Wed, 26 Jun 2019 14:57:36 +0300
Message-ID: <CAJ3xEMhrZgUkekCh+-bUFataSAWZA_xx9sCCzRfkjnE0Lz7M2w@mail.gmail.com>
References: <20190625205701.17849-1-saeedm@mellanox.com> <20190625205701.17849-9-saeedm@mellanox.com>
 <bfa2159e-1576-6b3c-c85b-ee98bd4f9a47@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <bfa2159e-1576-6b3c-c85b-ee98bd4f9a47@grimberg.me>
Sender: netdev-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Tal Gilboa <talgi@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yamin Friedman <yaminf@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Idan Burstein <idanb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 26, 2019 at 1:03 AM Sagi Grimberg <sagi@grimberg.me> wrote:
>
> > +void rdma_dim(struct dim *dim, u64 completions)
> > +{
> > +     struct dim_sample *curr_sample = &dim->measuring_sample;
> > +     struct dim_stats curr_stats;
> > +     u32 nevents;
> > +
> > +     dim_update_sample_with_comps(curr_sample->event_ctr + 1,
> > +                                  curr_sample->pkt_ctr,
> > +                                  curr_sample->byte_ctr,
> > +                                  curr_sample->comp_ctr + completions,
> > +                                  &dim->measuring_sample);
>
> If this is the only caller, why add pkt_ctr and byte_ctr at all?

Hi Sagi,

Thanks for the fast review and feedback, other than the default per
ib/rdma device setup for rdma
dim / adaptive-moderation for which Idan commented on (and lets
discuss it there please) seems
the rest of the comments are fine and Yamin will respond / address
them in the coming days.

Or.
