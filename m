From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 2/2] IB/core: Support for CMA multicast join flags
Date: Mon, 4 Jul 2016 00:46:31 +0300
Message-ID: <CAJ3xEMitNu8HACD3EZ1kQGU4o-VyDphWFUN7qn94+LpBSV4E=w@mail.gmail.com>
References: <1467550074-24061-1-git-send-email-leon@kernel.org> <1467550074-24061-3-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467550074-24061-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 3, 2016 at 3:47 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> Added UCMA and CMA support for multicast join flags. Flags are
> passed using UCMA CM join command previously reserved fields.
> Currently supporting two join flags indicating two different
> multicast JoinStates:
[...]

> --- a/include/rdma/ib_sa.h
> +++ b/include/rdma/ib_sa.h

> +#define IB_SA_MCMEMBER_REC_JOIN_STATE_FULL_MEMBER       BIT(0)
> +#define IB_SA_MCMEMBER_REC_JOIN_STATE_NON_MEMBER        BIT(1)
> +#define IB_SA_MCMEMBER_REC_JOIN_STATE_SO_NON_MEMBER     BIT(2)
> +#define IB_SA_MCMEMBER_REC_JOIN_STATE_SO_FULL_MEMBER    BIT(3)
> +

can we somehow avoid repeating defining these join states in 2-3
places and either make the code introduced in commit  cd6e9b7ef
"IB/core: Support new type of join-state for multicast"

--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -93,6 +93,18 @@ enum {

 struct mcast_member;

+/*
+* There are 4 types of join states:
+* FullMember, NonMember, SendOnlyNonMember, SendOnlyFullMember.
+*/
+enum {
+ FULLMEMBER_JOIN,
+ NONMEMBER_JOIN,
+ SENDONLY_NONMEBER_JOIN,
+ SENDONLY_FULLMEMBER_JOIN,
+ NUM_JOIN_MEMBERSHIP_TYPES,
+};

to use the above defines, or the code added by this patch to use the
enum Erez added, or both code pieces to be re-written and use some
shared enum/define?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
