From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/mlx5: Expose extended error counters
Date: Fri, 28 Jul 2017 14:26:40 -0400
Message-ID: <1501266400.2593.43.camel@redhat.com>
References: <20170619041937.10120-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170619041937.10120-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-06-19 at 07:19 +0300, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This patch adds below requester and responder side error counters,
> which will be exposed by hardware counters interface and are
> supported
> as part of query Q counters command extension.
> 
>  +---------------------------+-------------------------------------+
>  |      Name                 |           Description               |
>  |---------------------------+-------------------------------------|
>  |resp_local_length_error    | Number of times responder detected  |
>  |                           | local length errors                 |
>  |---------------------------+-------------------------------------|
>  |resp_cqe_error             | Number of CQEs completed with error |
>  |                           | at responder                        |
>  |---------------------------+-------------------------------------|
>  |req_cqe_error              | Number of CQEs completed with error |
>  |                           | at requester                        |
>  |---------------------------+-------------------------------------|
>  |req_remote_invalid_request | Number of times requester detected  |
>  |                           | remote invalid request error        |
>  |---------------------------+-------------------------------------|
>  |req_remote_access_error    | Number of times requester detected  |
>  |                           | remote access error                 |
>  |---------------------------+-------------------------------------|
>  |resp_remote_access_error   | Number of times responder detected  |
>  |                           | remote access error                 |
>  |---------------------------+-------------------------------------|
>  |resp_cqe_flush_error       | Number of CQEs completed with       |
>  |                           | flushed with error at responder     |
>  |---------------------------+-------------------------------------|
>  |req_cqe_flush_error        | Number of CQEs completed with       |
>  |                           | flushed with error at requester     |
>  +---------------------------+-------------------------------------+
> 
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
