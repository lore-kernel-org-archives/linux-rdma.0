From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] librdmacm/rsockets: Add support for MSG_WAITALL
 rrecv() flag
Date: Fri, 17 Aug 2012 12:30:45 -0700
Message-ID: <1345231845.1128.3.camel@oc1677441337.ibm.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A89A52@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A89A52-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2012-08-16 at 22:51 +0000, Hefty, Sean wrote:
> Adapted from patch by Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> 
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

> ---
> The diff makes the changes look bigger than they are.  I used a loop,
> kept my state check, and fixed how rbuf_bytes_avail gets updated.
> 
>  src/rsocket.c |   71 +++++++++++++++++++++++++++++++--------------------------
>  1 files changed, 38 insertions(+), 33 deletions(-)
> 
> diff --git a/src/rsocket.c b/src/rsocket.c
> index 996cb2f..4c4821b 100644
> --- a/src/rsocket.c
> +++ b/src/rsocket.c
> @@ -1131,43 +1131,48 @@ ssize_t rrecv(int socket, void *buf, size_t len, int flags)
>  		}
>  	}
>  	fastlock_acquire(&rs->rlock);
> -	if (!rs_have_rdata(rs)) {
> -		ret = rs_get_comp(rs, rs_nonblocking(rs, flags), rs_conn_have_rdata);
> -		if (ret)
> -			goto out;
> -	}
> -
> -	ret = 0;
> -	if (flags & MSG_PEEK) {
> -		left = len - rs_peek(rs, buf, len);
> -		goto out;
> -	}
> +	do {
> +		if (!rs_have_rdata(rs)) {
> +			ret = rs_get_comp(rs, rs_nonblocking(rs, flags),
> +					  rs_conn_have_rdata);
> +			if (ret)
> +				break;
> +		}
>  
> -	for (; left && rs_have_rdata(rs); left -= rsize) {
> -		if (left < rs->rmsg[rs->rmsg_head].data) {
> -			rsize = left;
> -			rs->rmsg[rs->rmsg_head].data -= left;
> -		} else {
> -			rs->rseq_no++;
> -			rsize = rs->rmsg[rs->rmsg_head].data;
> -			if (++rs->rmsg_head == rs->rq_size + 1)
> -				rs->rmsg_head = 0;
> +		ret = 0;
> +		if (flags & MSG_PEEK) {
> +			left = len - rs_peek(rs, buf, left);
> +			break;
>  		}
>  
> -		end_size = rs->rbuf_size - rs->rbuf_offset;
> -		if (rsize > end_size) {
> -			memcpy(buf, &rs->rbuf[rs->rbuf_offset], end_size);
> -			rs->rbuf_offset = 0;
> -			buf += end_size;
> -			rsize -= end_size;
> -			left -= end_size;
> +		for (; left && rs_have_rdata(rs); left -= rsize) {
> +			if (left < rs->rmsg[rs->rmsg_head].data) {
> +				rsize = left;
> +				rs->rmsg[rs->rmsg_head].data -= left;
> +			} else {
> +				rs->rseq_no++;
> +				rsize = rs->rmsg[rs->rmsg_head].data;
> +				if (++rs->rmsg_head == rs->rq_size + 1)
> +					rs->rmsg_head = 0;
> +			}
> +
> +			end_size = rs->rbuf_size - rs->rbuf_offset;
> +			if (rsize > end_size) {
> +				memcpy(buf, &rs->rbuf[rs->rbuf_offset], end_size);
> +				rs->rbuf_offset = 0;
> +				buf += end_size;
> +				rsize -= end_size;
> +				left -= end_size;
> +				rs->rbuf_bytes_avail += end_size;
> +			}
> +			memcpy(buf, &rs->rbuf[rs->rbuf_offset], rsize);
> +			rs->rbuf_offset += rsize;
> +			buf += rsize;
> +			rs->rbuf_bytes_avail += rsize;
>  		}
> -		memcpy(buf, &rs->rbuf[rs->rbuf_offset], rsize);
> -		rs->rbuf_offset += rsize;
> -		buf += rsize;
> -	}
> -	rs->rbuf_bytes_avail += len - left;
> -out:
> +
> +	} while (left && (flags & MSG_WAITALL) && (rs->state & rs_connect_rd));
> +
>  	fastlock_release(&rs->rlock);
>  	return ret ? ret : len - left;
>  }
> 
> 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
