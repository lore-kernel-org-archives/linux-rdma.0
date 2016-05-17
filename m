From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 for-next 3/4] IB/core: Support new type of join-state for multicast
Date: Tue, 17 May 2016 15:50:09 -0400
Message-ID: <20160517195008.GB17141@phlsvsds.ph.intel.com>
References: <1463401694-19247-1-git-send-email-erezsh@mellanox.com> <1463401694-19247-4-git-send-email-erezsh@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1463401694-19247-4-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 16, 2016 at 03:28:13PM +0300, Erez Shitrit wrote:
> 
> There are four types for MCG, FullMember, NonMember, SendOnlyNonMember,
> and the new added type: SendOnlyFullMember.
> Add support for the new SendOnlyFullMember join state.
> 
> The new type allows host to send join request as sendonly, it will cause the
> group to be created but without getting packets from this multicast back to the
> host.
> 
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/core/multicast.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
> index 250937c..a83ec28 100644
> --- a/drivers/infiniband/core/multicast.c
> +++ b/drivers/infiniband/core/multicast.c
> @@ -93,6 +93,18 @@ enum {
>  
>  struct mcast_member;
>  
> +/*
> +* There are 4 types of join states:
> +* FullMember, NonMember, SendOnlyNonMember, SendOnlyFullMember.
> +*/
> +enum {
> +	FULLMEMBER_JOIN,
> +	NONMEMBER_JOIN,
> +	SENDONLY_NONMEBER_JOIN,
> +	SENDONLY_FULLMEMBER_JOIN,
> +	NUM_JOIN_MEMBERSHIP_TYPES,
> +};
> +
>  struct mcast_group {
>  	struct ib_sa_mcmember_rec rec;
>  	struct rb_node		node;
> @@ -102,7 +114,7 @@ struct mcast_group {
>  	struct list_head	pending_list;
>  	struct list_head	active_list;
>  	struct mcast_member	*last_join;
> -	int			members[3];
> +	int			members[NUM_JOIN_MEMBERSHIP_TYPES];
>  	atomic_t		refcount;
>  	enum mcast_group_state	state;
>  	struct ib_sa_query	*query;
> @@ -220,8 +232,9 @@ static void queue_join(struct mcast_member *member)
>  }
>  
>  /*
> - * A multicast group has three types of members: full member, non member, and
> - * send only member.  We need to keep track of the number of members of each
> + * A multicast group has four types of members: full member, non member,
> + * sendonly non member and sendonly full member.
> + * We need to keep track of the number of members of each
>   * type based on their join state.  Adjust the number of members the belong to
>   * the specified join states.
>   */
> @@ -229,7 +242,7 @@ static void adjust_membership(struct mcast_group *group, u8 join_state, int inc)
>  {
>  	int i;
>  
> -	for (i = 0; i < 3; i++, join_state >>= 1)
> +	for (i = 0; i < NUM_JOIN_MEMBERSHIP_TYPES; i++, join_state >>= 1)
>  		if (join_state & 0x1)
>  			group->members[i] += inc;
>  }
> @@ -245,7 +258,7 @@ static u8 get_leave_state(struct mcast_group *group)
>  	u8 leave_state = 0;
>  	int i;
>  
> -	for (i = 0; i < 3; i++)
> +	for (i = 0; i < NUM_JOIN_MEMBERSHIP_TYPES; i++)
>  		if (!group->members[i])
>  			leave_state |= (0x1 << i);
>  
> -- 
> 1.7.11.3
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
