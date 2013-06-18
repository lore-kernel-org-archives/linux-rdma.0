From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Allow arbitrary int values for MTU
Date: Tue, 18 Jun 2013 12:49:28 -0600
Message-ID: <20130618184928.GE2204@obsidianresearch.com>
References: <1371502807-17026-1-git-send-email-jsquyres@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1371502807-17026-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 17, 2013 at 02:00:07PM -0700, Jeff Squyres wrote:
> Keep IBV_MTU_* enums values as they are, but pass MTU values around as
> int's.  This is an ABI-compatible change; legacy applications will use
> the enum values, but newer applications can use an int for values that
> do not currently exist in the enum set (e.g., 1500, 9000).
> 
> (if people like the idea of this patch, I will send the corresponding
> kernel patch)
> 
> Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
>  examples/devinfo.c         | 11 +++++++++--
>  examples/pingpong.c        | 12 ------------
>  examples/pingpong.h        |  1 -
>  examples/rc_pingpong.c     |  8 ++++----
>  examples/srq_pingpong.c    |  8 ++++----
>  examples/uc_pingpong.c     |  8 ++++----
>  examples/ud_pingpong.c     |  2 +-
>  include/infiniband/verbs.h | 20 +++++++++++++++++---
>  man/ibv_modify_qp.3        |  2 +-
>  man/ibv_query_port.3       |  4 ++--
>  man/ibv_query_qp.3         |  2 +-
>  src/libibverbs.map         |  3 +++
>  src/verbs.c                | 24 ++++++++++++++++++++++++
>  13 files changed, 70 insertions(+), 35 deletions(-)
> 
> diff --git a/examples/devinfo.c b/examples/devinfo.c
> index ff078e4..b856c82 100644
> +++ b/examples/devinfo.c
> @@ -111,15 +111,22 @@ static const char *atomic_cap_str(enum ibv_atomic_cap atom_cap)
>  	}
>  }
>  
> -static const char *mtu_str(enum ibv_mtu max_mtu)
> +static const char *mtu_str(int max_mtu)

This is simpler:

{
	static char str[16];
	snprintf(str, sizeof(str), "%d", ibv_mtu_to_num(max_mtu));
        return str;
}

You may want to replace 'enum ibv_mtu' with 'ibv_mtu_t' to make it
more clear that it is not an integer.

> -	enum ibv_mtu		 mtu = IBV_MTU_1024;
> +	int			 mtu = 1024;

No, you must keep using IBV_MTU_1024 for all cases requesting a 1024
byte MTU, new libraries will accept both, old libraries will only
accept IBV_MTU_1024, so we must stick with IBV_MTU_1024 in
applications.

So:

int			 mtu = num_to_ibv_mtu(1024);

> -			mtu = pp_mtu_to_enum(strtol(optarg, NULL, 0));
> +			mtu = strtol(optarg, NULL, 0);
>  			if (mtu < 0) {
>  				usage(argv[0]);
>  				return 1;

Same deal, add 'mtu =  num_to_ibv_mtu(mtu);'

Same two comments repeated many times.
  
> +/**
> + * ibv_num_to_mtu - If an MTU enum value for "num" is available,
> + * return it (e.g., 1024 -> IBV_MTU_1024).  Otherwise, return num
> + * (e.g., 1500 -> 1500).
> + */
> +int num_to_ibv_mtu(int num);

Probably should be ibv_num_to_mtu() to keep with the naming pattern..

> +
> +/**
> + * ibv_mtu_to_num - Return the numeric value of a symbolic enum
> + * ibv_mtu name (e.g., IBV_MTU_1024 -> 1024).  If a non-symbolic enum
> + * value is passed, just return the same value (e.g., 1500 -> 1500).
> + */
> +int ibv_mtu_to_num(int mtu);

These should be static inlines, not externs. There is a desire to not
add new symbols to libibverbs.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
