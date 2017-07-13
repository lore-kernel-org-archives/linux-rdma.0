From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v1 rdma-next] bnxt_re: Fix -Wimplicit-fallthrough warnings
 in GCC 7.1
Date: Thu, 13 Jul 2017 08:52:39 -0700
Message-ID: <9a724b44-3284-d551-93a3-14f30d4cc9d5@wdc.com>
References: <20170713154722.10294-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170713154722.10294-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/13/17 08:47, Leon Romanovsky wrote:
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

Reviewed-by: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
