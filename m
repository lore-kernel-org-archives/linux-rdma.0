From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] bnxt_re: Fix -Wimplicit-fallthrough warnings
 in GCC 7.1
Date: Thu, 13 Jul 2017 11:51:22 -0600
Message-ID: <20170713175122.GD11069@obsidianresearch.com>
References: <20170713133935.1206-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170713133935.1206-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 04:39:35PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> [59/189] Building C object providers/bnxt_re/CMakeFiles/bnxt_re-rdmav2.dir/verbs.c.o
> ../providers/bnxt_re/verbs.c: In function ‘bnxt_re_post_send’:
> ../providers/bnxt_re/verbs.c:1222:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
>     hdr->key_immd = htole32(be32toh(wr->imm_data));
>                   ^
> ../providers/bnxt_re/verbs.c:1223:3: note: here
>    case IBV_WR_SEND:
>    ^~~~
> ../providers/bnxt_re/verbs.c:1232:18: warning: this statement may fall through [-Wimplicit-fallthrough=]
>     hdr->key_immd = htole32(be32toh(wr->imm_data));
>                   ^
> ../providers/bnxt_re/verbs.c:1233:3: note: here
>    case IBV_WR_RDMA_WRITE:


Can you follow the same approach as I used in

commit 47cd2efcd4cd416ead0a1a48153aa27a2e178ce5
Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date:   Tue Jan 31 14:55:50 2017 -0700

    Annotate correct switch fall throughs with SWITCH_FALLTHROUGH

Or convert those cases to this approach?

>  			 * LE platform be32toh will do the job.
>  			 */
>  			hdr->key_immd = htole32(be32toh(wr->imm_data));
> +			/* FALLTHROUGH */

Use the SWITCH_FALLTHROUGH; macro

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
