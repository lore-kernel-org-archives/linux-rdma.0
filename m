From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH v2] net/mlx5: Delete unneeded function argument
Date: Thu, 16 Aug 2018 12:00:07 +0300
Message-ID: <20180816090006.GB4318@lap1>
References: <20180815150854.30993-1-yuval.shaia@oracle.com>
 <ebbc0eff-eacf-fd30-bb03-bd7ef9e6c3c0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ebbc0eff-eacf-fd30-bb03-bd7ef9e6c3c0@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Gal Pressman <pressmangal@gmail.com>
Cc: saeedm@mellanox.com, leon@kernel.org, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 16, 2018 at 09:41:34AM +0300, Gal Pressman wrote:
> On 15-Aug-18 18:08, Yuval Shaia wrote:
> > priv argument is not used by the function, delete it.
> > 
> > Fixes: a89842811ea98 ("net/mlx5e: Merge per priority stats groups")
> > Signed-off-by: Yuval Shaia <yuval.shaia@oracle.com>
> 
> nit: prefix should be net/mlx5e.

1. Will do.
2. Why? (asking since dir name is mlx5)

> 
> > ---
> > v1 -> v2:
> > 	* Remove blank line as pointed by Leon.
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> > index 1646859974ce..4c4d779dafa8 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> > @@ -813,7 +813,7 @@ static const struct counter_desc pport_per_prio_traffic_stats_desc[] = {
> >  
> >  #define NUM_PPORT_PER_PRIO_TRAFFIC_COUNTERS	ARRAY_SIZE(pport_per_prio_traffic_stats_desc)
> >  
> > -static int mlx5e_grp_per_prio_traffic_get_num_stats(struct mlx5e_priv *priv)
> > +static int mlx5e_grp_per_prio_traffic_get_num_stats(void)
> >  {
> >  	return NUM_PPORT_PER_PRIO_TRAFFIC_COUNTERS * NUM_PPORT_PRIO;
> >  }
> > @@ -971,7 +971,7 @@ static int mlx5e_grp_per_prio_pfc_fill_stats(struct mlx5e_priv *priv,
> >  
> >  static int mlx5e_grp_per_prio_get_num_stats(struct mlx5e_priv *priv)
> >  {
> > -	return mlx5e_grp_per_prio_traffic_get_num_stats(priv) +
> > +	return mlx5e_grp_per_prio_traffic_get_num_stats() +
> >  		mlx5e_grp_per_prio_pfc_get_num_stats(priv);
> >  }
> >  
> > 
> 
